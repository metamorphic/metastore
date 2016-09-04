package metastore.models;

import io.metamorphic.fileservices.FileParameters;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public class DatasetInfo {

    private String fileType;
    private FileParameters fileParameters;
    private List<ColumnInfo> columns;
    private String error;

    public DatasetInfo() {}

    public DatasetInfo(String error) {
        this.error = error;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public FileParameters getFileParameters() {
        return fileParameters;
    }

    public void setFileParameters(FileParameters fileParameters) {
        this.fileParameters = fileParameters;
    }

    public List<ColumnInfo> getColumns() {
        return columns;
    }

    public void setColumns(List<ColumnInfo> columns) {
        this.columns = columns;
    }
}
