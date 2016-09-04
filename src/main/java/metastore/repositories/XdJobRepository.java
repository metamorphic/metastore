package metastore.repositories;

import metastore.models.XdJob;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "xd-jobs", path = "xd-jobs")
public interface XdJobRepository extends PagingAndSortingRepository<XdJob, Integer> {

    List<XdJob> findByNameIgnoreCase(String name);
}
