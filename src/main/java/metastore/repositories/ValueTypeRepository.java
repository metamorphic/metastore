package metastore.repositories;

import metastore.models.ValueType;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "value-types", path = "value-types")
public interface ValueTypeRepository extends PagingAndSortingRepository<ValueType, Integer> {
}
