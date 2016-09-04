package metastore.repositories;

import metastore.models.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public interface QueryRepository extends CrudRepository<Query, Integer> {

    List<Query> findByUsernameOrderByCreatedDesc(String username);
}
