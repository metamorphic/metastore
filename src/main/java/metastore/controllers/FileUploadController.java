package metastore.controllers;

import au.com.bytecode.opencsv.CSVParser;
import au.com.bytecode.opencsv.CSVReader;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Joiner;
import io.metamorphic.fileservices.*;
import metastore.models.*;
import metastore.repositories.*;
import org.apache.commons.io.input.BOMInputStream;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static io.metamorphic.commons.utils.ArrayUtils.*;
import static io.metamorphic.commons.utils.StringUtils.*;

/**
 * Uploads a file to extract metadata.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Controller
public class FileUploadController implements InitializingBean {

    private static final Log log = LogFactory.getLog(FileUploadController.class);

    private static final int MAX_SAMPLE_SIZE = 20;

    @Autowired
    FileService fs;

    @Autowired
    FileDataSourceRepository fileDataSourceRepository;

    @Autowired
    FileDatasetRepository fileDatasetRepository;

    @Autowired
    FileColumnRepository fileColumnRepository;

    @Autowired
    DataTypeRepository dataTypeRepository;

    @Autowired
    ValueTypeRepository valueTypeRepository;

    @Autowired
    EventTypeRepository eventTypeRepository;

    @Autowired
    EventPropertyTypeRepository eventPropertyTypeRepository;

    @Autowired
    RecordRepository recordRepository;

    @Autowired
    SettingRepository settingRepository;


    // set list of date formats to test when no particular date format is specified
    @Override
    public void afterPropertiesSet() throws Exception {
        Setting dfs = settingRepository.findOne("date-formats");
        if (dfs != null) {
            String[] dateFormats = dfs.getValue().split("\\n");
            fs.setDateFormats(dateFormats);
        }
    }

    @RequestMapping(value = "/api/upload", method = RequestMethod.GET)
    public @ResponseBody String provideUploadInfo() {
        return "You can upload a file by posting to this same URL.";
    }

    @RequestMapping(value = "/api/headers", method = RequestMethod.POST)
    public @ResponseBody String importColumnHeaders(@RequestBody ColumnHeaders headers) {
        FileDataset fileDataset;
        if (headers.getDatasetId() != null) {
            fileDataset = fileDatasetRepository.findOne(headers.getDatasetId());
        } else if (headers.getDatasetName() != null) {
            fileDataset = fileDatasetRepository.findByName(headers.getDatasetName()).get(0);
        } else {
            // TODO
            // return 404 status
            return "Dataset not found";
        }
        String[] newNames = headers.getNameList();
        List<FileColumn> columns = fileDataset.getColumns();
        for (int i = 0; i < columns.size(); i++) {
            String newName = newNames[i];
            FileColumn column = columns.get(i);
            if (column.getEventPropertyTypes() != null) {
                for (EventPropertyType t : column.getEventPropertyTypes()) {
                    if (prefix(column.getName(), fileDataset.getId(), 6).equals(t.getName()) || fs.isDefaultName(t.getName())) {
                        t.setName(prefix(newName, fileDataset.getId(), 6));
                        t.setMappingExpression(String.format("#this['%s']", newName));
                        eventPropertyTypeRepository.save(t);
                    }
                }
            }
            column.setName(newName);
            fileColumnRepository.save(column);
        }
        return "Successfully updated column and event property type names";
    }

    @RequestMapping(value = "/api/upload2", method = RequestMethod.POST)
    public @ResponseBody DatasetInfo handleFileUpload2(@RequestParam("file") MultipartFile file) {
        if (log.isDebugEnabled()) {
            log.debug("handleFileUpload called");
        }
        String name = "Unknown";
        if (!file.isEmpty()) {
            try {
                if (log.isDebugEnabled()) {
                    log.debug("Processing upload");
                }
                name = file.getOriginalFilename();
                String data = readFileAsString(file);

                Pattern startJsonFilePattern = Pattern.compile("^\\s*[\\[\\{]", Pattern.MULTILINE);
                Matcher matcher = startJsonFilePattern.matcher(data);

                if (matcher.find()) {
                    if (log.isDebugEnabled()) {
                        log.debug("Reading JSON");
                    }
                    return readJsonSample(name, data);
                }
                if (log.isDebugEnabled()) {
                    log.debug("Reading Delimited");
                }

                LinesContainer lc = fs.readLines(data);
                String[] lines = lc.lines;
                String lineEnding = lc.lineEnding;

                FileParameters fileParameters = fs.sniff(data, lineEnding);

                if (fileParameters == null) {
                    return new DatasetInfo("Could not determine file parameters");
                }

                int sampleSize = Math.min(MAX_SAMPLE_SIZE, lines.length);

                char quotechar = getQuoteChar(fileParameters.getTextQualifier());

                if (log.isDebugEnabled()) {
                    log.debug("line ending [" + StringEscapeUtils.escapeJava(lineEnding) + "]");
                }
                if (!memberOf(new String[]{"\n", "\r\n", "\r"}, lineEnding)) {
                    data = data.replace("\n", "\\n").replace("\r", "\\r").replace(lineEnding, "\n");
                }

                CSVParser parser = new CSVParser(fileParameters.getColumnDelimiter(), quotechar);
                CSVReader reader = null;
                RowsContainer rc;
                try {
                    reader = new CSVReader(new StringReader(data), 0, parser);
                    rc = readRows(reader, sampleSize);
                } finally {
                    if (reader != null) {
                        reader.close();
                    }
                }
                String[][] rows = rc.rows;
                int maxNumberColumns = rc.maxNumberColumns;

                boolean hasHeader = fs.hasHeader(rows);
                fileParameters.setHeader(hasHeader);

                TypesContainer tc = fs.getTypes(rows, sampleSize, maxNumberColumns, hasHeader);
                TypeInfo[] types = tc.types;
                DataTypes[] sqlTypes = tc.sqlTypes;

                String[] header = fs.getHeader(rows, types, hasHeader);

                createMetadata(name, fileParameters, hasHeader, header, types, sqlTypes, maxNumberColumns);

                DatasetInfo datasetInfo = new DatasetInfo();
                datasetInfo.setFileType(FileType.DELIMITED.toString());
                List<ColumnInfo> columns = new ArrayList<ColumnInfo>();
                for (int i = 0; i < header.length; i++) {
                    columns.add(new ColumnInfo(header[i], i + 1, types[i].toString()));
                }
                datasetInfo.setColumns(columns);
                datasetInfo.setFileParameters(fileParameters);

                return datasetInfo;

            } catch (Exception e) {
                log.error(e.getMessage(), e);
                e.printStackTrace();
                return new DatasetInfo("You failed to upload " + name + " => " + e.getMessage());
            }
        } else {
            return new DatasetInfo("You failed to upload " + name + " because the file was empty.");
        }
    }

    @RequestMapping(value = "/api/upload", method = RequestMethod.POST)
    public @ResponseBody DatasetInfo handleFileUpload(@RequestParam("file") MultipartFile file) {
        if (log.isDebugEnabled()) {
            log.debug("handleFileUpload called");
        }
        String name = "Unknown";
        if (!file.isEmpty()) {
            try {
                if (log.isDebugEnabled()) {
                    log.debug("Processing upload");
                }
                name = file.getOriginalFilename();
                String data = readFileAsString(file);

                Pattern startJsonFilePattern = Pattern.compile("^\\s*[\\[\\{]", Pattern.MULTILINE);
                Matcher matcher = startJsonFilePattern.matcher(data);

                if (matcher.find()) {
                    if (log.isDebugEnabled()) {
                        log.debug("Reading JSON");
                    }
                    return readJsonSample(name, data);
                }
                if (log.isDebugEnabled()) {
                    log.debug("Reading Delimited");
                }

                // strip blank lines at the start of the file
                data = data.replaceAll("^\\s+", "");

                LinesContainer lc = fs.readLines(data);
                String[] lines = lc.lines;
                String lineEnding = lc.lineEnding;

                if (log.isDebugEnabled()) {
                    log.debug("\nline ending [" + StringEscapeUtils.escapeJava(lineEnding) + "]");
                }

                FileParameters fileParameters = fs.sniff(data, lineEnding);

                if (fileParameters == null) {
                    return new DatasetInfo("Could not determine file parameters");
                }

                int sampleSize = Math.min(MAX_SAMPLE_SIZE, lines.length);

                if (log.isDebugEnabled()) {
                    log.debug("sample size: " + sampleSize);
                }

                char quotechar = getQuoteChar(fileParameters.getTextQualifier());

                if (!memberOf(new String[]{"\n", "\r\n", "\r"}, lineEnding)) {
                    data = data.replace("\n", "\\n").replace("\r", "\\r").replace(lineEnding, "\n");
                }

                CSVParser parser = new CSVParser(fileParameters.getColumnDelimiter(), quotechar);
                CSVReader reader = new CSVReader(new StringReader(data), 0, parser);

                RowsContainer rc = readRows(reader, sampleSize);
                String[][] rows = rc.rows;
                int maxNumberColumns = rc.maxNumberColumns;

                boolean hasHeader = fs.hasHeader(rows);
                fileParameters.setHeader(hasHeader);

                if (log.isDebugEnabled()) {
                    log.debug("header? " + (hasHeader ? "YES" : "NO"));
                }

                TypesContainer tc = fs.getTypes(rows, sampleSize, maxNumberColumns, hasHeader);
                TypeInfo[] types = tc.types;

                String[] header = fs.getHeader(rows, types, hasHeader);

                DatasetInfo datasetInfo = new DatasetInfo();
                datasetInfo.setFileType(FileType.DELIMITED.toString());
                List<ColumnInfo> columns = new ArrayList<ColumnInfo>();
                for (int i = 0; i < header.length; i++) {
                    columns.add(new ColumnInfo(header[i], i + 1, types[i].toString()));
                }
                datasetInfo.setColumns(columns);
                datasetInfo.setFileParameters(fileParameters);

                return datasetInfo;

            } catch (Exception e) {
                e.printStackTrace();
                return new DatasetInfo("You failed to upload " + name + " => " + e.getMessage());
            }
        } else {
            return new DatasetInfo("You failed to upload " + name + " because the file was empty.");
        }
    }

    @RequestMapping(value = "/api/file-datasets/{filename}/confirm-import", method = RequestMethod.POST)
    public @ResponseBody String confirmImport(@PathVariable("filename") String filename,
                                              @RequestBody FileParameters fileParameters)
    {
        System.out.println("Importing " + filename + "...");
        try {
            fileParameters.setTextQualifier(StringEscapeUtils.unescapeJava(fileParameters.getTextQualifier()));
            fileParameters.setColumnDelimiter(StringEscapeUtils.unescapeJava(fileParameters.getColumnDelimiter()));
            fileParameters.setLineTerminator(StringEscapeUtils.unescapeJava(fileParameters.getLineTerminator()));
            String data = readFile("processed_files/" + filename, Charset.defaultCharset());

            // strip blank lines at the start of the file
            data = data.replaceAll("^\\s+", "");

            // TODO
            // add back JSON support
//            Pattern startJsonFilePattern = Pattern.compile("^\\s*[\\[\\{]", Pattern.MULTILINE);
//            Matcher matcher = startJsonFilePattern.matcher(data);
//
//            if (matcher.find()) {
//                return reimportJsonSample(fileDataset, data);
//            }

            String rowDelimiter = fileParameters.getLineTerminator();
            char quotechar = getQuoteChar(fileParameters.getTextQualifier());

            ObjectMapper mapper = new ObjectMapper();
            System.out.println(mapper.writeValueAsString(fileParameters));

            if (!memberOf(new String[]{"\n", "\r\n", "\r"}, rowDelimiter)) {
                System.out.println("non-standard row delimiter");
                data = data.replace("\n", "\\n").replace("\r", "\\r").replace(rowDelimiter, "\n");
            }

            CSVParser parser = new CSVParser(fileParameters.getColumnDelimiter(), quotechar);
            CSVReader reader = new CSVReader(new StringReader(data), 0, parser);

            RowsContainer rc = readRows(reader, MAX_SAMPLE_SIZE);
            String[][] rows = rc.rows;
            int maxNumberColumns = rc.maxNumberColumns;

            System.out.println("rows.length " + rows.length);
            System.out.println("max.columns " + maxNumberColumns);
            System.out.println(mapper.writeValueAsString(rows[0]));

            boolean hasHeader = fs.hasHeader(rows);
            int n = rows.length;

            TypesContainer tc = fs.getTypes(rows, n, maxNumberColumns, hasHeader);
            TypeInfo[] types = tc.types;
            DataTypes[] sqlTypes = tc.sqlTypes;

            String[] header = fs.getHeader(rows, types, hasHeader);

            createMetadata(filename, fileParameters, hasHeader, header, types, sqlTypes, maxNumberColumns);

            return "You successfully uploaded " + filename + "!";

        } catch (Exception e) {
            e.printStackTrace();
            return "You failed to upload " + filename + " => " + e.getMessage();
        }
    }

    public @ResponseBody DatasetInfo readJsonSample(String datasetName, String data) {
        try {
            JsonFactory factory = new JsonFactory();
            JsonParser parser = factory.createParser(data);
            Stack<JsonToken> stack = new Stack<JsonToken>();
            List<Map<String, MyJsonValue>> objects = new ArrayList<Map<String, MyJsonValue>>();
            Map<String, MyJsonValue> currentObject = new HashMap<String, MyJsonValue>();
            JsonToken token;
            while ((token = parser.nextToken()) != null && objects.isEmpty()) {
                switch (token) {
                    case START_OBJECT:
                        stack.push(token);
                        if (stack.size() == 1) {
                            currentObject = new HashMap<String, MyJsonValue>();
                        }
                        break;

                    case END_OBJECT:
                        stack.pop();
                        if (stack.empty()) {
                            objects.add(currentObject);
                        }
                        break;

                    case FIELD_NAME:
                        if (stack.size() == 1) {
                            String key = parser.getCurrentName();
                            JsonToken t = parser.nextToken();

                            switch (t) {
                                case START_OBJECT:
                                    stack.push(token);
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.OBJECT));
                                    break;

                                case START_ARRAY:
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.ARRAY));
                                    break;

                                case VALUE_NUMBER_FLOAT:
                                    currentObject.put(key, new MyJsonValue(parser.getFloatValue(), ValueTypes.NUMERIC));
                                    break;

                                case VALUE_NUMBER_INT:
                                    currentObject.put(key, new MyJsonValue(parser.getIntValue(), ValueTypes.INTEGER));
                                    break;

                                case VALUE_NULL:
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.NONE));
                                    break;

                                case VALUE_FALSE:
                                    currentObject.put(key, new MyJsonValue(false, ValueTypes.BOOLEAN));
                                    break;

                                case VALUE_TRUE:
                                    currentObject.put(key, new MyJsonValue(true, ValueTypes.BOOLEAN));
                                    break;

                                case VALUE_STRING:
                                    String value = parser.getValueAsString();
                                    if (hasValue(value)) {
                                        ParsedDate dt = fs.parseDate(value);
                                        if (dt != null) {
                                            currentObject.put(key, new MyJsonValue(dt, ValueTypes.DATE));
                                            break;
                                        }
                                    }
                                    currentObject.put(key, new MyJsonValue(value, ValueTypes.STRING));
                                    break;

                            }
                        }
                }
            }

            FileDataSource fileDataSource = new FileDataSource();
            fileDataSource.setName(datasetName);
            fileDataSource.setFilepath(datasetName);
            fileDataSource.setFilenamePattern(datasetName);
            fileDataSourceRepository.save(fileDataSource);

            FileDataset fileDataset = new FileDataset();
            fileDataset.setName(datasetName);
            fileDataset.setDataSource(fileDataSource);
            fileDataset.setFileType(FileType.JSON);
            fileDataset.setBatch(true);

            Map<String, ValueType> valueTypeMap = getValueTypeMap();
            Map<String, DataType> dataTypeMap = getDataTypeMap();

            EventType eventType = eventTypeRepository.findByNameIgnoreCase(datasetName);
            if (eventType == null) {
                eventType = new EventType();
                eventType.setName(datasetName);
                eventType.setDescription("Automatically created from import of " + datasetName);
                eventType.setValueType(valueTypeMap.get("STRING"));
                eventType.setValueExpression("'" + datasetName + "'");

                // set the first date column as the event ts
                for (Map.Entry<String, MyJsonValue> entry : currentObject.entrySet()) {
                    if (ValueTypes.DATE == entry.getValue().getType()) {
                        eventType.setTsExpression("$." + entry.getKey());
                        ParsedDate dt = (ParsedDate)entry.getValue().getValue();
                        eventType.setDatetimeFormat(dt.getFormat());
                        eventType.setTimezone("Australia/Melbourne");
                        break;
                    }
                }
                eventTypeRepository.save(eventType);
            }
            fileDataset.addEventType(eventType);
            fileDatasetRepository.save(fileDataset);

            int i = 1;
            for (Map.Entry<String, MyJsonValue> entry : currentObject.entrySet()) {
                String columnName = entry.getKey();
                ValueTypes type = entry.getValue().getType();
                DataTypes sqlType = fs.getSqlType(type);
                ValueType valueType = valueTypeMap.get(type.toString());

                FileColumn fileColumn = new FileColumn();
                fileColumn.setName(columnName);
                fileColumn.setDescription("Automatically created from import of " + datasetName);
                fileColumn.setDataset(fileDataset);
                fileColumn.setColumnIndex(i++);
                fileColumn.setValueType(valueType);
                fileColumn.setDataType(dataTypeMap.get(sqlType.toString()));

                String propertyTypeName = prefix(columnName, fileDataset.getId(), 6);
                EventPropertyType propertyType = new EventPropertyType();
                propertyType.setName(propertyTypeName);
                propertyType.setDescription("Automatically created from import of " + datasetName);
//                propertyType.setValueType(valueType);
                propertyType.setMappingExpression("$." + columnName);
                fileColumn.addEventPropertyType(propertyType);

                fileColumnRepository.save(fileColumn);
            }

            DatasetInfo datasetInfo = new DatasetInfo();
            List<ColumnInfo> columns = new ArrayList<ColumnInfo>();
            i = 1;
            for (Map.Entry<String, MyJsonValue> entry : currentObject.entrySet()) {
                columns.add(new ColumnInfo(entry.getKey(), i++, entry.getValue().getType().toString()));
            }
            datasetInfo.setColumns(columns);
            datasetInfo.setFileType(FileType.JSON.toString());

            return datasetInfo;

        } catch (IOException e) {
            e.printStackTrace();
            return new DatasetInfo("You failed to upload " + datasetName + " => " + e.getMessage());
        }
    }

    public @ResponseBody String reimportJsonSample(FileDataset fileDataset, String data) {
        String datasetName = fileDataset.getName();
        try {
            JsonFactory factory = new JsonFactory();
            JsonParser parser = factory.createParser(data);
            Stack<JsonToken> stack = new Stack<JsonToken>();
            List<Map<String, MyJsonValue>> objects = new ArrayList<Map<String, MyJsonValue>>();
            Map<String, MyJsonValue> currentObject = new HashMap<String, MyJsonValue>();
            JsonToken token;
            while ((token = parser.nextToken()) != null && objects.isEmpty()) {
                switch (token) {

                    case START_OBJECT:
                        stack.push(token);
                        if (stack.size() == 1) {
                            currentObject = new HashMap<String, MyJsonValue>();
                        }
                        break;

                    case END_OBJECT:
                        stack.pop();
                        if (stack.empty()) {
                            objects.add(currentObject);
                        }
                        break;

                    case FIELD_NAME:
                        if (stack.size() == 1) {
                            String key = parser.getCurrentName();
                            JsonToken t = parser.nextToken();

                            switch (t) {

                                case START_OBJECT:
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.OBJECT));
                                    break;

                                case START_ARRAY:
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.ARRAY));
                                    break;

                                case VALUE_NUMBER_FLOAT:
                                    currentObject.put(key, new MyJsonValue(parser.getFloatValue(), ValueTypes.NUMERIC));
                                    break;

                                case VALUE_NUMBER_INT:
                                    currentObject.put(key, new MyJsonValue(parser.getIntValue(), ValueTypes.INTEGER));
                                    break;

                                case VALUE_NULL:
                                    currentObject.put(key, new MyJsonValue(null, ValueTypes.NONE));
                                    break;

                                case VALUE_FALSE:
                                    currentObject.put(key, new MyJsonValue(false, ValueTypes.BOOLEAN));
                                    break;

                                case VALUE_TRUE:
                                    currentObject.put(key, new MyJsonValue(true, ValueTypes.BOOLEAN));
                                    break;

                                case VALUE_STRING:
                                    String value = parser.getValueAsString();
                                    if (hasValue(value)) {
                                        ParsedDate dt = fs.parseDate(value);
                                        if (dt != null) {
                                            currentObject.put(key, new MyJsonValue(dt, ValueTypes.DATE));
                                            break;
                                        }
                                    }
                                    currentObject.put(key, new MyJsonValue(value, ValueTypes.STRING));
                                    break;

                            }
                        }
                }
            }

            Map<String, ValueType> valueTypeMap = getValueTypeMap();
            Map<String, DataType> dataTypeMap = getDataTypeMap();

            List<EventPropertyType> propertyTypesToRemove = new ArrayList<EventPropertyType>();
            for (FileColumn column : fileDataset.getColumns()) {
                List<EventPropertyType> propertyTypes = eventPropertyTypeRepository.findByNameIgnoreCase(prefix(column.getName(), fileDataset.getId(), 6));
                if (propertyTypes != null && !propertyTypes.isEmpty()) {
                    EventPropertyType propertyType = propertyTypes.get(0);
                    List<FileColumn> columns = fileColumnRepository.findByEventPropertyTypeId(propertyType.getId());
                    if (columns.size() == 1) {
                        propertyTypesToRemove.add(propertyType);
                    }
                }
            }

            fileDataset.getColumns().clear();
            fileDatasetRepository.save(fileDataset);

            for (EventPropertyType propertyType : propertyTypesToRemove) {
                eventPropertyTypeRepository.delete(propertyType);
            }

            int i = 1;
            for (Map.Entry<String, MyJsonValue> entry : currentObject.entrySet()) {
                String columnName = entry.getKey();
                ValueTypes type = entry.getValue().getType();
                DataTypes sqlType = fs.getSqlType(type);
                ValueType valueType = valueTypeMap.get(type.toString());

                FileColumn fileColumn = new FileColumn();
                fileColumn.setName(columnName);
                fileColumn.setDescription("Automatically created from import of " + datasetName);
                fileColumn.setDataset(fileDataset);
                fileColumn.setColumnIndex(i++);
                fileColumn.setValueType(valueType);
                fileColumn.setDataType(dataTypeMap.get(sqlType.toString()));

                String propertyTypeName = prefix(columnName, fileDataset.getId(), 6);
                EventPropertyType propertyType = new EventPropertyType();
                propertyType.setName(propertyTypeName);
                propertyType.setDescription("Automatically created from import of " + datasetName);
//                propertyType.setValueType(valueType);
                propertyType.setMappingExpression("$." + columnName);
                fileColumn.addEventPropertyType(propertyType);

                fileColumnRepository.save(fileColumn);
            }

        } catch (IOException e) {
            e.printStackTrace();
            return "Failed to reimport " + datasetName + " => " + e.getMessage();
        }

        return "Successful reimport of " + datasetName + "!";
    }

    private static class MyJsonValue {

        private Object value;
        private ValueTypes type;

        MyJsonValue(Object value, ValueTypes type) {
            this.value = value;
            this.type = type;
        }

        public Object getValue() {
            return value;
        }

        public ValueTypes getType() {
            return type;
        }
    }

    @RequestMapping(value="/api/upload/multi-recordset", method = RequestMethod.POST)
    public @ResponseBody String importMultiRecordSet(@RequestParam("file") MultipartFile file) throws Exception {
        String name = "Unknown";
        if (!file.isEmpty()) {
            name = file.getOriginalFilename();
            String data = readFileAsString(file);

            // strip blank lines at the start of the file
            data = data.replaceAll("^\\s+", "");

            LinesContainer lc = fs.readLines(data);
            String[] lines = lc.lines;

            int sampleSize = Math.min(200, lines.length);

            Pattern p = Pattern.compile("^(\\w+).*");
            Map<String, List<String>> records = new HashMap<String, List<String>>();
            for (int i = 0; i < sampleSize; i++) {
                String line = lines[i];
                Matcher matcher = p.matcher(line);
                String recordType;
                if (matcher.find()) {
                    recordType = matcher.group(1);
                } else {
                    recordType = "UNKNOWN";
                }
                if (!records.containsKey(recordType)) {
                    records.put(recordType, new ArrayList<String>());
                }

                records.get(recordType).add(line);
            }

            Map<String, ValueType> valueTypeMap = getValueTypeMap();
            Map<String, DataType> dataTypeMap = getDataTypeMap();

            FileDataset fileDataset = null;

            for (Map.Entry<String, List<String>> entry : records.entrySet()) {
                List<String> sample = entry.getValue();
                String d = Joiner.on("\\n").join(sample);
                FileParameters fileParameters = fs.sniff(d, lc.lineEnding);

                if (fileParameters == null) {
                    return "Could not determine file parameters";
                }

                char quotechar = getQuoteChar(fileParameters.getTextQualifier());
                CSVParser parser = new CSVParser(fileParameters.getColumnDelimiter(), quotechar);
                CSVReader reader = new CSVReader(new StringReader(d), 0, parser);

                // TODO
                // skip the first column
                RowsContainer rc = readRows(reader, sample.size());
                String[][] rows = rc.rows;
                int maxNumberColumns = rc.maxNumberColumns;
                TypesContainer tc = fs.getTypes(rows, sample.size(), maxNumberColumns, false);
                TypeInfo[] types = tc.types;
                DataTypes[] sqlTypes = tc.sqlTypes;

                String[] header = fs.getHeader(rows, types, false);

                if (fileDataset == null) {
                    FileDataSource fileDataSource = new FileDataSource();
                    fileDataSource.setName(name);
                    fileDataSource.setFilepath(name);
                    fileDataSource.setFilenamePattern(name);
                    fileDataSourceRepository.save(fileDataSource);

                    fileDataset = new FileDataset();
                    fileDataset.setName(name);
                    fileDataset.setDataSource(fileDataSource);
                    fileDataset.setFileType(FileType.MULTIRECORD);
                    fileDataset.setBatch(true);
                    fileDataset.setColumnDelimiter(fileParameters.getColumnDelimiter());
                    fileDataset.setHeaderRow(false);
                    fileDataset.setRowDelimiter("\\n");
                    fileDataset.setTextQualifier(fileParameters.getTextQualifier());
                    fileDataset.setMultiRecordset(true);
                    fileDatasetRepository.save(fileDataset);
                }

                Record record = new Record();
                record.setName(entry.getKey());
                record.setPrefix(entry.getKey());
                record.setDescription("Automatically created from import of " + name);
                record.setDataset(fileDataset);

                EventType eventType = eventTypeRepository.findByNameIgnoreCase(name);
                if (eventType == null) {
                    eventType = new EventType();
                    eventType.setName(entry.getKey());
                    eventType.setDescription("Automatically created from import of " + name);
                    eventType.setValueType(valueTypeMap.get("STRING"));
                    eventType.setValueExpression("'" + entry.getKey() + "'");

                    // set the first date column as the event ts
                    for (int i = 0; i < types.length; i++) {
                        if (types[i].getType().equals(ValueTypes.DATE)) {
                            eventType.setTsExpression("#this['" + header[i] + "']");
                            break;
                        }
                    }
                    eventTypeRepository.save(eventType);
                }
                record.addEventType(eventType);
                recordRepository.save(record);

                String[] propertyTypeNames = prefix(header, fileDataset.getId(), 6);
                for (int i = 0; i < maxNumberColumns; i++) {
                    String columnName = header[i];
                    ValueType valueType = valueTypeMap.get(types[i].toString());

                    FileColumn fileColumn = new FileColumn();
                    fileColumn.setName(columnName);
                    fileColumn.setDescription("Automatically created from import of " + name);
                    fileColumn.setRecord(record);
                    fileColumn.setColumnIndex(i + 1);
                    fileColumn.setValueType(valueType);
                    fileColumn.setDataType(dataTypeMap.get(sqlTypes[i].toString()));

                    String propertyTypeName = propertyTypeNames[i];

//                    if (isDefaultName(columnName)) {
//                        String datasetName = fileDataset.getName();
//                        String shortDatasetName = datasetName.substring(0, Math.min(9, datasetName.length()));
//                        propertyTypeName = shortDatasetName.toLowerCase() + "_" + columnName;
//                    } else {
//                        propertyTypeName = columnName;
//                    }

                    EventPropertyType propertyType = null;

//                    List<EventPropertyType> propertyTypes = eventPropertyTypeRepository.findByNameIgnoreCase(columnName);
//                    if (propertyTypes != null && !propertyTypes.isEmpty()) {
//                        propertyType = propertyTypes.get(0);
//                    }
//                    if (propertyType == null || !valueType.equals(propertyType.getValueType())) {

                    propertyType = new EventPropertyType();
                    propertyType.setName(propertyTypeName);
                    propertyType.setDescription("Automatically created from import of " + name);
//                    propertyType.setValueType(valueType);
                    propertyType.setMappingExpression("#this['" + columnName + "']");
//                    }
                    fileColumn.addEventPropertyType(propertyType);

                    fileColumnRepository.save(fileColumn);
                }
            }

            return "You successfully uploaded " + name + "!";
        }
        return "You failed to upload " + name + " because the file was empty.";
    }

    @RequestMapping(value = "/api/file-datasets/{datasetId}/reimport", method = RequestMethod.PUT)
    public @ResponseBody String reimportFile(@PathVariable("datasetId") Long datasetId) throws Exception {
        FileDataset fileDataset = fileDatasetRepository.findOne(datasetId);
        char quotechar;
        String textQualifier = fileDataset.getTextQualifier();
        if (textQualifier == null) {
            quotechar = CSVParser.DEFAULT_QUOTE_CHARACTER;
        } else {
            quotechar = textQualifier.charAt(0);
        }
        String data = readFile("processed_files/" + fileDataset.getDataSource().getFilepath(), Charset.defaultCharset());

        // strip blank lines at the start of the file
        data = data.replaceAll("^\\s+", "");

        String rowDelimiter = fileDataset.getRowDelimiter();

        Pattern startJsonFilePattern = Pattern.compile("^\\s*[\\[\\{]", Pattern.MULTILINE);
        Matcher matcher = startJsonFilePattern.matcher(data);

        if (matcher.find()) {
            return reimportJsonSample(fileDataset, data);
        }

        if (log.isDebugEnabled()) {
            log.debug("row delimiter [" + rowDelimiter + "]");
            log.debug("col delimiter [" + fileDataset.getColumnDelimiter() + "]");
        }

        if (!memberOf(new String[]{"\n", "\r\n", "\r"}, rowDelimiter)) {
            data = data.replace("\n", "\\n").replace("\r", "\\r").replace(rowDelimiter, "\n");
        }
        int linesToSkip = 0;
        CSVParser parser = new CSVParser(fileDataset.getColumnDelimiter(), quotechar);
        CSVReader reader = new CSVReader(new StringReader(data), linesToSkip, parser);

        int maxNumberColumns = 0;
        List<String[]> lines = new ArrayList<String[]>();
        String[] nextLine;
        int i = 0;
        while ((nextLine = reader.readNext()) != null && i < MAX_SAMPLE_SIZE) {
            lines.add(nextLine);
            maxNumberColumns = Math.max(maxNumberColumns, nextLine.length);
            i += 1;
        }
        if (log.isDebugEnabled()) {
            log.debug("maxNumberColumns: " + maxNumberColumns);
        }
        String[][] rows = lines.toArray(new String[lines.size()][]);
        int sampleSize = Math.min(MAX_SAMPLE_SIZE, rows.length);
        boolean hasHeader = fileDataset.isHeaderRow();

        TypesContainer tc = fs.getTypes(rows, sampleSize, maxNumberColumns, hasHeader);
        TypeInfo[] types = tc.types;
        DataTypes[] sqlTypes = tc.sqlTypes;
        String[] header = fs.getHeader(rows, types, hasHeader);

        Map<String, ValueType> valueTypeMap = new HashMap<String, ValueType>();
        Iterator<ValueType> valueTypeIterator = valueTypeRepository.findAll().iterator();
        while (valueTypeIterator.hasNext()) {
            ValueType valueType = valueTypeIterator.next();
            valueTypeMap.put(valueType.getName(), valueType);
        }
        Map<String, DataType> dataTypeMap = new HashMap<String, DataType>();
        Iterator<DataType> dataTypeIterator = dataTypeRepository.findAll().iterator();
        while (dataTypeIterator.hasNext()) {
            DataType dataType = dataTypeIterator.next();
            dataTypeMap.put(dataType.getName(), dataType);
        }

        List<EventPropertyType> propertyTypesToRemove = new ArrayList<EventPropertyType>();
        for (FileColumn column : fileDataset.getColumns()) {
            List<EventPropertyType> propertyTypes = eventPropertyTypeRepository.findByNameIgnoreCase(prefix(column.getName(), fileDataset.getId(), 6));
            if (propertyTypes != null && !propertyTypes.isEmpty()) {
                EventPropertyType propertyType = propertyTypes.get(0);
                List<FileColumn> columns = fileColumnRepository.findByEventPropertyTypeId(propertyType.getId());
                if (columns.size() == 1) {
                    propertyTypesToRemove.add(propertyType);
                }
            }
        }

        fileDataset.getColumns().clear();
        fileDatasetRepository.save(fileDataset);

        for (EventPropertyType propertyType : propertyTypesToRemove) {
            eventPropertyTypeRepository.delete(propertyType);
        }

        String[] propertyTypeNames = prefix(header, fileDataset.getId(), 6);
        for (i = 0; i < maxNumberColumns; i++) {
            String columnName = header[i];
            ValueType valueType = valueTypeMap.get(types[i].toString());

            FileColumn fileColumn = new FileColumn();
            fileColumn.setName(columnName);
            fileColumn.setDataset(fileDataset);
            fileColumn.setColumnIndex(i + 1);
            fileColumn.setValueType(valueType);
            fileColumn.setDataType(dataTypeMap.get(sqlTypes[i].toString()));

            String propertyTypeName = propertyTypeNames[i];
            EventPropertyType propertyType = null;

//            List<EventPropertyType> propertyTypes = eventPropertyTypeRepository.findByNameIgnoreCase(columnName);
//            if (propertyTypes != null && !propertyTypes.isEmpty()) {
//                propertyType = propertyTypes.get(0);
//            }
//            if (propertyType == null || !valueType.equals(propertyType.getValueType())) {

            propertyType = new EventPropertyType();
            propertyType.setName(propertyTypeName);
//            propertyType.setValueType(valueType);
            propertyType.setMappingExpression("#this['" + columnName + "']");
//            }
            fileColumn.addEventPropertyType(propertyType);

            fileColumnRepository.save(fileColumn);
        }

        return "Successful reimport of " + fileDataset.getName();
    }

    @RequestMapping(value = "/api/file-datasets/{datasetId}/sample", method = RequestMethod.GET)
    public @ResponseBody List<Map<String, Object>> fetchSampleData(@PathVariable("datasetId") Long datasetId) throws Exception {
        FileDataset fileDataset = fileDatasetRepository.findOne(datasetId);
        char quotechar;
        String textQualifier = fileDataset.getTextQualifier();
        if (textQualifier == null) {
            quotechar = CSVParser.DEFAULT_QUOTE_CHARACTER;
        } else {
            quotechar = textQualifier.charAt(0);
        }
        String data = readFile("processed_files/" + fileDataset.getDataSource().getFilepath(), Charset.defaultCharset());
        String rowDelimiter = fileDataset.getRowDelimiter();
        if (!memberOf(new String[]{"\n", "\r\n", "\r"}, rowDelimiter)) {
            data = data.replace("\n", "\\n").replace("\r", "\\r").replace(rowDelimiter, "\n");
        }

        int linesToSkip = 0;
        CSVParser parser = new CSVParser(fileDataset.getColumnDelimiter(), quotechar);
        CSVReader reader = new CSVReader(new StringReader(data), linesToSkip, parser);

        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        List<FileColumn> columns = fileDataset.getColumns();
        String[] nextLine;
        int i = 0;
        while ((nextLine = reader.readNext()) != null && i < MAX_SAMPLE_SIZE) {
            // skip header row
            if (fileDataset.isHeaderRow() && i == 0) {
                i += 1;
                continue;
            }
            Map<String, Object> row = new LinkedHashMap<String, Object>();
            if (log.isDebugEnabled()) {
                log.debug("columns len: " + columns.size());
                log.debug("line len: " + nextLine.length);
            }
            for (int j = 0; j < nextLine.length; j++) {
                row.put(columns.get(j).getName(), nextLine[j]);
            }
            rows.add(row);
            i += 1;
        }

        return rows;
    }

    @RequestMapping(value = "/api/file-datasets/{datasetId}/samplejson", method = RequestMethod.GET)
    public @ResponseBody String fetchSampleJsonData(@PathVariable("datasetId") Long datasetId) throws Exception {
        FileDataset fileDataset = fileDatasetRepository.findOne(datasetId);
        return readFile("processed_files/" + fileDataset.getDataSource().getFilepath(), Charset.defaultCharset());
    }

    private static String readFileAsString(MultipartFile file) throws Exception {
        String name = file.getOriginalFilename();
        File localFile = new File("processed_files/" + name);
        BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(localFile));
        StringBuilder sb = new StringBuilder();

        BOMInputStream in = new BOMInputStream(file.getInputStream(), false);
        if (in.hasBOM()) {
            System.out.println("File " + name + " has Byte Order Mark");
        }
        int read;
        final byte[] bytes = new byte[1024];
        while ((read = in.read(bytes)) != -1) {
            stream.write(bytes, 0, read);
            sb.append(new String(bytes, 0, read));
        }
        stream.close();
        in.close();
        return sb.toString();
    }

    private static String readFile(String path, Charset encoding) throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);
    }

    private static char getQuoteChar(String textQualifier) {
        return textQualifier == null || textQualifier.trim().isEmpty() ?
                CSVParser.DEFAULT_QUOTE_CHARACTER : textQualifier.charAt(0);
    }

    private Map<String, ValueType> getValueTypeMap() {
        Map<String, ValueType> valueTypeMap = new HashMap<String, ValueType>();
        Iterator<ValueType> valueTypeIterator = valueTypeRepository.findAll().iterator();
        while (valueTypeIterator.hasNext()) {
            ValueType valueType = valueTypeIterator.next();
            valueTypeMap.put(valueType.getName(), valueType);
        }
        return valueTypeMap;
    }

    private Map<String, DataType> getDataTypeMap() {
        Map<String, DataType> dataTypeMap = new HashMap<String, DataType>();
        Iterator<DataType> dataTypeIterator = dataTypeRepository.findAll().iterator();
        while (dataTypeIterator.hasNext()) {
            DataType dataType = dataTypeIterator.next();
            dataTypeMap.put(dataType.getName(), dataType);
        }
        return dataTypeMap;
    }

    private void createMetadata(String datasetName, FileParameters fileParameters,
                                boolean hasHeader, String[] header,
                                TypeInfo[] types,
                                DataTypes[] sqlTypes,
                                int maxNumberColumns)
    {
        FileDataSource fileDataSource = new FileDataSource();
        fileDataSource.setName(datasetName);
        fileDataSource.setFilepath(datasetName);
        fileDataSource.setFilenamePattern(datasetName);
        fileDataSourceRepository.save(fileDataSource);

        FileDataset fileDataset = new FileDataset();
        fileDataset.setName(datasetName);
        fileDataset.setDataSource(fileDataSource);
        fileDataset.setFileType(FileType.DELIMITED);
        fileDataset.setBatch(true);
        fileDataset.setColumnDelimiter(fileParameters.getColumnDelimiter());
        fileDataset.setHeaderRow(hasHeader);
        fileDataset.setRowDelimiter("\\n");
        fileDataset.setTextQualifier(fileParameters.getTextQualifier());

        Map<String, ValueType> valueTypeMap = getValueTypeMap();
        Map<String, DataType> dataTypeMap = getDataTypeMap();

        EventType eventType = eventTypeRepository.findByNameIgnoreCase(datasetName);
        if (eventType == null) {
            eventType = new EventType();
            eventType.setName(datasetName);
            eventType.setDescription("Automatically created from import of " + datasetName);
            eventType.setValueType(valueTypeMap.get("STRING"));
            eventType.setValueExpression("'" + datasetName + "'");

            // set the first date column as the event ts
            for (int i = 0; i < types.length; i++) {
                if (types[i].getType().equals(ValueTypes.DATE)) {
                    eventType.setTsExpression("#this['" + header[i] + "']");
                    eventType.setDatetimeFormat((String)types[i].getValue("format"));
                    eventType.setTimezone("Australia/Melbourne");
                    break;
                }
            }
            eventTypeRepository.save(eventType);
        }
        fileDataset.addEventType(eventType);
        fileDatasetRepository.save(fileDataset);

        String[] propertyTypeNames = prefix(header, fileDataset.getId(), 6);
        for (int i = 0; i < maxNumberColumns; i++) {
            String columnName = header[i];
            ValueType valueType = valueTypeMap.get(types[i].toString());

            FileColumn fileColumn = new FileColumn();
            fileColumn.setName(columnName);
            fileColumn.setDescription("Automatically created from import of " + datasetName);
            fileColumn.setDataset(fileDataset);
            fileColumn.setColumnIndex(i + 1);
            fileColumn.setValueType(valueType);
            fileColumn.setDataType(dataTypeMap.get(sqlTypes[i].toString()));

            String propertyTypeName = propertyTypeNames[i];
            EventPropertyType propertyType = null;

//            List<EventPropertyType> propertyTypes = eventPropertyTypeRepository.findByNameIgnoreCase(columnName);
//            if (propertyTypes != null && !propertyTypes.isEmpty()) {
//                propertyType = propertyTypes.get(0);
//            }
//            if (propertyType == null || !valueType.equals(propertyType.getValueType())) {

            propertyType = new EventPropertyType();
            propertyType.setName(propertyTypeName);
            propertyType.setDescription("Automatically created from import of " + datasetName);
//            propertyType.setValueType(valueType);
            propertyType.setMappingExpression("#this['" + columnName + "']");
//            }
            fileColumn.addEventPropertyType(propertyType);

            fileColumnRepository.save(fileColumn);
        }
    }

    private RowsContainer readRows(CSVReader reader, int maxSampleSize) throws IOException {
        if (log.isDebugEnabled()) {
            log.debug("reading rows");
        }
        List<String[]> rowList = new ArrayList<String[]>();
        int maxNumberColumns = 0;
        int k = 0;
        String[] nextLine;
        while ((nextLine = reader.readNext()) != null) {
            rowList.add(nextLine);
            maxNumberColumns = Math.max(maxNumberColumns, nextLine.length);
            k += 1;
            if (k == maxSampleSize) break;
        }
        int n = Math.min(maxSampleSize, rowList.size());
        if (log.isDebugEnabled()) {
            log.debug("rows " + n);
            log.debug("cols " + maxNumberColumns);
        }
        String[][] rows = new String[n][maxNumberColumns];
        for (int i = 0; i < n; i++) {
            String[] row = rowList.get(i);
            System.arraycopy(row, 0, rows[i], 0, row.length);
        }
        return new RowsContainer(rows, maxNumberColumns);
    }

    private String[] prefix(String[] names, Long id, int len) {
        Assert.notNull(names);
        int n = names.length;
        String[] newNames = new String[n];
        for (int i = 0; i < n; i++) {
            newNames[i] = prefix(names[i], id, len);
        }
        return newNames;
    }

    private String prefix(String name, Long id, int len) {
        Assert.notNull(name);
        return String.format("d%s_%s", zeroPad(id, len), name);
    }

    private static class RowsContainer {
        String[][] rows;
        int maxNumberColumns;

        RowsContainer(String[][] rows, int maxNumberColumns) {
            this.rows = rows;
            this.maxNumberColumns = maxNumberColumns;
        }
    }
}
