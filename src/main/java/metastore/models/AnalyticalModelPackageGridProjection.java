package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = AnalyticalModelPackage.class)
public interface AnalyticalModelPackageGridProjection {

    Integer getId();

    String getName();

    String getVersion();

    String getDescription();
}
