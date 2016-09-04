package metastore.repositories;

import metastore.models.Transformation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * Created by markmo on 5/06/15.
 */
@RepositoryRestResource(collectionResourceRel = "transformations", path = "transformations")
public interface TransformationRepository extends PagingAndSortingRepository<Transformation, Long> {

    @RestResource(path = "filter", rel = "filter")
    Page<Transformation> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
