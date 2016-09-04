package metastore.controllers;

import metastore.models.Query;
import metastore.services.SQLService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * API to run SQL queries.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RestController
public class SQLController {

    @Autowired
    SQLService sqlService;

    @RequestMapping("/api/sql")
    public @ResponseBody List<Map<String, Object>> query(@RequestParam("q") String q, @RequestParam(value = "username", required = false) String username) {
        return sqlService.query(q, username);
    }

    @RequestMapping("/api/sql/recent")
    public @ResponseBody List<Query> fetchRecentQueries(@RequestParam("username") String username) {
        return sqlService.fetchRecentQueries(username);
    }
}
