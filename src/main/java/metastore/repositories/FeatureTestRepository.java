package metastore.repositories;

import metastore.models.FeatureTest;
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
@RepositoryRestResource(collectionResourceRel = "feature-tests", path = "feature-tests")
public interface FeatureTestRepository extends PagingAndSortingRepository<FeatureTest, Integer> {

    @RestResource(path = "filter", rel = "filter")
    Page<FeatureTest> findByDescriptionContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
