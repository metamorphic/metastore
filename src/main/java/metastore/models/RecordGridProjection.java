package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = Record.class)
public interface RecordGridProjection {

    Long getId();

    String getName();

    String getPrefix();

    String getDescription();

    @Value("#{target.dataset?.name}")
    String getDatasetName();

    @Value("#{target.dataset?.id}")
    Long getDatasetId();

    String getEventTypesId();

}
