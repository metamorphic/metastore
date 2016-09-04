package metastore.eventlog.models;

import javax.persistence.*;
import java.util.Date;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Entity
@Table(name = "jobs", schema = "cxp")
public class Job {

    @Id
    @SequenceGenerator(name = "job_id_seq", sequenceName = "jobs_job_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "job_id_seq")
    @Column(name="job_id", updatable = false)
    private Long id;

    private Long datasetId;

    private String sourceFilename;

    private String processName;

    @Column(name = "job_start_ts")
    private Date start;

    @Column(name = "job_end_ts")
    private Date end;

    @Column(name = "job_status")
    private String status;

    private String exitMessage;

    private Long recordsProcessed;

    private Long recordsSkipped;

    private Long eventsCreated;

    private Long errorsLogged;

    @Column(name="modified_ts")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modified;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getDatasetId() {
        return datasetId;
    }

    public void setDatasetId(Long datasetId) {
        this.datasetId = datasetId;
    }

    public String getSourceFilename() {
        return sourceFilename;
    }

    public void setSourceFilename(String sourceFilename) {
        this.sourceFilename = sourceFilename;
    }

    public String getProcessName() {
        return processName;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }

    public Date getStart() {
        return  start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getExitMessage() {
        return exitMessage;
    }

    public void setExitMessage(String exitMessage) {
        this.exitMessage = exitMessage;
    }

    public Long getRecordsProcessed() {
        return recordsProcessed;
    }

    public void setRecordsProcessed(Long recordsProcessed) {
        this.recordsProcessed = recordsProcessed;
    }

    public Long getRecordsSkipped() {
        return recordsSkipped;
    }

    public void setRecordsSkipped(Long recordsSkipped) {
        this.recordsSkipped = recordsSkipped;
    }

    public Long getEventsCreated() {
        return eventsCreated;
    }

    public void setEventsCreated(Long eventsCreated) {
        this.eventsCreated = eventsCreated;
    }

    public Long getErrorsLogged() {
        return errorsLogged;
    }

    public void setErrorsLogged(Long errorsLogged) {
        this.errorsLogged = errorsLogged;
    }

    public Date getModified() {
        return modified;
    }

    public void setModified(Date modified) {
        this.modified = modified;
    }

    @PreUpdate
    public void updateAuditInfo() {
        this.modified = new Date();
    }
}
