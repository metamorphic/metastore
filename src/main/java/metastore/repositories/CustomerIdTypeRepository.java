package metastore.repositories;

import metastore.models.CustomerIdType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-id-types", path = "customer-id-types")
public interface CustomerIdTypeRepository extends PagingAndSortingRepository<CustomerIdType, Integer> {

    List<CustomerIdType> findByName(String name);

    @RestResource(path = "filter", rel = "filter")
    Page<CustomerIdType> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
