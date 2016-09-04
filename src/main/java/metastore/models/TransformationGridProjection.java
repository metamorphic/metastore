package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * Created by markmo on 5/06/15.
 */
@Projection(name = "grid", types = Transformation.class)
public interface TransformationGridProjection {

    Long getId();

    String getName();

    String getDescription();

    String getInputDatasetsId();

    String getInputDatasetsName();

    @Value("#{target.outputDataset?.name}")
    String getOutputDatasetName();

    @Value("#{target.outputDataset?.id}")
    Long getOutputDatasetId();

    String getRoutine();

    String getReference();

    String getLanguage();

    String getLeadCommitter();

    String getContactEmail();

    String getRepo();

    String getCommitHash();

    int getVersion();
}
