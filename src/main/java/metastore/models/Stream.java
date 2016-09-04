package metastore.models;

import javax.persistence.*;

/**
 * Created by markmo on 21/05/15.
 */
@Entity
@Table(name = "streams", schema = "meta")
public class Stream extends AuditedModel {

    @Id
    @SequenceGenerator(name = "stream_id_seq", sequenceName = "streams_stream_id_seq")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "stream_id_seq")
    @Column(name = "stream_id")
    private Integer id;

    @Column(name = "stream_name")
    private String name;

    private String namespace;
    private String pollingDirectory;
    private String filenamePattern;
    private boolean preventDuplicates;
    private String job;
    private String definition;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNamespace() {
        return namespace;
    }

    public void setNamespace(String namespace) {
        this.namespace = namespace;
    }

    public String getPollingDirectory() {
        return pollingDirectory;
    }

    public void setPollingDirectory(String pollingDirectory) {
        this.pollingDirectory = pollingDirectory;
    }

    public String getFilenamePattern() {
        return filenamePattern;
    }

    public void setFilenamePattern(String filenamePattern) {
        this.filenamePattern = filenamePattern;
    }

    public boolean isPreventDuplicates() {
        return preventDuplicates;
    }

    public void setPreventDuplicates(boolean preventDuplicates) {
        this.preventDuplicates = preventDuplicates;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getDefinition() {
        return definition;
    }

    public void setDefinition(String definition) {
        this.definition = definition;
    }
}
