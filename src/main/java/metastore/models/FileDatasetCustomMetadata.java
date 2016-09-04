package metastore.models;

/**
 * Created by markmo on 20/06/15.
 */
public class FileDatasetCustomMetadata {

    private String architectureDomain;
    private boolean financialBankingData;
    private boolean idAndServiceHistory;
    private boolean creditCardData;
    private boolean financialReportingData;
    private boolean privacyData;
    private boolean regulatoryData;
    private boolean nbnConfidentialData;
    private boolean nbnCompliant;
    private String ssuReady;
    private String ssuRemediationMethod;
    private int historyDataSizeGb;
    private int refreshDataSizeGb;

    public String getArchitectureDomain() {
        return architectureDomain;
    }

    public void setArchitectureDomain(String architectureDomain) {
        this.architectureDomain = architectureDomain;
    }

    public boolean isFinancialBankingData() {
        return financialBankingData;
    }

    public void setFinancialBankingData(boolean financialBankingData) {
        this.financialBankingData = financialBankingData;
    }

    public boolean isIdAndServiceHistory() {
        return idAndServiceHistory;
    }

    public void setIdAndServiceHistory(boolean idAndServiceHistory) {
        this.idAndServiceHistory = idAndServiceHistory;
    }

    public boolean isCreditCardData() {
        return creditCardData;
    }

    public void setCreditCardData(boolean creditCardData) {
        this.creditCardData = creditCardData;
    }

    public boolean isFinancialReportingData() {
        return financialReportingData;
    }

    public void setFinancialReportingData(boolean financialReportingData) {
        this.financialReportingData = financialReportingData;
    }

    public boolean isPrivacyData() {
        return privacyData;
    }

    public void setPrivacyData(boolean privacyData) {
        this.privacyData = privacyData;
    }

    public boolean isRegulatoryData() {
        return regulatoryData;
    }

    public void setRegulatoryData(boolean regulatoryData) {
        this.regulatoryData = regulatoryData;
    }

    public boolean isNbnConfidentialData() {
        return nbnConfidentialData;
    }

    public void setNbnConfidentialData(boolean nbnConfidentialData) {
        this.nbnConfidentialData = nbnConfidentialData;
    }

    public boolean isNbnCompliant() {
        return nbnCompliant;
    }

    public void setNbnCompliant(boolean nbnCompliant) {
        this.nbnCompliant = nbnCompliant;
    }

    public String getSsuReady() {
        return ssuReady;
    }

    public void setSsuReady(String ssuReady) {
        this.ssuReady = ssuReady;
    }

    public String getSsuRemediationMethod() {
        return ssuRemediationMethod;
    }

    public void setSsuRemediationMethod(String ssuRemediationMethod) {
        this.ssuRemediationMethod = ssuRemediationMethod;
    }

    public int getHistoryDataSizeGb() {
        return historyDataSizeGb;
    }

    public void setHistoryDataSizeGb(int historyDataSizeGb) {
        this.historyDataSizeGb = historyDataSizeGb;
    }

    public int getRefreshDataSizeGb() {
        return refreshDataSizeGb;
    }

    public void setRefreshDataSizeGb(int refreshDataSizeGb) {
        this.refreshDataSizeGb = refreshDataSizeGb;
    }
}
