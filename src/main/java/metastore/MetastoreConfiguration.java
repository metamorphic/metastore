package metastore;

import com.fasterxml.jackson.datatype.hibernate4.Hibernate4Module;
import io.metamorphic.fileservices.FileService;
import io.metamorphic.fileservices.FileServiceImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.web.client.RestTemplate;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 *         Copyright 2015
 */
@Configuration
@EnableElasticsearchRepositories(basePackages = "metastore/elasticsearch/repositories")
public class MetastoreConfiguration {

    @Bean
    public FileService fileService() {
        return new FileServiceImpl();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    /**
     * Enables JSON serialization of lazily fetched properties
     *
     * @return Jackson2ObjectMapperBuilder
     */
    @Bean
    public Jackson2ObjectMapperBuilder configureObjectMapper() {
        /*
        SimpleModule module = new SimpleModule();
        module.setDeserializerModifier(new BeanDeserializerModifier() {
            @Override
            public JsonDeserializer<?> modifyDeserializer(DeserializationConfig config, BeanDescription beanDesc, JsonDeserializer<?> deserializer) {
                if (beanDesc.getBeanClass() == FileDataset.class) {
                    return new ItemDeserializer<FileDataset>(deserializer,
                            FileDataset.class, FileDatasetCustomMetadata.class);
                }
                return deserializer;
            }
        });
        */
        return new Jackson2ObjectMapperBuilder()
                //.modules(module)
                .modulesToInstall(Hibernate4Module.class);
    }
}
