package metastore.repositories;

import metastore.models.TableDataSource;
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
@RepositoryRestResource(collectionResourceRel = "table-data-sources", path = "table-data-sources")
public interface TableDataSourceRepository extends PagingAndSortingRepository<TableDataSource, Long> {

    @RestResource(path = "filter", rel = "filter")
    Page<TableDataSource> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);
}
