package metastore.repositories;

import metastore.models.CustomerProfile;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "customer-profiles", path = "customer-profiles")
public interface CustomerProfileRepository extends PagingAndSortingRepository<CustomerProfile, Long> {
}
