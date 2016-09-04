package metastore.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.Types;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class JobService {

    static final String DELETE_STATUS = "DELETED";

    @Autowired
    @Qualifier("statsJdbcTemplate")
    JdbcTemplate jdbcTemplate1;

    @Autowired
    @Qualifier("eventLogJdbcTemplate")
    JdbcTemplate jdbcTemplate2;

    //@Autowired
    //JobRepository jobRepository;

    public int deleteJobEvents(Long jobId) {
        if (jobId == null || jobId == 0) return 0;
        Object[] params = { jobId };
        int[] types = { Types.BIGINT };
        int numberEventsDeleted = jdbcTemplate1.update("DELETE FROM cxp.events WHERE job_id=?", params, types);

        updateJobStatus(jobId, DELETE_STATUS);

        return numberEventsDeleted;
    }

    private void updateJobStatus(Long jobId, String status) {

        // TODO
        // tried various things, keep getting: Executing an update/delete query; TransactionRequiredException
        //jobRepository.updateStatus(jobId, status);

        Object[] params = { status, jobId };
        int[] types = { Types.VARCHAR, Types.BIGINT };
        jdbcTemplate2.update("UPDATE cxp.jobs SET job_status=? WHERE job_id=?", params, types);
    }
}
