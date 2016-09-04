package metastore.repositories;

import metastore.models.AnalyticalModelPackage;
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
@RepositoryRestResource(collectionResourceRel = "model-packages", path = "model-packages")
public interface AnalyticalModelPackageRepository extends PagingAndSortingRepository<AnalyticalModelPackage, Integer> {

    @RestResource(path = "filter", rel = "filter")
    Page<AnalyticalModelPackage> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
