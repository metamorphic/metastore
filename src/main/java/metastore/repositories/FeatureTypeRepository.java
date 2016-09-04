package metastore.repositories;

import metastore.models.FeatureType;
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
@RepositoryRestResource(collectionResourceRel = "feature-types", path = "feature-types")
public interface FeatureTypeRepository extends PagingAndSortingRepository<FeatureType, Long> {

    @RestResource(path = "filter", rel = "filter")
    Page<FeatureType> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
