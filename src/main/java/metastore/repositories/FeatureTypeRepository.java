package metastore.repositories;

import metastore.models.FeatureType;
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
 *         Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "feature-types", path = "feature-types")
public interface FeatureTypeRepository extends PagingAndSortingRepository<FeatureType, Long> {

    @RestResource(path = "filter", rel = "filter")
    Page<FeatureType> findByNameContainingIgnoreCase(@Param("q") String name, Pageable pageable);

    @RestResource(path = "by-column-name", rel = "by-column-name")
    List<FeatureType> findByColumnNameIgnoreCase(@Param("name") String name);

    @RestResource(path = "by-tag-name", rel = "by-tag-name")
    @Query("select f from FeatureType f join f.tags t where t.name = :name")
    List<FeatureType> findByTagName(@Param("name") String name);

    @RestResource(path = "by-tag-id", rel = "by-tag-id")
    @Query("select f from FeatureType f join f.tags t where t.id = :id")
    List<FeatureType> findByTagId(@Param("id") Integer id);

    @RestResource(path = "by-family-name", rel = "by-family-name")
    @Query("select f from FeatureType f join f.featureFamilies ff where ff.name = :name")
    List<FeatureType> findByFamilyName(@Param("name") String name);

    @RestResource(path = "by-family-id", rel = "by-family-id")
    @Query("select f from FeatureType f join f.featureFamilies ff where ff.id = :id")
    List<FeatureType> findByFamilyId(@Param("id") Integer id);

}
