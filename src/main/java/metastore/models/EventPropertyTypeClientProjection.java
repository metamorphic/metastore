package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = EventPropertyType.class)
public interface EventPropertyTypeClientProjection {

    Long getId();

    String getName();

//    @Value("#{target.valueType?.name}")
//    String getValueTypeName();

    @Value("#{target.securityClassification?.name}")
    String getSecurityClassificationName();

    String getDescription();

    String getMappingExpression();
}
