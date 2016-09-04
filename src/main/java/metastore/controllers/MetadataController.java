package metastore.controllers;

import metastore.models.*;
import metastore.services.MetadataService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * API to fetch metadata for a file to ingest.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RestController
public class MetadataController {

    private static final Log log = LogFactory.getLog(MetadataController.class);

    @Autowired
    MetadataService metadataService;

    @RequestMapping("/api/file-datasets/search/by-filename")
    public FileDataset findDatasetsByFilename(@RequestParam("filename") String filename) {
        if (log.isDebugEnabled()) {
            log.debug("Lookup dataset by filename \"" + filename + "\"");
        }
        // TODO
        // installing the Hibernate4Module to the Jackson Object Mapper in
        // MetastoreConfiguration appears to have made associations lazy
        // by default (and also returns null instead of an empty list '[]'
        // for array properties). Calling size() is a common idiom to
        // fetch the association.
        FileDataset fileDataset = metadataService.findDatasetsByFilename(filename);
        if (fileDataset != null) {
            if (fileDataset.getColumns() != null) {
                for (FileColumn column : fileDataset.getColumns()) {
                    column.getEventPropertyTypes().size();
                }
            }
            if (fileDataset.getEventTypes() != null) {
                fileDataset.getEventTypes().size();
            }
        }
        return fileDataset;
    }

    @RequestMapping("/api/jobs/merge")
    public String mergeJobs() {
        metadataService.mergeJobs();
        return "Successfully merged jobs";
    }

    @RequestMapping("/api/customer-id-types/merge")
    public String mergeCustomerIdTypes() {
        metadataService.mergeCustomerIdTypes();
        return "Successfully merged customer id types";
    }

    @RequestMapping("/api/event-types/merge")
    public String mergeEventTypes() {
        metadataService.mergeEventTypes();
        return "Successfully merged event types";
    }

    @RequestMapping("/api/stats")
    public Stats getStats() throws Exception {
        return metadataService.getStats();
    }

    @RequestMapping("/api/stats/refresh")
    public Stats refreshStats() {
        return metadataService.refreshStats();
    }

    @RequestMapping(value = "/api/table-data-sources/{dataSourceId}/clone", method = RequestMethod.POST)
    public String cloneTableDataSource(@PathVariable("dataSourceId") Long dataSourceId) {
        String originalDataSourceName = metadataService.cloneTableDataSource(dataSourceId);
        return "Successfully cloned data source " + originalDataSourceName;
    }
}
