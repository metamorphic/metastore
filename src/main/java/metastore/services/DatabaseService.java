package metastore.services;

import com.foundationdb.sql.StandardException;
import com.foundationdb.sql.parser.SQLParser;
import com.foundationdb.sql.parser.StatementNode;
import io.metamorphic.fileservices.DataTypes;
import metastore.models.*;
import metastore.repositories.DataTypeRepository;
import metastore.repositories.TableColumnRepository;
import metastore.repositories.TableDataSourceRepository;
import metastore.repositories.TableDatasetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.*;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class DatabaseService {

    @Autowired
    TableDataSourceRepository tableDataSourceRepository;

    @Autowired
    TableDatasetRepository tableDatasetRepository;

    @Autowired
    TableColumnRepository tableColumnRepository;

    @Autowired
    DataTypeRepository dataTypeRepository;

    Connection conn = null;

    static Map<String, String> drivers = new HashMap<String, String>() {{
        put("postgresql", "org.postgresql.Driver");
    }};

    public List<SqlStatementMetadata> getMetadata(String sql) throws StandardException {
        SQLParser parser = new SQLParser();
        List<StatementNode> nodes = parser.parseStatements(sql);
        List<SqlStatementMetadata> metadata = new ArrayList<SqlStatementMetadata>();
        for (StatementNode node : nodes) {
            QueryTreeVisitor visitor = new QueryTreeVisitor();
            node.accept(visitor);
            metadata.add(visitor.getMetadata());
        }
        return metadata;
    }

    public void createDataset(SqlStatementMetadata metadata) {
        String baseTableName = metadata.getBaseSqlTableMetadata().getTableName();
        String schemaName = metadata.getBaseSqlTableMetadata().getSchemaName();
        TableDataSource tableDataSource = new TableDataSource();
        tableDataSource.setName(metadata.getBaseSqlTableMetadata().getQualifiedName());
        tableDataSource.setSchemaName(schemaName);
        tableDataSource.setTableName(baseTableName);
        tableDataSourceRepository.save(tableDataSource);

        TableDataset tableDataset = new TableDataset();
        tableDataset.setName(baseTableName);
//        tableDataset.setTableDataSource(tableDataSource);
        tableDataset.setNamespace(schemaName);
        tableDatasetRepository.save(tableDataset);

        Map<String, DataType> dataTypeMap = getDataTypeMap();

        List<SqlColumnMetadata> columnMetadataList = metadata.getSqlColumnMetadataList();
        for (int i = 0; i < columnMetadataList.size(); i++) {
            SqlColumnMetadata columnMetadata = columnMetadataList.get(i);
            TableColumn column = new TableColumn();
            column.setName(columnMetadata.getColumnName());
            column.setColumnIndex(i);
//            column.setDataset(tableDataset);
            String dataTypeName = columnMetadata.getDataType();
            DataType dataType;
            if (dataTypeMap.containsKey(dataTypeName)) {
                dataType = dataTypeMap.get(dataTypeName);
            } else {
                dataType = dataTypeMap.get("NVARCHAR");
            }
            column.setDataType(dataType);
            column.setLength(columnMetadata.getLength());
            tableColumnRepository.save(column);
        }
    }

    public void getMetadata(Long dataSourceId) {
        TableDataSource ds = tableDataSourceRepository.findOne(dataSourceId);
        String connectionUrl = ds.getConnectionUrl();
        if (connectionUrl == null) {
            connectionUrl = "jdbc:postgresql://" + ds.getHostname() + ":" + ds.getPort() + "/" + ds.getDatabaseName();
        }
        String catalog = ds.getCatalogName();
        String schemaPattern = ds.getSchemaName();
        String tableNamePattern = ds.getTableName();
//        List<TableDataset> datasets = tableDatasetRepository.findByTableDataSourceId(ds.getId());
        List<TableDataset> datasets = new ArrayList<>();
        TableDataset dataset;
        if (datasets == null || datasets.isEmpty()) {
            dataset = new TableDataset();
            dataset.setName(ds.getTableName());
//            dataset.setTableDataSource(ds);
            dataset.setNamespace(ds.getSchemaName());
        } else {
            dataset = datasets.get(0);
        }
        if (dataset.getColumns() != null && !dataset.getColumns().isEmpty()) {
            dataset.getColumns().clear();
        }
        tableDatasetRepository.save(dataset);

        Connection con = getConnection(connectionUrl);
        Map<String, DataType> dataTypeMap = getDataTypeMap();
        try {
            ResultSet rs = con.getMetaData().getColumns(catalog, schemaPattern, tableNamePattern, null);
            int i = 1;
            while (rs.next()) {
                TableColumn column = new TableColumn();
                column.setName(rs.getString("COLUMN_NAME"));
                column.setColumnIndex(i);
                column.setDataType(dataTypeMap.get(translateDataType(rs.getString("TYPE_NAME"))));
//                column.setDataset(dataset);
                column.setLength(rs.getInt("COLUMN_SIZE"));
                tableColumnRepository.save(column);
                i += 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (SQLException e) {
                // do nothing
            }
        }
    }

    public List<Map<String, Object>> getSampleData(Long datasetId, int size) {
        TableDataset dataset = tableDatasetRepository.findOne(datasetId);
//        TableDataSource source = dataset.getTableDataSource();
        TableDataSource source = null;
        String connectionUrl = source.getConnectionUrl();
        if (connectionUrl == null) {
            connectionUrl = "jdbc:postgresql://" + source.getHostname() + ":" + source.getPort() + "/" + source.getDatabaseName();
        }
        Connection con = getConnection(connectionUrl);
        String schemaName = source.getSchemaName();
        String tableName = source.getTableName();
        String table;
        if (schemaName == null) {
            table = tableName;
        } else {
            table = schemaName + "." + tableName;
        }
        String sql = "SELECT * FROM " + table + " LIMIT " + size;
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<String, Object>();
                for (TableColumn column : dataset.getColumns()) {
                    String columnName = column.getName();
                    row.put(columnName, rs.getObject(columnName));
                }
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (SQLException e) {
                // do nothing
            }
        }
        return result;
    }

    public Connection getConnection(String connectionUrl) {
        try {
            for (Map.Entry<String, String> driver : drivers.entrySet()) {
                if (connectionUrl.contains(driver.getKey())) {
                    Class.forName(driver.getValue());
                    break;
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage(), e);
        }
        try {
            conn = DriverManager.getConnection(connectionUrl);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage(), e);
        }
        return conn;
    }

    private String translateDataType(String name) {
        if ("varchar".equals(name)) {
            return DataTypes.NVARCHAR.toString();
        }
        if ("timestamp".equals(name)) {
            return DataTypes.TIMESTAMP.toString();
        }
        if ("bit".equals(name) || "boolean".equals(name)) {
            return DataTypes.BOOLEAN.toString();
        }
        if (name.contains("int")) {
            return DataTypes.INTEGER.toString();
        }
        if (name.contains("float") || name.contains("decimal") || name.contains("numeric")) {
            return DataTypes.NUMERIC.toString();
        }
        return DataTypes.NVARCHAR.toString();
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
}
