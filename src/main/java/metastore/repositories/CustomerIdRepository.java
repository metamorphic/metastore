package metastore.repositories;

import metastore.models.CustomerId;
import metastore.models.CustomerIdPK;
import metastore.models.CustomerIdType;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public interface CustomerIdRepository extends CrudRepository<CustomerId, CustomerIdPK> {

    List<CustomerId> findByPkCustomerIdTypeAndPkCustomerIdOrderByConfidenceDesc(CustomerIdType customerIdType, String customerId);
}
