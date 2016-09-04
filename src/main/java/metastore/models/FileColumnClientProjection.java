package metastore.models;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.core.config.Projection;

import java.util.List;

/**
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Projection(name = "client", types = FileColumn.class)
public interface FileColumnClientProjection {

    String getName();

    @Value("#{target.dataset?.name}")
    String getDatasetName();

    @Value("#{target.dataType?.name}")
    String getDataTypeName();

    @Value("#{target.valueType?.name}")
    String getValueTypeName();

    int getColumnIndex();

    String getDescription();

    String getCharacterSet();

    String getCollation();

    boolean isUnique();

    NullableType getNullableType();

    int getLength();

    String getDefaultValue();

    boolean isAutoinc();

    boolean isDimension();

    int getPrecision();

    int getScale();

    boolean isFeatureParamCandidate();

    boolean isIgnore();

    List<EventPropertyTypeClientProjection> getEventPropertyTypes();
}
