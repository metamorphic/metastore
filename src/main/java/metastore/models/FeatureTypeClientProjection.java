package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 *         Copyright 2015
 */
@Projection(name = "client", types = FeatureType.class)
public interface FeatureTypeClientProjection {

    Long getId();

    String getName();

    AttributeType getAttributeType();

    String getStatus();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.valueType?.id}")
    Integer getValueTypeId();

    @Value("#{target.dataType?.name}")
    String getDataTypeName();

    @Value("#{target.dataType?.id}")
    Integer getDataTypeId();

    String getColumnName();

    String getFeatureFamiliesId();

    String getFeatureFamiliesName();

    String getTagsId();

    String getTagsName();

}
