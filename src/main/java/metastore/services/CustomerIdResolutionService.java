package metastore.services;

import metastore.models.*;
import metastore.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Service
public class CustomerIdResolutionService {

    static final String UNKNOWN_CUSTOMER_ID_TYPE = "Unknown";

    @Autowired
    EventTypeRepository eventTypeRepository;

    @Autowired
    CustomerIdRepository customerIdRepository;

    @Autowired
    CustomerIdMappingRepository customerIdMappingRepository;

    @Autowired
    CustomerProfileRepository customerProfileRepository;

    @Autowired
    CustomerIdTypeRepository customerIdTypeRepository;

    public CustomerSurrogateKeyValue resolve(Integer customerIdTypeId, String customerId) {
        List<CustomerIdValue> resolutionPath = new ArrayList<CustomerIdValue>();

        CustomerIdType customerIdType = customerIdTypeRepository.findOne(customerIdTypeId);
        CustomerSurrogateKeyValue surrogateKeyValue = resolveCustomerId(customerIdType, customerId, resolutionPath);
        if (surrogateKeyValue != null) {
            return surrogateKeyValue;
        }

        // No previously processed customer found, therefore generate new
        // customer surrogate key
        CustomerProfile customerProfile = new CustomerProfile();
        String customerValue = "New Customer";
        customerProfile.setValue(customerValue);
        customerProfile.setVersion(1);
        customerProfile.setProcessName(this.getClass().getName());
        customerProfileRepository.save(customerProfile);

        CustomerIdPK pk = new CustomerIdPK();
        pk.setCustomerIdType(customerIdType);
        pk.setCustomerId(customerId);
        final CustomerId cid = new CustomerId();
        cid.setPk(pk);
        cid.setConfidence(.5);
        cid.setVersion(1);
        customerProfile.setCustomerIds(new ArrayList<CustomerId>() {{
            add(cid);
        }});
        customerProfileRepository.save(customerProfile);

        return new CustomerSurrogateKeyValue(customerProfile.getId(), customerValue, new ArrayList<CustomerIdValue>());
    }

    public CustomerSurrogateKeyValue resolve(String customerId, Integer eventTypeId) {
        List<CustomerIdValue> resolutionPath = new ArrayList<CustomerIdValue>();

        final EventType eventType = eventTypeRepository.findOne(eventTypeId);

        CustomerIdType unknownCustomerIdType;
        List<CustomerIdType> result = customerIdTypeRepository.findByName(UNKNOWN_CUSTOMER_ID_TYPE);
        if (result.isEmpty()) {
            unknownCustomerIdType = new CustomerIdType();
            unknownCustomerIdType.setName(UNKNOWN_CUSTOMER_ID_TYPE);
            customerIdTypeRepository.save(unknownCustomerIdType);
        } else {
            unknownCustomerIdType = result.get(0);
        }

        List<CustomerIdType> customerIdTypes = new ArrayList<CustomerIdType>() {{
            if (eventType.getCustomerIdType1() != null) add(eventType.getCustomerIdType1());
            if (eventType.getCustomerIdType2() != null) add(eventType.getCustomerIdType2());
        }};
        customerIdTypes.add(unknownCustomerIdType);
        for (CustomerIdType customerIdType : customerIdTypes) {
            CustomerSurrogateKeyValue surrogateKeyValue = resolveCustomerId(customerIdType, customerId, resolutionPath);
            if (surrogateKeyValue != null) {
                return surrogateKeyValue;
            }
        }

        // No previously processed customer found, therefore generate new
        // customer surrogate key
        CustomerProfile customerProfile = new CustomerProfile();
        String customerValue = "Created from event: " + eventType.getName();
        customerProfile.setValue(customerValue);
        customerProfile.setVersion(1);
        customerProfile.setProcessName(this.getClass().getName());
        customerProfileRepository.save(customerProfile);

        CustomerIdPK pk = new CustomerIdPK();
        pk.setCustomerIdType(unknownCustomerIdType);
        pk.setCustomerId(customerId);
        final CustomerId cid = new CustomerId();
        cid.setPk(pk);
        cid.setConfidence(.5);
        cid.setVersion(1);
        customerProfile.setCustomerIds(new ArrayList<CustomerId>() {{
            add(cid);
        }});
        customerProfileRepository.save(customerProfile);

        return new CustomerSurrogateKeyValue(customerProfile.getId(), customerValue, new ArrayList<CustomerIdValue>());
    }

    private CustomerSurrogateKeyValue resolveCustomerId(CustomerIdType customerIdType, String customerId, List<CustomerIdValue> resolutionPath) {
        resolutionPath.add(new CustomerIdValue(customerIdType, customerId));
        List<CustomerId> matches = customerIdRepository.findByPkCustomerIdTypeAndPkCustomerIdOrderByConfidenceDesc(customerIdType, customerId);

        // If more than 1 then need to consolidate customers
        if (!matches.isEmpty()) {
            CustomerId firstCustomerId = null;

            for (CustomerId match : matches) {
                if (firstCustomerId == null) {
                    firstCustomerId = match;
                } else {
                    // consolidate
                }
            }

            return new CustomerSurrogateKeyValue(firstCustomerId.getPk().getCustomerProfile().getId(), firstCustomerId.getPk().getCustomerProfile().getValue(), resolutionPath);
        }

        // no direct matches
        List<CustomerIdMapping> mappings = customerIdMappingRepository.findByCustomerIdType1AndCustomerId1(customerIdType, customerId);

        for (CustomerIdMapping mapping : mappings) {
            CustomerSurrogateKeyValue surrogateKeyValue = resolveCustomerId(mapping.getGetCustomerIdType2(), mapping.getCustomerId2(), resolutionPath);

            if (surrogateKeyValue != null) {
                return surrogateKeyValue;
            }
        }
        return null;
    }
}
