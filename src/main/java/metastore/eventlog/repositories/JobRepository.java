package metastore.eventlog.repositories;

import metastore.eventlog.models.Job;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "jobs", path = "jobs")
public interface JobRepository extends PagingAndSortingRepository<Job, Long> {

    // TODO
    // tried various things, keep getting: Executing an update/delete query; TransactionRequiredException
    // using jdbcTemplate in the Service instead
    //@Modifying(clearAutomatically = true)
    //@Query("update Job j set j.status=:status where j.id=:id")
    //public void updateStatus(@Param("id") Long id, @Param("status") String status);
}
