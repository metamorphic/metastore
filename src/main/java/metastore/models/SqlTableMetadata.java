package metastore.models;

/**
 * Created by markmo on 8/06/15.
 */
public class SqlTableMetadata {

    private String schemaName;

    private String tableName;

    public SqlTableMetadata(String schemaName, String tableName) {
        this.schemaName = schemaName;
        this.tableName = tableName;
    }

    public String getSchemaName() {
        return schemaName;
    }

    public String getTableName() {
        return tableName;
    }

    public String getQualifiedName() {
        return schemaName + "." + tableName;
    }
}
