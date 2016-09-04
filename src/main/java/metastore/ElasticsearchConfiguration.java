package metastore;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.node.NodeClient;
import org.elasticsearch.node.NodeBuilder;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.elasticsearch.ElasticsearchProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;

/**
 * Created by markmo on 31/05/15.
 */
@Configuration
@EnableConfigurationProperties(ElasticsearchProperties.class)
public class ElasticsearchConfiguration implements DisposableBean {

    private static Log log = LogFactory.getLog(ElasticsearchConfiguration.class);

    @Autowired
    private ElasticsearchProperties properties;

    private NodeClient client;

    @Bean
    public ElasticsearchTemplate elasticsearchTemplate() {
        return new ElasticsearchTemplate(esClient());
    }

    @Bean
    public Client esClient() {
        try {
            if (log.isInfoEnabled()) {
                log.info("Starting Elasticsearch client");
            }
            NodeBuilder nodeBuilder = new NodeBuilder();
            nodeBuilder
                    .clusterName(this.properties.getClusterName())
                    .local(false)
                    .settings().put("http.enabled", true);
            this.client = (NodeClient)nodeBuilder.node().client();
            return this.client;
        } catch (Exception ex) {
            throw new IllegalStateException(ex);
        }
    }

    @Override
    public void destroy() throws Exception {
        if (this.client != null) {
            try {
                if (log.isInfoEnabled()) {
                    log.info("Closing Elasticsearch client");
                }
                if (this.client != null) {
                    this.client.close();
                }
            } catch (final Exception e) {
                if (log.isErrorEnabled()) {
                    log.error("Error closing Elasticsearch client: ", e);
                }
            }
        }
    }
}
