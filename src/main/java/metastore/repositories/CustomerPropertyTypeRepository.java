package metastore.repositories;

import metastore.models.CustomerPropertyType;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-property-types", path = "customer-property-types")
public interface CustomerPropertyTypeRepository extends PagingAndSortingRepository<CustomerPropertyType, Long> {
}
