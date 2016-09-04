package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = FeatureFamily.class)
public interface FeatureFamilyGridProjection {

    Integer getId();

    String getName();

    String getWideTableName();

    String getFeatureTypesId();
}
