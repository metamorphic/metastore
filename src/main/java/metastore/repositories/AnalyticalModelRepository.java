package metastore.repositories;

import metastore.models.AnalyticalModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "models", path = "models")
public interface AnalyticalModelRepository extends PagingAndSortingRepository<AnalyticalModel, Integer> {

    @RestResource(path = "filter", rel = "filter")
    Page<AnalyticalModel> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
