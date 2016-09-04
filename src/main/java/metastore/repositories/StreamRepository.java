package metastore.repositories;

import metastore.models.Stream;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "streams", path = "streams")
public interface StreamRepository extends PagingAndSortingRepository<Stream, Integer> {

    List<Stream> findByNamespace(String namespace);
}
