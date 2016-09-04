package metastore.services;

import metastore.models.Query;
import metastore.repositories.QueryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class SQLService {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Autowired
    QueryRepository queryRepository;

    private static final int NUMBER_RECENT_ENTRIES = 99;

    public List<Map<String, Object>> query(String q, String username) {
        if (username != null) {
            Query query = new Query();
            query.setUsername(username);
            query.setQuery(q);
            queryRepository.save(query);
        }
        return jdbcTemplate.queryForList(q);
    }

    public List<Query> fetchRecentQueries(String username) {
        List<Query> recent = queryRepository.findByUsernameOrderByCreatedDesc(username);
        return recent.subList(0, Math.min(NUMBER_RECENT_ENTRIES, recent.size()));
    }
}
