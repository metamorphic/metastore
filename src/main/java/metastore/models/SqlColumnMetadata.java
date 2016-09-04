package metastore.models;

/**
 * Created by markmo on 8/06/15.
 */
public class SqlColumnMetadata {

    private SqlTableMetadata sqlTableMetadata;

    private String columnName;

    private String dataType;

    private int length;

    public SqlColumnMetadata(SqlTableMetadata sqlTableMetadata, String columnName, String dataType, int length) {
        this.sqlTableMetadata = sqlTableMetadata;
        this.columnName = columnName;
        this.dataType = dataType;
        this.length = length;
    }

    public SqlTableMetadata getSqlTableMetadata() {
        return sqlTableMetadata;
    }

    public String getColumnName() {
        return columnName;
    }

    public String getDataType() {
        return dataType;
    }

    public int getLength() {
        return length;
    }
}
