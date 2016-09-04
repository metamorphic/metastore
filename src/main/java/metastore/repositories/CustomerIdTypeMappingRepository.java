package metastore.repositories;

import metastore.models.CustomerIdTypeMapping;
import metastore.models.CustomerIdTypeMappingPK;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-id-type-mappings", path = "customer-id-type-mappings")
public interface CustomerIdTypeMappingRepository extends CrudRepository<CustomerIdTypeMapping, CustomerIdTypeMappingPK> {
}
