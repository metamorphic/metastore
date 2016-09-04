package metastore;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.bind.RelaxedPropertyResolver;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Configuration
public class StatsDataSourceConfiguration implements EnvironmentAware {

    private RelaxedPropertyResolver jpaPropertyResolver;

    @Override
    public void setEnvironment(Environment environment) {
        this.jpaPropertyResolver = new RelaxedPropertyResolver(environment, "spring.jpa.");
    }

    @Bean(name = "statsDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.stats")
    public DataSource statsDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "statsJdbcTemplate")
    public JdbcTemplate statsJdbcTemplate(@Qualifier("statsDataSource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
