package metastore.services;

import static com.foundationdb.sql.parser.NodeTypes.*;

import com.foundationdb.sql.StandardException;
import com.foundationdb.sql.parser.*;
import com.foundationdb.sql.types.DataTypeDescriptor;
import metastore.models.SqlColumnMetadata;
import metastore.models.SqlStatementMetadata;
import metastore.models.SqlTableMetadata;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by markmo on 8/06/15.
 */
public class QueryTreeVisitor implements Visitor {

    private boolean define = false;
    private boolean select = false;
    private SqlTableMetadata baseSqlTableMetadata = null;
    private SqlTableMetadata sqlTableMetadata = null;
    private List<SqlColumnMetadata> sqlColumnMetadataList = new ArrayList<SqlColumnMetadata>();

    public SqlStatementMetadata getMetadata() {
        if (sqlColumnMetadataList.isEmpty()) {
            return null;
        }
        if (baseSqlTableMetadata == null) {
            baseSqlTableMetadata = sqlTableMetadata;
        }
        return new SqlStatementMetadata(baseSqlTableMetadata, sqlColumnMetadataList);
    }

    @Override
    public Visitable visit(Visitable visitable) throws StandardException {
        QueryTreeNode node = (QueryTreeNode)visitable;
        String schemaName;
        String tableName;
        String columnName;
        DataTypeDescriptor dataType;
        String dataTypeName;
        int length;
        switch (node.getNodeType()) {

            case SELECT_NODE:
                select = true;
                break;

            case CREATE_TABLE_NODE:
                CreateTableNode createTableNode = (CreateTableNode)node;
                schemaName = createTableNode.getObjectName().getSchemaName();
                tableName = createTableNode.getObjectName().getTableName();
                define = true;
                sqlTableMetadata = new SqlTableMetadata(schemaName, tableName);
                break;

            case COLUMN_DEFINITION_NODE:
                ColumnDefinitionNode columnDefinitionNode = (ColumnDefinitionNode)node;
                dataType = columnDefinitionNode.getType();
                dataTypeName = dataType.getTypeName();
                length = dataType.getMaximumWidth();
                columnName = columnDefinitionNode.getColumnName();
                if (define) {
                    sqlColumnMetadataList.add(new SqlColumnMetadata(sqlTableMetadata, columnName, dataTypeName, length));
                }
                break;

            case FROM_BASE_TABLE:
                FromBaseTable fromBaseTable = (FromBaseTable)node;
                schemaName = fromBaseTable.getTableName().getSchemaName();
                tableName = fromBaseTable.getTableName().getTableName();
                if (define) {
                    sqlTableMetadata = new SqlTableMetadata(schemaName, tableName);
                    baseSqlTableMetadata = sqlTableMetadata;
                }
                break;

            case TABLE_NAME:
                TableName tableNameNode = (TableName)node;
                schemaName = tableNameNode.getSchemaName();
                tableName = tableNameNode.getTableName();
                if (define) {
                    sqlTableMetadata = new SqlTableMetadata(schemaName, tableName);
                }
                break;

            case COLUMN_REFERENCE:
                ColumnReference columnReference = (ColumnReference)node;
                columnName = columnReference.getColumnName();
                if (define) {
                    dataType = columnReference.getType();
                    dataTypeName = dataType.getTypeName();
                    length = dataType.getMaximumWidth();
                    sqlColumnMetadataList.add(new SqlColumnMetadata(baseSqlTableMetadata, columnName, dataTypeName, length));
                }
                break;
        }
        return visitable;
    }

    @Override
    public boolean stopTraversal() {
        return false;
    }

    @Override
    public boolean skipChildren(Visitable visitable) {
        return false;
    }

    @Override
    public boolean visitChildrenFirst(Visitable visitable) {
        return false;
    }
}
