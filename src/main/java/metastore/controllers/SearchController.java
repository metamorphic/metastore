package metastore.controllers;

import metastore.elasticsearch.Searchable;
import metastore.elasticsearch.repositories.EntityDocumentRepository;
import metastore.models.EntityDocument;
import metastore.repositories.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.PagedResources;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by markmo on 31/05/15.
 */
@Controller
public class SearchController {

    private static final Log log = LogFactory.getLog(SearchController.class);

    @Autowired
    private EntityDocumentRepository entityDocumentRepository;

    @Autowired
    private FileDataSourceRepository fileDataSourceRepository;

    @Autowired
    private FileDatasetRepository fileDatasetRepository;

    @Autowired
    private FileColumnRepository fileColumnRepository;

    @Autowired
    private TableDataSourceRepository tableDataSourceRepository;

    @Autowired
    private TableDatasetRepository tableDatasetRepository;

    @Autowired
    private TableColumnRepository tableColumnRepository;

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/api/entities/search", method = RequestMethod.GET)
    public HttpEntity<PagedResources<EntityDocument>> find(@RequestParam String q,
                                                           Pageable pageable,
                                                           PagedResourcesAssembler assembler) {
        Page<EntityDocument> hits = entityDocumentRepository.findContent(q, pageable);
        return new ResponseEntity<PagedResources<EntityDocument>>(assembler.toResource(hits), HttpStatus.OK);
    }

    @RequestMapping(value = "/api/entities/reindex", method = RequestMethod.PUT)
    public @ResponseBody String reindex() {
        if (log.isDebugEnabled()) {
            log.debug("Reindexing the search index");
        }
        reindex(fileDataSourceRepository.findAll());
        reindex(fileDatasetRepository.findAll());
        reindex(fileColumnRepository.findAll());
        reindex(tableDataSourceRepository.findAll());
        reindex(tableDatasetRepository.findAll());
        reindex(tableColumnRepository.findAll());
        return "OK";
    }

    private void reindex(Iterable models) {
        for (Object model : models) {
            if (model instanceof Searchable) {
                Searchable searchable = (Searchable)model;
                EntityDocument doc = new EntityDocument();
                String type = searchable.getClass().getSimpleName();
                doc.setType(type);
                doc.setId(type + ":" + searchable.getId());
                doc.setName(searchable.getName());
                doc.setDescription(searchable.getDescription());
                entityDocumentRepository.save(doc);
                if (log.isDebugEnabled()) {
                    System.out.print(".");
                }
            }
        }
    }
}
