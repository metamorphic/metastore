package metastore.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class VisualizationDataService {

    private static final Log log = LogFactory.getLog(VisualizationDataService.class);

    @Autowired
    @Qualifier("eventLogJdbcTemplate")
    JdbcTemplate jdbcTemplate;

    @Autowired
    KeyValueStore keyValueStore;

    ObjectMapper mapper;

    public VisualizationDataService() {
        this.mapper = new ObjectMapper();
    }

    public List<Map<String, Object>> getTimeline(int customerIdTypeId, String customerId) {
        return jdbcTemplate.queryForList("SELECT e.event_type AS content, e.event_ts AS start FROM cxp.customer_joined_events e JOIN cxp.customer_id_mapping m ON m.customer_id_2 = e.siebel_customer_number WHERE m.customer_id_type_id_1 = ? AND m.customer_id_1 = ?", customerIdTypeId, customerId);
    }

    public List<String> getCustomerSample(int customerIdTypeId, int sampleSize, int minInteractions) {
        return jdbcTemplate.queryForList("SELECT e.customer_id from cxp.events e WHERE e.customer_id_type_id = ? GROUP BY e.customer_id HAVING count(*) > ? ORDER BY random() LIMIT ?",
                new Object[] { customerIdTypeId, minInteractions, sampleSize }, String.class);
    }

    public List<Map<String, Object>> getCustomerSample(int sampleSize) {
        return jdbcTemplate.queryForList("SELECT customer_id_type_id, customer_id_type, customer_id, siebel_customer_number FROM (SELECT m.customer_id_type_id_1 AS customer_id_type_id, t.customer_id_type_name AS customer_id_type, m.customer_id_1 AS customer_id, a.siebel_customer_number, row_number() OVER (PARTITION BY a.siebel_customer_number) AS rn FROM cxp.customer_id_mapping m INNER JOIN (SELECT siebel_customer_number FROM (SELECT siebel_customer_number, event_type FROM cxp.customer_joined_events GROUP BY siebel_customer_number, event_type) a GROUP BY siebel_customer_number ORDER BY count(*) DESC LIMIT ?) a ON a.siebel_customer_number = m.customer_id_2 INNER JOIN cxp.customer_id_types t ON t.customer_id_type_id = m.customer_id_type_id_1) b WHERE b.rn = 1;", sampleSize);
    }

    public List<Map<String, Object>> getEventLog(int limit) {
        return jdbcTemplate.queryForList("SELECT siebel_customer_number, event_ts, event_type FROM cxp.customer_joined_events LIMIT ?", limit);
    }

    public Map<String, List<Map<String, Object>>> getEventFlow(int numberPreviousInteractions) throws IOException {
        Map<String, Object> currentValues = keyValueStore.getKeyValues();
        if (currentValues.containsKey("flow")) {
            return mapper.readValue((String) currentValues.get("flow"), new TypeReference<HashMap<String, Object>>() {
            });
        }
        return refreshEventFlow(numberPreviousInteractions);
    }

    public Map<String, Object> getNextEventTree(String eventTypeName, int depth) {
        Map<String, List<String>> map = new HashMap<String, List<String>>();
        SqlRowSet rs = jdbcTemplate.queryForRowSet("SELECT e1.event_type, e2.event_type AS next_event_type FROM cxp.customer_sequenced_events e1 JOIN cxp.customer_sequenced_events e2 ON e2.siebel_customer_number = e1.siebel_customer_number AND e2.rn = (e1.rn - 1) GROUP BY e1.event_type, e2.event_type ORDER BY e1.event_type, e2.event_type;");
        while (rs.next()) {
            String eventType = rs.getString("event_type");
            String nextEventType = rs.getString("next_event_type");
            if (!map.containsKey(eventType)) {
                map.put(eventType, new ArrayList<String>());
            }
            map.get(eventType).add(nextEventType);
        }
        return populateTree(eventTypeName, map, 0, depth);
    }

    private Map<String, Object> populateTree(String name, Map<String, List<String>> map, int level, int maxDepth) {
        Map<String, Object> node = new HashMap<String, Object>();
        if (level < maxDepth) {
            List<Map<String, Object>> children = new ArrayList<Map<String, Object>>();
            for (String child : map.get(name)) {
                children.add(populateTree(child, map, level + 1, maxDepth));
            }
            node.put("children", children);
        }
        node.put("name", name);
        return node;
    }

    public Map<String, List<Map<String, Object>>> refreshEventFlow(int numberPreviousInteractions) throws IOException {
        Map<String, Long> eventTypeCounts = new HashMap<String, Long>();
        SqlRowSet rs1 = jdbcTemplate.queryForRowSet("SELECT t.event_type, count(*) FROM cxp.events e JOIN cxp.event_types t ON t.event_type_id = e.event_type_id GROUP BY t.event_type");
        while (rs1.next()) {
            eventTypeCounts.put(rs1.getString("event_type"), rs1.getLong("count"));
        }
        SqlRowSet rs = jdbcTemplate.queryForRowSet("SELECT event_type_1, event_type_2, event_type_3, event_type_4, event_type_5, count FROM cxp.event_flow_5 LIMIT ?", numberPreviousInteractions);
        Set<String> nodes1 = new LinkedHashSet<String>();
        Set<String> nodes2 = new LinkedHashSet<String>();
        Set<String> nodes3 = new LinkedHashSet<String>();
        Set<String> nodes4 = new LinkedHashSet<String>();
        Set<String> nodes5 = new LinkedHashSet<String>();
        while (rs.next()) {
            boolean first = true;
            for (int i = 1; i < 5; i++) {
                String type = rs.getString("event_type_" + i);
                if (type != null) {
                    if (first) {
                        nodes1.add(type);
                        first = false;
                    } else {
                        switch (i) {
                            case 2:
                                nodes2.add(type);
                                break;
                            case 3:
                                nodes3.add(type);
                                break;
                            case 4:
                                nodes4.add(type);
                                break;
                        }
                    }
                }
            }
            nodes5.add(rs.getString("event_type_5"));
        }
        List<String> nodeList1 = new ArrayList<String>(nodes1);
        List<String> nodeList2 = new ArrayList<String>(nodes2);
        List<String> nodeList3 = new ArrayList<String>(nodes3);
        List<String> nodeList4 = new ArrayList<String>(nodes4);
        List<String> nodeList5 = new ArrayList<String>(nodes5);
        int n1 = nodeList1.size();
        int n2 = nodeList2.size();
        int n3 = nodeList3.size();
        int n4 = nodeList4.size();
        rs.beforeFirst();
        List<Map<String, Object>> links = new ArrayList<Map<String, Object>>();
        while (rs.next()) {
            boolean first = true;
            for (int i = 1; i < 5; i++) {
                String srctype = rs.getString("event_type_" + i);
                String trgtype = rs.getString("event_type_" + (i + 1));
                if (srctype != null) {
                    Map<String, Object> link = new HashMap<String, Object>();
                    if (first) {
                        link.put("source", nodeList1.indexOf(srctype));
                        first = false;
                    } else {
                        switch (i) {
                            case 2:
                                link.put("source", n1 + nodeList2.indexOf(srctype));
                                break;
                            case 3:
                                link.put("source", n1 + n2 + nodeList3.indexOf(srctype));
                                break;
                            case 4:
                                link.put("source", n1 + n2 + n3 + nodeList4.indexOf(srctype));
                        }
                    }
                    switch (i) {
                        case 1:
                            link.put("target", n1 + nodeList2.indexOf(trgtype));
                            break;
                        case 2:
                            link.put("target", n1 + n2 + nodeList3.indexOf(trgtype));
                            break;
                        case 3:
                            link.put("target", n1 + n2 + n3 + nodeList4.indexOf(trgtype));
                            break;
                        case 4:
                            link.put("target", n1 + n2 + n3 + n4 + nodeList5.indexOf(trgtype));
                            break;
                    }
                    link.put("value", rs.getDouble("count") / eventTypeCounts.get(srctype));
                    links.add(link);
                }
            }
        }
        List<String> nodeList = new ArrayList<String>();
        nodeList.addAll(nodeList1);
        nodeList.addAll(nodeList2);
        nodeList.addAll(nodeList3);
        nodeList.addAll(nodeList4);
        nodeList.addAll(nodeList5);
        List<Map<String, Object>> nodes = new ArrayList<Map<String, Object>>();
        for (String name : nodeList) {
            Map<String, Object> node = new HashMap<String, Object>();
            node.put("name", name);
            nodes.add(node);
        }
        Map<String, List<Map<String, Object>>> ret = new HashMap<String, List<Map<String, Object>>>();
        ret.put("nodes", nodes);
        ret.put("links", links);

        try {
            Map<String, Object> values = keyValueStore.createValuesMap(
                    "flow", mapper.writeValueAsString(ret)
            );
            keyValueStore.writeKeyValues(values);
        } catch (JsonProcessingException e) {
            e.printStackTrace();

            // TODO
            if (log.isDebugEnabled()) {
                log.debug("Couldn't cache event flow");
            }
        }

        return ret;
    }
}
