package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = AnalyticalModel.class)
public interface AnalyticalModelGridProjection {

    Integer getId();

    String getName();

    String getVersion();

    String getCommitter();

    String getContactPerson();

    String getDescription();

    boolean isEnsemble();

    String getPackagesId();

    String getRelatedModelsId();
}
