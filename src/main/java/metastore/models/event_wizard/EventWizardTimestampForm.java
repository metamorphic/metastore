package metastore.models.event_wizard;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public class EventWizardTimestampForm {

    private String column;
    private String tsExpression;
    private String datetimeFormat;
    private String newDatetimeFormat;
    private String timezone;

    public String getColumn() {
        return column;
    }

    public void setColumn(String column) {
        this.column = column;
    }

    public String getTsExpression() {
        return tsExpression;
    }

    public void setTsExpression(String tsExpression) {
        this.tsExpression = tsExpression;
    }

    public String getDatetimeFormat() {
        return datetimeFormat;
    }

    public void setDatetimeFormat(String datetimeFormat) {
        this.datetimeFormat = datetimeFormat;
    }

    public String getNewDatetimeFormat() {
        return newDatetimeFormat;
    }

    public void setNewDatetimeFormat(String newDatetimeFormat) {
        this.newDatetimeFormat = newDatetimeFormat;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }
}
