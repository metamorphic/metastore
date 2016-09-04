package metastore.models;

import org.springframework.data.rest.core.config.Projection;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = FileDataset.class)
public interface RecordClientProjection {

    String getName();

    String getPrefix();

    String getDescription();

    List<FileColumnClientProjection> getColumns();

    List<EventTypeClientProjection> getEventTypes();

}
