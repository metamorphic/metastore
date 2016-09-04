package metastore.models;

import java.util.List;

/**
 * Created by markmo on 8/06/15.
 */
public class SqlStatementMetadata {

    private SqlTableMetadata baseSqlTableMetadata;

    private List<SqlColumnMetadata> sqlColumnMetadataList;

    public SqlStatementMetadata(SqlTableMetadata baseSqlTableMetadata, List<SqlColumnMetadata> sqlColumnMetadataList) {
        this.baseSqlTableMetadata = baseSqlTableMetadata;
        this.sqlColumnMetadataList = sqlColumnMetadataList;
    }

    public SqlTableMetadata getBaseSqlTableMetadata() {
        return baseSqlTableMetadata;
    }

    public List<SqlColumnMetadata> getSqlColumnMetadataList() {
        return sqlColumnMetadataList;
    }
}
