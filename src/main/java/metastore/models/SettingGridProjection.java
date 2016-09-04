package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = Setting.class)
public interface SettingGridProjection {

    String getName();

    String getValue();
}
