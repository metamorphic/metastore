package metastore.elasticsearch.repositories;

import metastore.models.EntityDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "entities", path = "entities")
public interface EntityDocumentRepository extends ElasticsearchRepository<EntityDocument, String> {

    @RestResource(path = "content", rel = "content")
    List<EntityDocument> findByNameOrDescription(@Param("name") String name, @Param("desc") String desc);

    //@RestResource(path = "content", rel = "content")
    @Query("{\"multi_match\":{\"query\":\"?0\",\"fields\":[\"name\",\"description\"]}}")
    Page<EntityDocument> findContent(@Param("q") String q, Pageable pageable);
}
