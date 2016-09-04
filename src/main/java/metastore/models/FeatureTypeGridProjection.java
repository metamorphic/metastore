package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = FeatureType.class)
public interface FeatureTypeGridProjection {

    Long getId();

    String getName();

    AttributeType getAttributeType();

    String getStatus();

    @Value("#{target.securityClassification?.name}")
    String getSecurityClassificationName();

    @Value("#{target.securityClassification?.id}")
    Integer getSecurityClassificationId();

    @Value("#{target.customerIdType?.name}")
    String getCustomerIdTypeName();

    @Value("#{target.customerIdType?.id}")
    Integer getCustomerIdTypeId();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.valueType?.id}")
    Integer getValueTypeId();

    String getColumnName();

    String getDescription();

    String getReferenceType();

    String getReference();

    String getAuthorName();

    String getAuthorEmail();

    Language getLanguage();

    String getDbname();

    String getExpression();

    String getFeatureFamiliesId();

    String getTagsId();

    String getDependenciesId();
}
