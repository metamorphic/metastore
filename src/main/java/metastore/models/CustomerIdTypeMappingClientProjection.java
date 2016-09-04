package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = CustomerIdTypeMapping.class)
public interface CustomerIdTypeMappingClientProjection {

    CustomerIdTypeMappingPKClientProjection getPk();

    String getCustomerIdExpression();
}
