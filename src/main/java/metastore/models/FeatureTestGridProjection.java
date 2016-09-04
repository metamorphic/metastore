package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = FeatureTest.class)
public interface FeatureTestGridProjection {

    Integer getId();

    @Value("#{target.featureType?.name}")
    String getFeatureTypeName();

    @Value("#{target.featureType?.id}")
    Long getFeatureTypeId();

    String getDescription();

    String getStatus();

    String getDbname();

    String getEvalExpression();

    String getWhereExpression();

    String getAuthorName();

    String getAuthorEmail();
}
