package metastore.eventlog.models;

import org.springframework.data.rest.core.config.Projection;

import java.util.Date;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = Job.class)
public interface JobGridProjection {

    Long getId();

    Long getDatasetId();

    String getSourceFilename();

    Date getStart();

    Date getEnd();

    String getStatus();

    Long getRecordsProcessed();

    Long getRecordsSkipped();

    Long getEventsCreated();

    Long getErrorsLogged();

    String getExitMessage();
}
