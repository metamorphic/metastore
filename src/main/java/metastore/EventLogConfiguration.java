package metastore;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.autoconfigure.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.boot.bind.RelaxedPropertyResolver;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.orm.jpa.hibernate.SpringNamingStrategy;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;

import javax.sql.DataSource;
import java.util.Map;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Configuration
@EnableJpaRepositories(basePackages = "metastore.eventlog.repositories", entityManagerFactoryRef = "emf2")
public class EventLogConfiguration implements EnvironmentAware {

    private RelaxedPropertyResolver jpaPropertyResolver;

    @Override
    public void setEnvironment(Environment environment) {
        this.jpaPropertyResolver = new RelaxedPropertyResolver(environment, "spring.jpa.");
    }

    @Bean(name = "eventLogDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.eventlog")
    public DataSource eventLogDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "emf2")
    public LocalContainerEntityManagerFactoryBean emf2(EntityManagerFactoryBuilder builder) {
        LocalContainerEntityManagerFactoryBean bean = builder
                .dataSource(eventLogDataSource())
                .packages("metastore.eventlog.models")
                .persistenceUnit("eventlog")
                .build();
        Map<String, Object> properties = bean.getJpaPropertyMap();
        properties.put("hibernate.ejb.naming_strategy", jpaPropertyResolver.getProperty("hibernate.naming-strategy", SpringNamingStrategy.class.getName()));
//        properties.put("hibernate.hbm2ddl.auto", jpaPropertyResolver.getProperty("hibernate.ddl-auto", "none"));
        return bean;
    }

    @Bean(name = "eventLogJdbcTemplate")
    public JdbcTemplate eventLogJdbcTemplate(@Qualifier("eventLogDataSource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
