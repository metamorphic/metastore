package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * Created by markmo on 21/05/15.
 */
@Projection(name = "grid", types = Stream.class)
public interface StreamGridProjection {

    Integer getId();

    String getName();

    String getNamespace();

    String getPollingDirectory();

    String getFilenamePattern();

    boolean isPreventDuplicates();

    String getJob();

    String getDefinition();
}
