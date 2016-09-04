package metastore.repositories;

import metastore.models.Dataset;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * Created by markmo on 6/06/15.
 */
@RepositoryRestResource(collectionResourceRel = "datasets", path = "datasets")
public interface DatasetRepository extends PagingAndSortingRepository<Dataset, Long> {
}
