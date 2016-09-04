package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "grid", types = CustomerIdType.class)
public interface CustomerIdTypeGridProjection {

    Integer getId();

    String getName();

    String getDescription();

    boolean isComposite();

    String getCompositionRule();

    @Value("#{target.parent?.name}")
    String getParentName();

    @Value("#{target.parent?.id}")
    Integer getParentId();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    @Value("#{target.valueType?.id}")
    Integer getValueTypeId();

    @Value("#{target.dataType?.name}")
    String getDataTypeName();

    @Value("#{target.dataType?.id}")
    Integer getDataTypeId();

}
