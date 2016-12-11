package metastore.models;

import org.springframework.data.rest.core.config.Projection;

import java.sql.Time;
import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = FileDataset.class)
public interface FileDatasetClientProjection {

    String getName();

    FileDataSource getDataSource();

    FileType getFileType();

    SecurityClassification getSecurityClassification();

    String getNamespace();

    String getDescription();

    String getComments();

    String getArchitectureDomain();

    String getContactPerson();

    boolean isCustomerData();

    boolean isFinancialBankingData();

    boolean isIdAndServiceHistory();

    boolean isCreditCardData();

    boolean isFinancialReportingData();

    boolean isPrivacyData();

    boolean isRegulatoryData();

    boolean isNbnConfidentialData();

    boolean isNbnCompliant();

    String getSsuReady();

    String getSsuRemediationMethod();

    TimeUnit getAvailableHistoryUnitOfTime();

    int getAvailableHistoryUnits();

    int getHistoryDataSizeGb();

    int getRefreshDataSizeGb();

    boolean isBatch();

    TimeUnit getRefreshFrequencyUnitOfTime();

    int getRefreshFrequencyUnits();

    Time getTimeOfDayDataAvailable();

    TimeUnit getDataAvailableUnitOfTime();

    String getDataAvailableDaysOfWeek();

    TimeUnit getDataLatencyUnitOfTime();

    int getDataLatencyUnits();

    String getColumnDelimiter();

    boolean isHeaderRow();

    boolean isFooterRow();

    String getRowDelimiter();

    String getTextQualifier();

    boolean isMultiRecordset();

    CompressionType getCompressionType();

    List<RecordClientProjection> getRecords();

    List<FileColumnClientProjection> getColumns();

    List<EventTypeClientProjection> getEventTypes();

    List<CustomerIdMappingRuleClientProjection> getCustomerIdMappingRules();

    List<FileColumnClientProjection> getNaturalKeyColumns();
}
