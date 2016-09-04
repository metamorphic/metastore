package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = CustomerIdMappingRule.class)
public interface CustomerIdMappingRuleGridProjection {

    String getName();

    @Value("#{target.customerIdType1?.name}")
    String getCustomerIdType1Name();

    @Value("#{target.customerIdType1?.id}")
    Integer getCustomerIdType1Id();

    @Value("#{target.customerIdType2?.name}")
    String getCustomerIdType2Name();

    @Value("#{target.customerIdType2?.id}")
    Integer getCustomerIdType2Id();

    String getFilterExpression();

    String getCustomerIdExpression1();

    String getCustomerIdExpression2();

    String getStartTimeExpression();

    String getStartTimeFormat();

    String getStartTimezone();

    String getEndTimeExpression();

    String getEndTimeFormat();

    String getEndTimezone();

    Double getConfidenceLevel();
}
