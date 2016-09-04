package metastore.elasticsearch;

import metastore.elasticsearch.repositories.EntityDocumentRepository;
import metastore.models.EntityDocument;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import javax.annotation.PostConstruct;
import javax.persistence.PostPersist;
import javax.persistence.PostRemove;
import javax.persistence.PostUpdate;

/**
 * Created by markmo on 2/05/15.
 */
@Component
public class EntityListener {

    private static final Log log = LogFactory.getLog(EntityListener.class);

    // workaround to inject a dependency into a stateless bean
    // http://blog-en.lineofsightnet.com/2012/08/dependency-injection-on-stateless-beans.html
    // It is not possible to inject spring managed beans into a JPA EntityListener class. This is because the JPA listener mechanism should be based on a stateless class, so the methods are effectively static, and non-context aware. ... No amount of AOP will save you, nothing gets injected to the ‘object’ representing the listener, because the implementations don’t actually create instances, but uses the class method.
    private static EntityDocumentRepository entityDocumentRepository;

    @PostConstruct
    public void init() {
        log.info("Initializing with dependency [" + entityDocumentRepository + "]");
    }

    @PostPersist
    public void postPersist(Searchable entity) {
        save(entity);
    }

    @PostUpdate
    public void postUpdate(Searchable entity) {
        save(entity);
    }

    @PostRemove
    public void postRemove(Searchable entity) {
        String type = entity.getClass().getSimpleName();
        entityDocumentRepository.delete(type + ":" + entity.getId());
    }

    private void save(Searchable entity) {
        Assert.notNull(entityDocumentRepository, "EntityDocumentRepository not created");
        EntityDocument doc = new EntityDocument();
        String type = entity.getClass().getSimpleName();
        doc.setType(type);
        doc.setId(type + ":" + entity.getId());
        doc.setName(entity.getName());
        doc.setDescription(entity.getDescription());
        System.out.println("saving document");
        entityDocumentRepository.save(doc);
    }

    @Autowired(required = true)
    @Qualifier("entityDocumentRepository")
    public void setEntityDocumentRepository(EntityDocumentRepository repository) {
        entityDocumentRepository = repository;
    }
}
