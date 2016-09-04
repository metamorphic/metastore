package metastore.eventlog.models;

import org.springframework.data.rest.core.config.Projection;

import java.util.Date;

/**
 * Created by markmo on 12/06/15.
 */
@Projection(name = "grid", types = TestJob.class)
public interface TestJobGridProjection {

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
