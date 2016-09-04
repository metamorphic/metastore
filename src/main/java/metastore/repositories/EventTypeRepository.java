package metastore.repositories;

import metastore.models.EventType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "event-types", path = "event-types")
public interface EventTypeRepository extends PagingAndSortingRepository<EventType, Integer> {

    EventType findByNameIgnoreCase(String name);

    @RestResource(path = "filter", rel = "filter")
    Page<EventType> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
