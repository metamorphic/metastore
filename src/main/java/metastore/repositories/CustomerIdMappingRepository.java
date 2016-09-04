package metastore.repositories;

import metastore.models.CustomerIdMapping;
import metastore.models.CustomerIdType;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-id-mappings", path = "customer-id-mappings")
public interface CustomerIdMappingRepository extends PagingAndSortingRepository<CustomerIdMapping, Long> {

    List<CustomerIdMapping> findByCustomerIdType1AndCustomerId1(CustomerIdType customerIdType, String customerId);
}
