package metastore.models.event_wizard;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public class EventWizardDatasetForm {

    private boolean deleteExistingEvents;
    private String name;
    private String dataset;
    private String namespace;
    private String description;

    public boolean isDeleteExistingEvents() {
        return deleteExistingEvents;
    }

    public void setDeleteExistingEvents(boolean deleteExistingEvents) {
        this.deleteExistingEvents = deleteExistingEvents;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDataset() {
        return dataset;
    }

    public void setDataset(String dataset) {
        this.dataset = dataset;
    }

    public String getNamespace() {
        return namespace;
    }

    public void setNamespace(String namespace) {
        this.namespace = namespace;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
