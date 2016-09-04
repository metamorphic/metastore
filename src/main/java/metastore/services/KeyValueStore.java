package metastore.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Component
public class KeyValueStore {

    private static final Log log = LogFactory.getLog(KeyValueStore.class);

    @Autowired
    JdbcTemplate jdbcTemplate;

    public void writeKeyValues(Map<String, Object> keyValues) {
        Map<String, Object> currentValues = getKeyValues();
        if (log.isDebugEnabled()) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                log.debug("\ncurrentValues");
                log.debug(mapper.writeValueAsString(currentValues));
                log.debug("\nkeyValues");
                log.debug(mapper.writeValueAsString(keyValues));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
                log.debug(e.getMessage(), e);
            }
        }
        for (Map.Entry<String, Object> entry : keyValues.entrySet()) {
            if (currentValues.containsKey(entry.getKey())) {
                jdbcTemplate.update("UPDATE meta.key_values SET value = ?, created_ts = NOW() WHERE key = ?", entry.getValue(), entry.getKey());
            } else {
                jdbcTemplate.update("INSERT INTO meta.key_values (key, value, created_ts) VALUES (?, ?, NOW())", entry.getKey(), entry.getValue());
            }
        }
    }

    public Map<String, Object> getKeyValues() {
        Map<String, Object> currentValues = new HashMap<String, Object>();
        SqlRowSet rs = jdbcTemplate.queryForRowSet("SELECT key, value FROM meta.key_values");
        while (rs.next()) {
            currentValues.put(rs.getString("key"), rs.getString("value"));
        }
        return currentValues;
    }

    public Map<String, Object> createValuesMap(Object... v) {
        Assert.notNull(v);
        Assert.isTrue(v.length % 2 == 0);
        Map<String, Object> values = new HashMap<String, Object>();
        for (int i = 0; i < v.length - 1; i += 2) {
            values.put((String)v[i], v[i + 1]);
        }
        return values;
    }
}
