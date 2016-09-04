package metastore.repositories;

import metastore.models.CustomerIdMappingRule;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-id-mapping-rules", path = "customer-id-mapping-rules")
public interface CustomerIdMappingRuleRepository extends PagingAndSortingRepository<CustomerIdMappingRule, Integer> {
}
