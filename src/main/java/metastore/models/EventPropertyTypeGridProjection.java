package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = EventPropertyType.class)
public interface EventPropertyTypeGridProjection {

    Long getId();

    String getName();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.valueType?.id}")
    Integer getValueTypeId();

    @Value("#{target.securityClassification?.name}")
    String getSecurityClassificationName();

    @Value("#{target.securityClassification?.id}")
    Integer getSecurityClassificationId();

    String getDescription();

    String getMappingExpression();

//    String getFirstDatasetName();
}
