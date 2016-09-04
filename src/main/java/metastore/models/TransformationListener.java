package metastore.models;

import com.google.common.base.Joiner;
import metastore.services.DatabaseService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.event.spi.PreInsertEvent;
import org.hibernate.event.spi.PreInsertEventListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by markmo on 6/06/15.
 */
@Component
public class TransformationListener implements PreInsertEventListener {

    private static final Log log = LogFactory.getLog(TransformationListener.class);

    // workaround to inject a dependency into a stateless bean
    // http://blog-en.lineofsightnet.com/2012/08/dependency-injection-on-stateless-beans.html
    // It is not possible to inject spring managed beans into a JPA EntityListener class. This is because the JPA listener mechanism should be based on a stateless class, so the methods are effectively static, and non-context aware. ... No amount of AOP will save you, nothing gets injected to the ‘object’ representing the listener, because the implementations don’t actually create instances, but uses the class method.
    private static JdbcTemplate jdbcTemplate;

    private static DatabaseService databaseService;

    @Override
    public boolean onPreInsert(PreInsertEvent event) {
        if (log.isDebugEnabled()) {
            log.debug(this.getClass().getSimpleName() + ".onPreInsert called");
        }
        Assert.notNull(jdbcTemplate);
        Object entity = event.getEntity();
        if (log.isDebugEnabled()) {
            log.debug("with type " + entity.getClass().getName());
        }
        if (entity instanceof Transformation && false) {
            Transformation transformation = (Transformation)entity;
            if (log.isDebugEnabled()) {
                log.debug("New Dataset Name: " + transformation.getNewDatasetName());
                log.debug("Create As: " + transformation.getCreateAs());
                log.debug("Routine: " + transformation.getRoutine());
                log.debug("Language: " + transformation.getLanguage());
                log.debug("isCreate? " + (transformation.isCreate() ? "YES" : "NO"));
            }
            if (transformation.isCreate() && "SQL".equals(transformation.getLanguage())) {
                String routine = transformation.getRoutine();
                String createAs = transformation.getCreateAs();
                try {
                    if ("VIEW".equals(createAs)) {
                        List<SqlStatementMetadata> metadataList = databaseService.getMetadata(routine);
                        SqlStatementMetadata metadata = metadataList.get(0);

                        databaseService.createDataset(metadata);

                        String sql = String.format(
                                "CREATE VIEW %s AS %s",
                                transformation.getNewDatasetName(), routine);
                        if (log.isDebugEnabled()) {
                            log.debug("Executing:\n" + sql);
                        }
                        jdbcTemplate.execute(sql);

                    } else if ("TABLE".equals(createAs)) {
                        List<SqlStatementMetadata> metadataList = databaseService.getMetadata(routine);
                        SqlStatementMetadata metadata = metadataList.get(0);

                        databaseService.createDataset(metadata);

                        List<String> columns = new ArrayList<String>();
                        for (SqlColumnMetadata column : metadata.getSqlColumnMetadataList()) {
                            columns.add(column.getColumnName());
                        }

                        StringBuilder sql = new StringBuilder("SELECT ");
                        sql.append(Joiner.on(',').join(columns));
                        sql.append(" INTO ").append(transformation.getNewDatasetName());
                        sql.append(routine.substring(routine.indexOf("FROM") - 1));
                        if (log.isDebugEnabled()) {
                            log.debug("Execute:\n" + sql);
                        }
                        jdbcTemplate.execute(sql.toString());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    log.error(e.getMessage(), e);
                }
            }
        }
        return false;
    }

    @Autowired(required = true)
    @Qualifier("jdbcTemplate")
    public void setJdbcTemplate(JdbcTemplate template) {
        jdbcTemplate = template;
    }

    @Autowired(required = true)
    public void setDatabaseService(DatabaseService service) {
        databaseService = service;
    }
}
