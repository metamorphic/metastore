package metastore.models;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
public class Stats {

    private Integer numberDatasets;
    private Long totalRecordsProcessed;
    private Long totalEvents;
    private Map<String, Long> totalEventsByType = new HashMap<String, Long>();
    private String start;
    private String end;
    private Map<String, Long> totalEventsByMonth = new HashMap<String, Long>();
    private Map<String, Long> totalEventsByDay = new HashMap<String, Long>();

    public Stats() {}

    public Stats(Integer numberDatasets, Long totalRecordsProcessed,
                 Long totalEvents, Map<String, Long> totalEventsByType,
                 String start, String end,
                 Map<String, Long> totalEventsByMonth,
                 Map<String, Long> totalEventsByDay) {
        this.numberDatasets = numberDatasets;
        this.totalRecordsProcessed = totalRecordsProcessed;
        this.totalEvents = totalEvents;
        this.totalEventsByType = totalEventsByType;
        this.start = start;
        this.end = end;
        this.totalEventsByMonth = totalEventsByMonth;
        this.totalEventsByDay = totalEventsByDay;
    }

    public Integer getNumberDatasets() {
        return numberDatasets;
    }

    public void setNumberDatasets(Integer numberDatasets) {
        this.numberDatasets = numberDatasets;
    }

    public Long getTotalRecordsProcessed() {
        return totalRecordsProcessed;
    }

    public void setTotalRecordsProcessed(Long totalRecordsProcessed) {
        this.totalRecordsProcessed = totalRecordsProcessed;
    }

    public Long getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(Long totalEvents) {
        this.totalEvents = totalEvents;
    }

    public Map<String, Long> getTotalEventsByType() {
        return totalEventsByType;
    }

    public void setTotalEventsByType(Map<String, Long> totalEventsByType) {
        this.totalEventsByType = totalEventsByType;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public Map<String, Long> getTotalEventsByMonth() {
        return totalEventsByMonth;
    }

    public void setTotalEventsByMonth(Map<String, Long> totalEventsByMonth) {
        this.totalEventsByMonth = totalEventsByMonth;
    }

    public Map<String, Long> getTotalEventsByDay() {
        return totalEventsByDay;
    }

    public void setTotalEventsByDay(Map<String, Long> totalEventsByDay) {
        this.totalEventsByDay = totalEventsByDay;
    }
}
