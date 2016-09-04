package metastore.repositories;

import metastore.models.DataType;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "data-types", path = "data-types")
public interface DataTypeRepository extends PagingAndSortingRepository<DataType, Integer> {
}
