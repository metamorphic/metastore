package metastore.eventlog.repositories;

import metastore.eventlog.models.TestJob;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "test-jobs", path = "test-jobs")
public interface TestJobRepository extends PagingAndSortingRepository<TestJob, Long> {

}
