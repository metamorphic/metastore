package metastore.models;

import org.springframework.data.rest.core.config.Projection;

/**
 * Created by markmo on 21/05/15.
 */
@Projection(name = "grid", types = XdJob.class)
public interface XdJobGridProjection {

    Integer getId();

    String getName();

    String getJarLocation();

    boolean isMakeUnique();
}
