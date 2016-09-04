package metastore;

import metastore.models.TransformationListener;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.hibernate.event.service.spi.EventListenerRegistry;
import org.hibernate.event.spi.EventType;
import org.hibernate.internal.SessionFactoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.persistence.EntityManagerFactory;

/**
 * Created by markmo on 8/06/15.
 */
@Component
public class HibernateEventWiring {

    private static final Log log = LogFactory.getLog(HibernateEventWiring.class);

    @Autowired
    @Qualifier("entityManagerFactory")
    private EntityManagerFactory entityManagerFactory;

    @Autowired
    private TransformationListener transformationListener;

    @PostConstruct
    public void registerListeners() {
        if (log.isDebugEnabled()) {
            log.debug(this.getClass().getSimpleName() + ".registerListeners called");
        }
        SessionFactory sessionFactory = entityManagerFactory.unwrap(SessionFactory.class);
        EventListenerRegistry registry = ((SessionFactoryImpl)sessionFactory).getServiceRegistry().getService(EventListenerRegistry.class);
        registry.getEventListenerGroup(EventType.PRE_INSERT).appendListener(transformationListener);
    }
}
