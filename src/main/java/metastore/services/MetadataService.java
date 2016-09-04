package metastore.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Joiner;
import metastore.models.*;
import metastore.repositories.CustomerIdTypeRepository;
import metastore.repositories.EventTypeRepository;
import metastore.repositories.FileDatasetRepository;
import metastore.repositories.TableDataSourceRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.joda.time.LocalDateTime;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.PropertyAccessorFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class MetadataService {

    private static final Log log = LogFactory.getLog(MetadataService.class);

    private static final String PROCESSING_EXT = ".processing";

    private static final String HDFS_NETWORK = "hdfs";

    @Autowired
    FileDatasetRepository fileDatasetRepository;

    @Autowired
    TableDataSourceRepository tableDataSourceRepository;

    @Autowired
    EventTypeRepository eventTypeRepository;

    @Autowired
    CustomerIdTypeRepository customerIdTypeRepository;

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Autowired
    @Qualifier("statsJdbcTemplate")
    JdbcTemplate targetJdbcTemplate;

    @Autowired
    KeyValueStore keyValueStore;

    // TODO

    /**
     * Reindex elasticsearch
     */
    public void reindex() {}

    public FileDataset findDatasetsByFilename(String filename) {
        if (log.isDebugEnabled()) {
            log.debug("Searching datasets for filename \"" + filename + "\"");
        }
        for (FileDataset fileDataset : fileDatasetRepository.findAll()) {
            FileDataSource fileDataSource = fileDataset.getDataSource();
            if (fileDataSource != null) {
                String filenamePattern = fileDataSource.getFilenamePattern();
                if (filenamePattern != null) {
                    String network = fileDataSource.getNetwork();
                    if (network != null) {
                        network = network.toLowerCase();
                    }
                    if (!filenamePattern.endsWith(PROCESSING_EXT) && !HDFS_NETWORK.equals(network)) {
                        filenamePattern += PROCESSING_EXT;
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("Matching against pattern /" + filenamePattern + "/");
                    }
                    Pattern p = Pattern.compile(filenamePattern, Pattern.CASE_INSENSITIVE);
                    Matcher matches = p.matcher(filename);
                    if (matches.find(0)) {
                        if (log.isDebugEnabled()) {
                            log.debug("Found matching dataset '" + fileDataset.getName() + "'");
                        }
                        return fileDataset;
                    }
                }
            }
        }
        log.warn("Couldn't find a matching dataset for " + filename);
        return null;
    }

    private Object latestValue(AuditedModel source, AuditedModel target, String propertyName) {
        BeanWrapper s = PropertyAccessorFactory.forBeanPropertyAccess(source);
        BeanWrapper t = PropertyAccessorFactory.forBeanPropertyAccess(target);
        Object sourceValue = s.getPropertyValue(propertyName);
        Object targetValue = t.getPropertyValue(propertyName);
        if (targetValue == null) return sourceValue;
        if (source.getModified() != null) {
            if (target.getModified() == null ||
                    source.getModified().after(target.getModified())) {
                return sourceValue;
            }
        }
        return targetValue;
    }

    private Map<Integer, String> getSSUGroupByEventTypeId() {
        Map<Integer, String> ssuGroupMap = new HashMap<Integer, String>();
        for (FileDataset dataset : fileDatasetRepository.findAll()) {
            for (EventType eventType : dataset.getEventTypes()) {
                //ssuGroupMap.put(eventType.getId(), dataset.getSsuReady());

                String ssuGroup = getSsuGroup(dataset);
                ssuGroupMap.put(eventType.getId(), ssuGroup);
            }
        }
        return ssuGroupMap;
    }

    private Map<Integer, FileDataset> getDatasetByEventTypeId() {
        Map<Integer, FileDataset> datasetMap = new HashMap<Integer, FileDataset>();
        for (FileDataset dataset : fileDatasetRepository.findAll()) {
            for (EventType eventType : dataset.getEventTypes()) {
                datasetMap.put(eventType.getId(), dataset);
            }
        }
        return datasetMap;
    }

    private String getEventPropertyTypeList(FileDataset dataset) {
        List<String> propertyTypes = new ArrayList<String>();
        if (dataset.getColumns() != null) {
            for (FileColumn column : dataset.getColumns()) {
                for (EventPropertyType propertyType : column.getEventPropertyTypes()) {
                    if (propertyType.getMappingExpression() != null) {
                        propertyTypes.add(column.getName());
                        break;
                    }
                }
            }
        }
        return Joiner.on(',').join(propertyTypes);
    }

    public void mergeCustomerIdTypes() {
        Map<Integer, CustomerIdType> publishedCustomerIdTypes = readPublishedCustomerIdTypes();
        Set<Integer> activeCustomerIdTypeIds = new HashSet<Integer>();
        for (CustomerIdType s : customerIdTypeRepository.findAll()) {
            Integer id = s.getId();
            activeCustomerIdTypeIds.add(id);
            if (publishedCustomerIdTypes.containsKey(id)) {
                CustomerIdType t = publishedCustomerIdTypes.get(id);
                CustomerIdType parent = (CustomerIdType) latestValue(s, t, "parent");
                DataType dataType = (DataType) latestValue(s, t, "dataType");
                ValueType valueType = (ValueType) latestValue(s, t, "valueType");
                targetJdbcTemplate.update(
                        "UPDATE cxp.customer_id_types SET customer_id_type_name=?,description=?,composite=?,composition_rule=?,parent_id=?,data_type_id=?,value_type_id=?,process_name=?,created_ts=?,created_by=?,modified_ts=?,modified_by=? WHERE customer_id_type_id=?",
                        latestValue(s, t, "name"),
                        latestValue(s, t, "description"),
                        latestValue(s, t, "composite"),
                        latestValue(s, t, "compositionRule"),
                        parent == null ? null : parent.getId(),
                        dataType == null ? null : dataType.getId(),
                        valueType == null ? null : valueType.getId(),
                        latestValue(s, t, "processName"),
                        latestValue(s, t, "created"),
                        latestValue(s, t, "createdBy"),
                        latestValue(s, t, "modified"),
                        latestValue(s, t, "modifiedBy"),
                        id);
            } else {
                targetJdbcTemplate.update(
                        "INSERT INTO cxp.customer_id_types(customer_id_type_id,customer_id_type_name,description,composite,composition_rule,parent_id,data_type_id,value_type_id,process_name,created_ts,created_by,modified_ts,modified_by) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",
                        id,
                        s.getName(),
                        s.getDescription(),
                        s.isComposite(),
                        s.getCompositionRule(),
                        s.getParent() == null ? null : s.getParent().getId(),
                        s.getDataType() == null ? null : s.getDataType().getId(),
                        s.getValueType() == null ? null : s.getValueType().getId(),
                        s.getProcessName(),
                        s.getCreated(),
                        s.getCreatedBy(),
                        s.getModified(),
                        s.getModifiedBy());
            }
        }
        for (CustomerIdType type : publishedCustomerIdTypes.values()) {
            if (!activeCustomerIdTypeIds.contains(type.getId())) {
                targetJdbcTemplate.update(
                        "UPDATE cxp.customer_id_types SET marked_for_deletion = ? WHERE customer_id_type_id=?",
                        true, type.getId());
            }
        }
    }

    public void mergeJobs() {
        List<Long> targetJobIds = targetJdbcTemplate.queryForList("SELECT job_id FROM cxp.jobs", Long.class);
        List<Map<String, Object>> sourceJobs;
        if (targetJobIds == null || targetJobIds.isEmpty()) {
            if (log.isDebugEnabled()) {
                log.debug("No job IDs found in target");
            }
            sourceJobs = jdbcTemplate.queryForList("SELECT * FROM cxp.jobs");
        } else {
            if (log.isDebugEnabled()) {
                log.debug(targetJobIds.size() + " job IDs in target");
            }
            NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate);
            MapSqlParameterSource parameters = new MapSqlParameterSource();
            parameters.addValue("ids", targetJobIds);
            sourceJobs = namedParameterJdbcTemplate.queryForList(
                    "SELECT * FROM cxp.jobs WHERE job_id NOT IN (:ids)",
                    parameters);
        }
        if (log.isDebugEnabled()) {
            log.debug(sourceJobs.size() + " jobs to insert from source");
        }
        for (Map<String, Object> row : sourceJobs) {
            if (log.isDebugEnabled()) {
                log.debug(".");
            }
            targetJdbcTemplate.update(
                    "INSERT INTO cxp.jobs(job_id,dataset_id,source_filename,process_name,job_start_ts,job_end_ts,job_status,exit_message,records_processed,records_skipped,events_created,errors_logged) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
                    row.get("job_id"),
                    row.get("dataset_id"),
                    row.get("source_filename"),
                    row.get("process_name"),
                    row.get("job_start_ts"),
                    row.get("job_end_ts"),
                    row.get("job_status"),
                    row.get("exit_message"),
                    row.get("records_processed"),
                    row.get("records_skipped"),
                    row.get("events_created"),
                    row.get("errors_logged"));
        }
    }

    public void mergeEventTypes() {
        Map<Integer, EventType> publishedEventTypes = readPublishedEventTypes();
        //Map<Integer, String> ssuGroupMap = getSSUGroupByEventTypeId();
        Map<Integer, FileDataset> datasetMap = getDatasetByEventTypeId();
        Set<Integer> activeEventTypeIds = new HashSet<Integer>();
        for (EventType s : eventTypeRepository.findAll()) {
            Integer id = s.getId();
            activeEventTypeIds.add(id);
            FileDataset dataset = datasetMap.get(id);

            //String ssuGroup = ssuGroupMap.get(id);

            String ssuGroup = getSsuGroup(dataset);

            if (publishedEventTypes.containsKey(id)) {
                EventType t = publishedEventTypes.get(id);
                ValueType valueType = (ValueType) latestValue(s, t, "valueType");
                // TODO
                // determine if an update is required
                targetJdbcTemplate.update(
                        "UPDATE cxp.event_types SET namespace=?,event_type=?,description=?,ssu_group=?,value_type_id=?,customer_id_type_id1=?,customer_id_expression1=?,customer_id_type_id2=?,customer_id_expression2=?,filter_expression=?,value_expression=?,ts_expression=?,datetime_format=?,timezone=?,event_value_desc=?,marked_for_deletion=?,process_name=?,created_ts=?,created_by=?,modified_ts=?,modified_by=? WHERE event_type_id=?",
                        latestValue(s, t, "namespace"),
                        latestValue(s, t, "name"),
                        latestValue(s, t, "description"),
                        ssuGroup,
                        valueType == null ? null : valueType.getId(),
                        latestValue(s, t, "customerIdType1Id"),
                        latestValue(s, t, "customerIdExpression1"),
                        latestValue(s, t, "customerIdType2Id"),
                        latestValue(s, t, "customerIdExpression2"),
                        latestValue(s, t, "filterExpression"),
                        latestValue(s, t, "valueExpression"),
                        latestValue(s, t, "tsExpression"),
                        latestValue(s, t, "datetimeFormat"),
                        latestValue(s, t, "timezone"),

                        // TODO
                        // should not be updated once set
                        dataset == null ? null : getEventPropertyTypeList(dataset),

                        false,
                        latestValue(s, t, "processName"),
                        latestValue(s, t, "created"),
                        latestValue(s, t, "createdBy"),
                        latestValue(s, t, "modified"),
                        latestValue(s, t, "modifiedBy"),
                        id);
            } else {
                targetJdbcTemplate.update(
                        "INSERT INTO cxp.event_types(event_type_id,namespace,event_type,description,ssu_group,value_type_id,customer_id_type_id1,customer_id_expression1,customer_id_type_id2,customer_id_expression2,filter_expression,value_expression,ts_expression,datetime_format,timezone,event_value_desc,marked_for_deletion,process_name,created_ts,created_by,modified_ts,modified_by) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                        id,
                        s.getNamespace(),
                        s.getName(),
                        s.getDescription(),
                        ssuGroup,
                        s.getValueType() == null ? null : s.getValueType().getId(),
                        s.getCustomerIdType1Id(),
                        s.getCustomerIdExpression1(),
                        s.getCustomerIdType2Id(),
                        s.getCustomerIdExpression2(),
                        s.getFilterExpression(),
                        s.getValueExpression(),
                        s.getTsExpression(),
                        s.getDatetimeFormat(),
                        s.getTimezone(),
                        dataset == null ? null : getEventPropertyTypeList(dataset),
                        false,
                        s.getProcessName(),
                        s.getCreated(),
                        s.getCreatedBy(),
                        s.getModified(),
                        s.getModifiedBy());
            }
        }
        for (EventType eventType : publishedEventTypes.values()) {
            if (!activeEventTypeIds.contains(eventType.getId())) {
                targetJdbcTemplate.update(
                        "UPDATE cxp.event_types SET marked_for_deletion = ? WHERE event_type_id=?",
                        true, eventType.getId());
            }
        }
    }

    public Map<Integer, EventType> readPublishedEventTypes() {
        List<EventType> eventTypes = targetJdbcTemplate.query("SELECT * FROM cxp.event_types", new RowMapper<EventType>() {
            @Override
            public EventType mapRow(ResultSet rs, int rowNum) throws SQLException {
                EventType eventType = new EventType();
                eventType.setId(rs.getInt("event_type_id"));
                eventType.setNamespace(rs.getString("namespace"));
                eventType.setName(rs.getString("event_type"));
                eventType.setDescription(rs.getString("description"));
                Integer valueTypeId = rs.getInt("value_type_id");
                if (valueTypeId > 0) {
                    ValueType valueType = new ValueType();
                    valueType.setId(valueTypeId);
                    eventType.setValueType(valueType);
                }
                Integer customerIdType1Id = rs.getInt("customer_id_type_id1");
                if (customerIdType1Id > 0) {
                    CustomerIdType customerIdType = new CustomerIdType();
                    customerIdType.setId(customerIdType1Id);
                    eventType.setCustomerIdType1(customerIdType);
                }
                eventType.setCustomerIdExpression1(rs.getString("customer_id_expression1"));
                Integer customerIdType2Id = rs.getInt("customer_id_type_id2");
                if (customerIdType2Id > 0) {
                    CustomerIdType customerIdType = new CustomerIdType();
                    customerIdType.setId(customerIdType1Id);
                    eventType.setCustomerIdType2(customerIdType);
                }
                eventType.setCustomerIdExpression1(rs.getString("customer_id_expression2"));
                eventType.setFilterExpression(rs.getString("filter_expression"));
                eventType.setValueExpression(rs.getString("value_expression"));
                eventType.setTsExpression(rs.getString("ts_expression"));
                eventType.setDatetimeFormat(rs.getString("datetime_format"));
                eventType.setTimezone(rs.getString("timezone"));
                eventType.setProcessName(rs.getString("process_name"));
                eventType.setCreated(rs.getDate("created_ts"));
                eventType.setCreatedBy(rs.getString("created_by"));
                eventType.setModified(rs.getDate("modified_ts"));
                eventType.setModifiedBy(rs.getString("modified_by"));
                return eventType;
            }
        });
        Map<Integer, EventType> eventTypeMap = new HashMap<Integer, EventType>();
        for (EventType eventType : eventTypes) {
            eventTypeMap.put(eventType.getId(), eventType);
        }
        return eventTypeMap;
    }

    public Map<Integer, CustomerIdType> readPublishedCustomerIdTypes() {
        List<CustomerIdType> customerIdTypes = targetJdbcTemplate.query("SELECT * FROM cxp.customer_id_types", new RowMapper<CustomerIdType>() {
            @Override
            public CustomerIdType mapRow(ResultSet rs, int rowNum) throws SQLException {
                CustomerIdType customerIdType = new CustomerIdType();
                customerIdType.setId(rs.getInt("customer_id_type_id"));
                customerIdType.setName(rs.getString("customer_id_type_name"));
                customerIdType.setDescription(rs.getString("description"));
                customerIdType.setComposite(rs.getBoolean("composite"));
                customerIdType.setCompositionRule(rs.getString("composition_rule"));
                Integer parentId = rs.getInt("parent_id");
                if (parentId > 0) {
                    CustomerIdType parent = new CustomerIdType();
                    parent.setId(parentId);
                    customerIdType.setParent(parent);
                }
                Integer dataTypeId = rs.getInt("data_type_id");
                if (dataTypeId > 0) {
                    DataType dataType = new DataType();
                    dataType.setId(dataTypeId);
                    customerIdType.setDataType(dataType);
                }
                Integer valueTypeId = rs.getInt("value_type_id");
                if (valueTypeId > 0) {
                    ValueType valueType = new ValueType();
                    valueType.setId(valueTypeId);
                    customerIdType.setValueType(valueType);
                }
                customerIdType.setProcessName(rs.getString("process_name"));
                customerIdType.setCreated(rs.getDate("created_ts"));
                customerIdType.setCreatedBy(rs.getString("created_by"));
                customerIdType.setModified(rs.getDate("modified_ts"));
                customerIdType.setModifiedBy(rs.getString("modified_by"));
                return customerIdType;
            }
        });
        Map<Integer, CustomerIdType> customerIdTypeMap = new HashMap<Integer, CustomerIdType>();
        for (CustomerIdType type : customerIdTypes) {
            customerIdTypeMap.put(type.getId(), type);
        }
        return customerIdTypeMap;
    }

    public Stats refreshStats() {
        if (log.isDebugEnabled()) {
            log.debug("refreshing stats");
        }
        Integer numberDatasets;
        try {
            numberDatasets = jdbcTemplate.queryForObject(
                    "SELECT count(*) FROM meta.datasets",
                    Integer.class
            );
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            numberDatasets = 0;
        }
        if (numberDatasets == null) numberDatasets = 0;
        if (log.isDebugEnabled()) {
            log.debug("numberDatasets: " + numberDatasets);
        }
        Long totalRecordsProcessed;
        try {
            totalRecordsProcessed = targetJdbcTemplate.queryForObject(
                    "SELECT sum(records_processed) FROM cxp.jobs WHERE job_status='FINISHED'",
                    Long.class
            );
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            totalRecordsProcessed = 0L;
        }
        if (totalRecordsProcessed == null) totalRecordsProcessed = 0L;
        if (log.isDebugEnabled()) {
            log.debug("totalRecordsProcessed: " + totalRecordsProcessed);
        }
        List<Map<String, Object>> totalEventsByTypeRows;
        try {
            totalEventsByTypeRows = targetJdbcTemplate.queryForList(
                    "SELECT t.event_type, count(*) AS total_events FROM cxp.events e JOIN cxp.event_types t ON t.event_type_id = e.event_type_id GROUP BY t.event_type ORDER BY t.event_type"
            );
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            totalEventsByTypeRows = new ArrayList<Map<String, Object>>();
        }
        Long totalEvents = 0L;
        Map<String, Long> totalEventsByType = new HashMap<String, Long>();
        for (Map row : totalEventsByTypeRows) {
            Long k = (Long)row.get("total_events");
            totalEvents += k;
            totalEventsByType.put((String)row.get("event_type"), k);
        }
        String start = null;
        try {
            Date startts = targetJdbcTemplate.queryForObject(
                    "SElECT event_ts FROM cxp.events ORDER BY event_ts LIMIT 1",
                    Date.class
            );
            LocalDateTime startdt = LocalDateTime.fromDateFields(startts);
            start = startdt.toString();
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            // do nothing
        }
        String end = null;
        try {
            Date endts = targetJdbcTemplate.queryForObject(
                    "SElECT event_ts FROM cxp.events ORDER BY event_ts DESC LIMIT 1",
                    Date.class
            );
            LocalDateTime enddt = LocalDateTime.fromDateFields(endts);
            end = enddt.toString();
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            // do nothing
        }
        List<Map<String, Object>> totalEventsByMonthRows;
        try {
            totalEventsByMonthRows = targetJdbcTemplate.queryForList(
                    "SElECT extract(year from event_ts) || '-' || extract(month from event_ts) AS month, count(*) AS total_events FROM cxp.events GROUP BY extract(year from event_ts) || '-' || extract(month from event_ts) ORDER BY extract(year from event_ts) || '-' || extract(month from event_ts);"
            );
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            totalEventsByMonthRows = new ArrayList<Map<String, Object>>();
        }
        Map<String, Long> totalEventsByMonth = new HashMap<String, Long>();
        for (Map row : totalEventsByMonthRows) {
            Long k = (Long)row.get("total_events");
            totalEventsByMonth.put((String)row.get("month"), k);
        }
        if (log.isDebugEnabled()) {
            log.debug("totalEventsByMonth.count " + totalEventsByMonth.size());
        }
        List<Map<String, Object>> totalEventsByDayRows;
        try {
            totalEventsByDayRows = targetJdbcTemplate.queryForList(
                    "SElECT extract(month from event_ts) || '-' || extract(day from event_ts) AS day, count(*) AS total_events FROM cxp.events WHERE event_ts::date > (CURRENT_DATE - INTERVAL '90 day')::date GROUP BY extract(month from event_ts) || '-' || extract(day from event_ts) ORDER BY extract(month from event_ts) || '-' || extract(day from event_ts);"
            );
        } catch (DataAccessException e) {
            log.warn(e.getMessage(), e);
            totalEventsByDayRows = new ArrayList<Map<String, Object>>();
        }
        Map<String, Long> totalEventsByDay = new HashMap<String, Long>();
        for (Map row : totalEventsByDayRows) {
            Long k = (Long)row.get("total_events");
            totalEventsByDay.put((String)row.get("day"), k);
        }
        if (log.isDebugEnabled()) {
            log.debug("totalEventsByDay.count " + totalEventsByDay.size());
        }

        ObjectMapper mapper = new ObjectMapper();
        try {
            Map<String, Object> values = keyValueStore.createValuesMap(
                    "numberDatasets", numberDatasets,
                    "totalRecordsProcessed", totalRecordsProcessed,
                    "totalEvents", totalEvents,
                    "totalEventsByType", mapper.writeValueAsString(totalEventsByType),
                    "start", start,
                    "end", end,
                    "totalEventsByMonth", mapper.writeValueAsString(totalEventsByMonth),
                    "totalEventsByDay", mapper.writeValueAsString(totalEventsByDay)
            );
            keyValueStore.writeKeyValues(values);
        } catch (JsonProcessingException e) {
            log.warn("Couldn't cache statistics", e);
            e.printStackTrace();
        }

        return new Stats(numberDatasets, totalRecordsProcessed, totalEvents, totalEventsByType,
                start, end, totalEventsByMonth, totalEventsByDay);
    }

    public Stats getStats() throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> currentValues = keyValueStore.getKeyValues();
        if (!currentValues.containsKey("numberDatasets")) {
            return refreshStats();
        }
        Map<String, Long> totalEventsByType =
                mapper.readValue((String)currentValues.get("totalEventsByType"), new TypeReference<HashMap<String, Long>>() {});
        Map<String, Long> totalEventsByMonth =
                mapper.readValue((String)currentValues.get("totalEventsByMonth"), new TypeReference<HashMap<String, Long>>() {});
        Map<String, Long> totalEventsByDay =
                mapper.readValue((String)currentValues.get("totalEventsByDay"), new TypeReference<HashMap<String, Long>>() {});
        return new Stats(
                Integer.parseInt((String)currentValues.get("numberDatasets"), 10),
                Long.parseLong((String) currentValues.get("totalRecordsProcessed"), 10),
                Long.parseLong((String) currentValues.get("totalEvents"), 10),
                totalEventsByType,
                (String)currentValues.get("start"),
                (String)currentValues.get("end"),
                totalEventsByMonth,
                totalEventsByDay
        );
    }

    public String cloneTableDataSource(Long dataSourceId) {
        TableDataSource originalDataSource = tableDataSourceRepository.findOne(dataSourceId);
        TableDataSource clone = new TableDataSource();
        String[] ignoreProperties = new String[] {
                "id", "name", "description", "processName",
                "created", "createdBy", "modified", "modifiedBy"};
        BeanUtils.copyProperties(originalDataSource, clone, ignoreProperties);
        clone.setName(originalDataSource.getName() + " copy");
        clone.setProcessName("cloned");
        tableDataSourceRepository.save(clone);

        return originalDataSource.getName();
    }

    private String getSsuGroup(FileDataset fileDataset) {
        if (fileDataset == null) return null;
        return fileDataset.getSsuReady();
        /*
        ObjectMapper mapper = new ObjectMapper();
        FileDatasetCustomMetadata customMetadata;
        try {
            customMetadata = mapper.readValue(fileDataset.getCustomAttributes(), FileDatasetCustomMetadata.class);
        } catch (IOException e) {
            e.printStackTrace();
            log.warn(e.getMessage(), e);
            return null;
        }
        return customMetadata.getSsuReady();*/
    }
}
