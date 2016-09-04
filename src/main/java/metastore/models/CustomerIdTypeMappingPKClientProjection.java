package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = CustomerIdTypeMappingPK.class)
public interface CustomerIdTypeMappingPKClientProjection {

    @Value("#{target.customerIdType.name}")
    String getCustomerIdTypeName();

    @Value("#{target.customerIdType.id}")
    String getCustomerIdTypeId();
}
