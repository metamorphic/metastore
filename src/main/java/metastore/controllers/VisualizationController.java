package metastore.controllers;

import metastore.models.CustomerIdType;
import metastore.repositories.CustomerIdTypeRepository;
import metastore.services.VisualizationDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API to get data for visualizations.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Controller
public class VisualizationController {

    @Autowired
    VisualizationDataService dataService;

    @Autowired
    CustomerIdTypeRepository customerIdTypeRepository;

    @RequestMapping(value = "/api/viz/customer-id-types", method = RequestMethod.GET)
    public @ResponseBody List<Map<String, Object>> getCustomerIdTypes() {
        List<Map<String, Object>> customerIdTypes = new ArrayList<Map<String, Object>>();
        for (CustomerIdType customerIdType : customerIdTypeRepository.findAll()) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("label", customerIdType.getName());
            item.put("value", customerIdType.getId());
            customerIdTypes.add(item);
        }
        return customerIdTypes;
    }

    @RequestMapping(value = "/api/viz/customer-id-types/{customerIdTypeId}/sample", method = RequestMethod.GET)
    public @ResponseBody List<String> getCustomerSample(@PathVariable("customerIdTypeId") int customerIdTypeId,
                                                        @RequestParam(value = "n", defaultValue = "10") int sampleSize,
                                                        @RequestParam(value = "min-interactions", defaultValue = "5") int minInteractions) {
        return dataService.getCustomerSample(customerIdTypeId, sampleSize, minInteractions);
    }

    @RequestMapping(value = "/api/viz/customer-ids/sample", method = RequestMethod.GET)
    public @ResponseBody List<Map<String, Object>> getCustomerSample(@RequestParam(value = "n", defaultValue = "10") int sampleSize) {
        return dataService.getCustomerSample(sampleSize);
    }

    @RequestMapping(value = "/api/viz/timeline", method = RequestMethod.GET)
    public @ResponseBody List<Map<String, Object>> getTimeline(@RequestParam("customerIdTypeId") Integer customerIdTypeId,
                                                               @RequestParam("customerId") String customerId)
    {
        return dataService.getTimeline(customerIdTypeId, customerId);
    }

    @RequestMapping(value = "/api/viz/flow", method = RequestMethod.GET)
    public @ResponseBody Map<String, List<Map<String, Object>>> getEventFlow(@RequestParam(value = "n", defaultValue = "10") int numberPreviousInteractions) throws IOException {
        return dataService.getEventFlow(numberPreviousInteractions);
    }

    @RequestMapping(value = "/api/viz/flow/refresh", method = RequestMethod.GET)
    public @ResponseBody Map<String, List<Map<String, Object>>> refreshEventFlow(@RequestParam(value = "n", defaultValue = "10") int numberPreviousInteractions) throws IOException {
        return dataService.refreshEventFlow(numberPreviousInteractions);
    }

    @RequestMapping(value = "/api/viz/tree/{eventTypeName}", method = RequestMethod.GET)
    public @ResponseBody Map<String, Object> getNextEventTree(@PathVariable("eventTypeName") String eventTypeName,
                                                              @RequestParam(value = "depth", defaultValue = "10") int depth) throws IOException {
        return dataService.getNextEventTree(eventTypeName, depth);
    }

    @RequestMapping(value = "/api/viz/lifeflow", method = RequestMethod.GET)
    public @ResponseBody List<Map<String, Object>> eventLog(@RequestParam(value = "n", defaultValue = "100000") int limit) {
        return dataService.getEventLog(limit);
    }
}
