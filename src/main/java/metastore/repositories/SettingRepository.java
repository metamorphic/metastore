package metastore.repositories;

import metastore.models.Setting;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RepositoryRestResource(collectionResourceRel = "settings", path = "settings")
public interface SettingRepository extends PagingAndSortingRepository<Setting, String> {
}
