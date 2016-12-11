package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = EventType.class)
public interface EventTypeGridProjection {

    Integer getId();

    String getName();

    String getNamespace();

    String getDescription();

    @Value("#{target.primaryDatasetId}")
    Long getDatasetId();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.valueType?.id}")
    Integer getValueTypeId();

    @Value("#{target.customerIdType1?.name}")
    String getCustomerIdType1Name();

    @Value("#{target.customerIdType1?.id}")
    Integer getCustomerIdType1Id();

    String getCustomerIdExpression1();

    @Value("#{target.customerIdType2?.name}")
    String getCustomerIdType2Name();

    @Value("#{target.customerIdType2?.id}")
    Integer getCustomerIdType2Id();

    String getCustomerIdExpression2();

    String getFilterExpression();

    String getValueExpression();

    String getTsExpression();

    String getDatetimeFormat();

    String getTimezone();
}
