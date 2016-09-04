package metastore.models;

import javax.persistence.*;

/**
 * Created by markmo on 22/05/15.
 */
@Entity
@Table(name = "xdjobs", schema = "meta")
public class XdJob {

    @Id
    @Column(name = "job_id")
    @SequenceGenerator(name = "job_id_seq", sequenceName = "xdjobs_job_id_seq")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "job_id_seq")
    private Integer id;

    @Column(name = "job_name")
    private String name;

    private String jarLocation;

    private boolean makeUnique;

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

    public String getJarLocation() {
        return jarLocation;
    }

    public void setJarLocation(String jarLocation) {
        this.jarLocation = jarLocation;
    }

    public boolean isMakeUnique() {
        return makeUnique;
    }

    public void setMakeUnique(boolean makeUnique) {
        this.makeUnique = makeUnique;
    }
}
