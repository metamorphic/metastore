package metastore.controllers;

import metastore.models.CustomerSurrogateKeyValue;
import metastore.services.CustomerIdResolutionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * API to resolve a customer natural id to a unique surrogate key.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@RestController
public class CustomerIdResolutionController {

    @Autowired
    CustomerIdResolutionService customerIdResolutionService;

    @RequestMapping(value = "/api/resolve-customer-id", method = RequestMethod.GET)
    public CustomerSurrogateKeyValue resolve(@RequestParam("customer-id-type-id") Integer customerIdTypeId,
                                             @RequestParam("customer-id") String customerId) {
        return customerIdResolutionService.resolve(customerIdTypeId, customerId);
    }
}
