package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = CustomerIdType.class)
public interface CustomerIdTypeClientProjection {

    Integer getId();

    String getName();

    boolean isComposite();

    String getCompositionRule();

    @Value("#{target.parent?.id}")
    Integer getParentId();

    @Value("#{target.parent?.name}")
    String getParentName();

    @Value("#{target.dataType?.name}")
    String getDataTypeName();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    List<CustomerIdTypeClientProjection> getChildren();
}
