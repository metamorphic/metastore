package metastore.controllers;

import metastore.models.*;
import metastore.models.event_wizard.*;
import metastore.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * API for Event Wizard.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Controller
public class EventWizardController {

    @Autowired
    FileDatasetRepository fileDatasetRepository;

    @Autowired
    EventTypeRepository eventTypeRepository;

    @Autowired
    CustomerIdTypeRepository customerIdTypeRepository;

    @Autowired
    FileColumnRepository fileColumnRepository;

    @Autowired
    FileDataSourceRepository fileDataSourceRepository;

    @RequestMapping(value = "/api/event-types/wizard", method = RequestMethod.POST)
    public @ResponseBody Integer createEvent(@RequestBody EventWizardDatasetForm form) {
        EventType eventType = new EventType();
        eventType.setName(form.getName());
        eventType.setNamespace(form.getNamespace());
        eventType.setDescription(form.getDescription());
        eventTypeRepository.save(eventType);

        FileDataset fileDataset = fileDatasetRepository.findOne(parseIdFromURI(form.getDataset()));

        if (form.isDeleteExistingEvents()) {
            if (fileDataset.getEventTypes() != null && !fileDataset.getEventTypes().isEmpty()) {
                List<EventType> eventTypes = new ArrayList<EventType>(fileDataset.getEventTypes());
                fileDataset.getEventTypes().clear();
                fileDatasetRepository.save(fileDataset);
                for (EventType t : eventTypes) {
                    eventTypeRepository.delete(t);
                }
            }
        }

        fileDataset.addEventType(eventType);
        fileDatasetRepository.save(fileDataset);

        return eventType.getId();
    }

    @RequestMapping(value = "/api/event-types/{eventTypeId}/wizard/customer-id", method = RequestMethod.POST)
    public @ResponseBody String setCustomerIdExtractionRule(@PathVariable("eventTypeId") Integer eventTypeId, @RequestBody EventWizardCustomerIdForm form) {
        EventType eventType = eventTypeRepository.findOne(eventTypeId);
        Long customerIdType1Id = parseIdFromURI(form.getCustomerIdType1());
        if (customerIdType1Id == null) {
            // TODO
            return "Bad Request";
        }
        CustomerIdType customerIdType1 = customerIdTypeRepository.findOne(customerIdType1Id.intValue());
        eventType.setCustomerIdType1(customerIdType1);
        if (form.getColumn1() == null) {
            eventType.setCustomerIdExpression1(form.getCustomerIdExpression1());
        } else {
            FileColumn fileColumn = fileColumnRepository.findOne(parseIdFromURI(form.getColumn1()));
            if (fileColumn.getDataset().getFileType() == FileType.JSON) {
                eventType.setCustomerIdExpression1(String.format("$.%s", fileColumn.getName()));
            } else {
                eventType.setCustomerIdExpression1(String.format("#this['%s']", fileColumn.getName()));
            }
        }
        if (form.getCustomerIdType2() != null) {
            Long customerIdType2Id = parseIdFromURI(form.getCustomerIdType2());
            if (customerIdType2Id != null) {
                CustomerIdType customerIdType2 = customerIdTypeRepository.findOne(customerIdType2Id.intValue());
                eventType.setCustomerIdType2(customerIdType2);
                if (form.getColumn2() == null) {
                    eventType.setCustomerIdExpression2(form.getCustomerIdExpression2());
                } else {
                    FileColumn fileColumn = fileColumnRepository.findOne(parseIdFromURI(form.getColumn2()));
                    if (fileColumn.getDataset().getFileType() == FileType.JSON) {
                        eventType.setCustomerIdExpression1(String.format("$.%s", fileColumn.getName()));
                    } else {
                        eventType.setCustomerIdExpression1(String.format("#this['%s']", fileColumn.getName()));
                    }
                }
            }
        }
        eventTypeRepository.save(eventType);
        return "Successfully set customer ID extraction rules on event type";
    }

    @RequestMapping(value = "/api/event-types/{eventTypeId}/wizard/filter", method = RequestMethod.POST)
    public @ResponseBody String setFilterExpression(@PathVariable("eventTypeId") Integer eventTypeId, @RequestBody EventWizardFilterForm form) {
        EventType eventType = eventTypeRepository.findOne(eventTypeId);
        eventType.setFilterExpression(form.getFilterExpression());
        eventTypeRepository.save(eventType);
        return "Successfully set filter expression on event type";
    }

    @RequestMapping(value = "/api/event-types/{eventTypeId}/wizard/timestamp", method = RequestMethod.POST)
    public @ResponseBody String setTimestampExtractionRule(@PathVariable("eventTypeId") Integer eventTypeId, @RequestBody EventWizardTimestampForm form) {
        EventType eventType = eventTypeRepository.findOne(eventTypeId);
        if (form.getColumn() == null) {
            eventType.setTsExpression(form.getTsExpression());
        } else {
            FileColumn fileColumn = fileColumnRepository.findOne(parseIdFromURI(form.getColumn()));
            if (fileColumn.getDataset().getFileType() == FileType.JSON) {
                eventType.setTsExpression(String.format("$.%s", fileColumn.getName()));
            } else {
                eventType.setTsExpression(String.format("#this['%s']", fileColumn.getName()));
            }
        }
        String newDatetimeFormat = form.getDatetimeFormat();
        if (newDatetimeFormat != null && !newDatetimeFormat.trim().isEmpty()) {
            eventType.setDatetimeFormat(newDatetimeFormat);
        } else {
            String datetimeFormat = form.getDatetimeFormat();
            if (datetimeFormat != null) {
                eventType.setDatetimeFormat(datetimeFormat);
            }
        }
        String timezone = form.getTimezone();
        if (timezone != null) {
            eventType.setTimezone(timezone);
        }
        eventTypeRepository.save(eventType);
        return "Successfully set timestamp extraction rule on event type";
    }

    @RequestMapping(value = "/api/file-datasets/{datasetId}/file-data-source/filepath", method = RequestMethod.GET)
    public @ResponseBody String getFilename(@PathVariable("datasetId") Long datasetId) {
        FileDataset fileDataset = fileDatasetRepository.findOne(datasetId);
        return fileDataset.getDataSource().getFilepath();
    }

    @RequestMapping(value = "/api/file-datasets/{datasetId}/wizard/filename-pattern", method = RequestMethod.POST)
    public @ResponseBody String setFilenamePattern(@PathVariable("datasetId") Long datasetId, @RequestBody EventWizardFilenamePatternForm form) {
        FileDataset fileDataset = fileDatasetRepository.findOne(datasetId);
        FileDataSource fileDataSource = fileDataset.getDataSource();
        fileDataSource.setFilenamePattern(form.getFilenamePattern());
        fileDataSourceRepository.save(fileDataSource);
        return "Successfully set filename pattern on data source of event";
    }

    private Long parseIdFromURI(String uri) {
        Pattern p = Pattern.compile("/(\\d+)$");
        Matcher matcher = p.matcher(uri);
        if (matcher.find()) {
            return Long.parseLong(matcher.group(1));
        }
        return null;
    }
}
