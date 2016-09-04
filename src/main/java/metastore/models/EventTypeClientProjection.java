package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = EventType.class)
public interface EventTypeClientProjection {

    Integer getId();
    
    String getName();

    String getNamespace();

    String getDescription();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.customerIdType1?.name}")
    String getCustomerIdType1Name();

    String getCustomerIdExpression1();

    @Value("#{target.customerIdType2?.name}")
    String getCustomerIdType2Name();

    String getCustomerIdExpression2();

    String getFilterExpression();

    String getValueExpression();

    String getTsExpression();

    String getDatetimeFormat();

    String getTimezone();

    // TODO
    // to support > 2 customer id mappings per event type
//    List<CustomerIdTypeMappingClientProjection> getCustomerIdTypeMappings();
}
