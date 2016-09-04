package metastore.repositories;

import metastore.models.EventPropertyType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "event-property-types", path = "event-property-types")
public interface EventPropertyTypeRepository extends PagingAndSortingRepository<EventPropertyType, Long> {

    List<EventPropertyType> findByNameIgnoreCase(String name);

    @RestResource(path = "filter", rel = "filter")
    Page<EventPropertyType> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);

//    @RestResource(path = "by-dataset", rel = "by-dataset")
//    @Query(value = "select * from cxp.event_property_types t join meta.event_property_types_columns tc on tc.property_type_id = t.property_type_id join meta.data_columns c on c.column_id = tc.column_id where c.dataset_id = :id", nativeQuery = true)
//    Page<EventPropertyType> findByDatasetId(@Param("id") Long id, Pageable pageable);
}
