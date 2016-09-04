package metastore.controllers;

import static org.apache.commons.lang3.StringEscapeUtils.*;

import au.com.bytecode.opencsv.CSVParser;
import au.com.bytecode.opencsv.CSVReader;
import metastore.models.DatasetInfo;
import metastore.models.TableColumn;
import metastore.models.TableDataSource;
import metastore.models.TableDataset;
import metastore.repositories.TableColumnRepository;
import metastore.repositories.TableDatasetRepository;
import metastore.services.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API to import table sources.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Controller
public class DatabaseController {

    @Autowired
    DatabaseService databaseService;

    @Autowired
    TableDatasetRepository tableDatasetRepository;

    @Autowired
    TableColumnRepository tableColumnRepository;

    @RequestMapping(value = "/api/table-data-sources/{dataSourceId}/reimport", method = RequestMethod.PUT)
    public @ResponseBody String confirmImport(@PathVariable("dataSourceId") Long dataSourceId) {
        databaseService.getMetadata(dataSourceId);
        return "Successfully reimported Table Dataset";
    }

    public void setDatabaseService(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public @ResponseBody String testConnection(@RequestBody TableDataSource tableDataSource) {
        return null;
    }

    @RequestMapping(value = "/api/table-datasets/{datasetId}/sample", method = RequestMethod.GET)
    public @ResponseBody
    List<Map<String, Object>> fetchSampleData(@PathVariable("datasetId") Long datasetId,
                                              @RequestParam(value = "n", defaultValue = "10") int size) throws Exception
    {
        return databaseService.getSampleData(datasetId, size);
    }

    @RequestMapping(value = "/api/table-datasets/{datasetId}/csv", method = RequestMethod.GET)
    public void getTableDatasetAsCSV(@PathVariable("datasetId") Long datasetId,
                                     HttpServletResponse response) throws IOException
    {
        TableDataset dataset = tableDatasetRepository.findOne(datasetId);
        response.addHeader("Cache-Control", "must-revalidate");
        response.addHeader("Pragma", "must-revalidate");
        //response.setContentType("text/csv");
        response.setContentType("application/vnd.ms-excel");
        response.addHeader("Content-Disposition", "attachment;filename=" + dataset.getName() + ".csv");
        StringBuilder sb = new StringBuilder();
        char delim = ',';
        char term = '\n';
        char quote = '"';
        sb
                .append("column_index")
                .append(delim)
                .append("column_name")
                .append(delim)
                .append("description")
                .append(term);
        for (TableColumn column : dataset.getColumns()) {
            sb
                    .append(column.getColumnIndex())
                    .append(delim)
                    .append(quote)
                    .append(escapeCsv(column.getName()))
                    .append(quote)
                    .append(delim);
            String desc = column.getDescription();
            if (desc != null) {
                sb
                        .append(quote)
                        .append(escapeCsv(column.getDescription()))
                        .append(quote);
            }
            sb.append(term);
        }
        response.getWriter().print(sb.toString());
    }

    @RequestMapping(value = "/api/upload/template", method = RequestMethod.POST)
    public @ResponseBody String uploadTemplate(@RequestParam("file") MultipartFile file) throws IOException {
        if (!file.isEmpty()) {
            String filename = file.getOriginalFilename();
            String name = filename.substring(0, filename.lastIndexOf('.'));
            List<TableDataset> datasets = tableDatasetRepository.findByNameIgnoreCase(name);
            TableDataset dataset = datasets.get(0);
            CSVParser parser = new CSVParser();
            // skip header line (2nd argument)
            CSVReader reader = new CSVReader(new StringReader(new String(file.getBytes())), 1, parser);
            Map<String, TableColumn> columnMap = makeColumnMap(dataset.getColumns());
            for (String[] row : reader.readAll()) {
                TableColumn column = columnMap.get(row[1]);
                column.setDescription(row[2]);
                tableColumnRepository.save(column);
            }
        }
        return "Successfully updated column descriptions";
    }

    private Map<String, TableColumn> makeColumnMap(List<TableColumn> columns) {
        Map<String, TableColumn> columnMap = new HashMap<String, TableColumn>();
        for (TableColumn column : columns) {
            columnMap.put(column.getName(), column);
        }
        return columnMap;
    }
}
