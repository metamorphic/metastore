SELECT ns.nspname AS schema_name, seq.relname AS seq_name
FROM pg_class AS seq
JOIN pg_namespace ns ON (seq.relnamespace=ns.oid)
WHERE seq.relkind = 'S'
  AND NOT EXISTS (SELECT * FROM pg_depend WHERE objid=seq.oid AND deptype='a')
ORDER BY seq.relname;

SELECT 'SELECT SETVAL(' ||
       quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
       ', COALESCE(MAX(' ||quote_ident(C.attname)|| '), 1) ) FROM ' ||
       quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';'
FROM pg_class AS S,
     pg_depend AS D,
     pg_class AS T,
     pg_attribute AS C,
     pg_tables AS PGT
WHERE S.relkind = 'S'
    AND S.oid = D.objid
    AND D.refobjid = T.oid
    AND D.refobjid = C.attrelid
    AND D.refobjsubid = C.attnum
    AND T.relname = PGT.tablename
ORDER BY S.relname;

SELECT 'ALTER SEQUENCE '|| quote_ident(min(schema_name)) ||'.'|| quote_ident(min(seq_name))
       ||' OWNED BY '|| quote_ident(min(schema_name)) ||'.'|| quote_ident(min(table_name)) ||'.'|| quote_ident(min(column_name)) ||';'
FROM (
    SELECT
        n.nspname AS schema_name,
        c.relname AS table_name,
        a.attname AS column_name,
        substring(d.adsrc FROM E'^nextval\\(''([^'']*)''(?:::text|::regclass)?\\)') AS seq_name
    FROM pg_class c
    JOIN pg_attribute a ON (c.oid=a.attrelid)
    JOIN pg_attrdef d ON (a.attrelid=d.adrelid AND a.attnum=d.adnum)
    JOIN pg_namespace n ON (c.relnamespace=n.oid)
    WHERE has_schema_privilege(n.oid,'USAGE')
      AND n.nspname NOT LIKE 'pg!_%' escape '!'
      AND has_table_privilege(c.oid,'SELECT')
      AND (NOT a.attisdropped)
      AND d.adsrc ~ '^nextval'
) seq
GROUP BY seq_name HAVING count(*)=1;



SELECT SETVAL('meta.analytical_model_packages_package_id_seq', COALESCE(MAX(package_id), 1) ) FROM meta.analytical_model_packages;
SELECT SETVAL('meta.analytical_models_model_id_seq', COALESCE(MAX(model_id), 1) ) FROM meta.analytical_models;
SELECT SETVAL('gcfr_meta.bkey_key_sets_key_set_id_seq', COALESCE(MAX(key_set_id), 1) ) FROM gcfr_meta.bkey_key_sets;
SELECT SETVAL('gcfr_meta.character_sets_character_set_id_seq', COALESCE(MAX(character_set_id), 1) ) FROM gcfr_meta.character_sets;
SELECT SETVAL('meta.cust_property_types_columns_id_seq', COALESCE(MAX(id), 1) ) FROM meta.cust_property_types_columns;
SELECT SETVAL('cxp.customer_id_mapping_id_seq', COALESCE(MAX(id), 1) ) FROM cxp.customer_id_mapping;
SELECT SETVAL('meta.customer_id_mapping_rules_id_seq', COALESCE(MAX(customer_id_mapping_rule_id), 1) ) FROM meta.customer_id_mapping_rules;
SELECT SETVAL('cxp.customer_id_types_cust_id_type_id_seq', COALESCE(MAX(customer_id_type_id), 1) ) FROM cxp.customer_id_types;
SELECT SETVAL('meta.customer_property_types_property_type_id_seq', COALESCE(MAX(property_type_id), 1) ) FROM meta.customer_property_types;
SELECT SETVAL('meta.customers_customer_surrogate_key_seq', COALESCE(MAX(customer_surrogate_key), 1) ) FROM meta.customers;
SELECT SETVAL('meta.data_columns_column_id_seq', COALESCE(MAX(column_id), 1) ) FROM meta.data_columns;
SELECT SETVAL('meta.data_sources_data_source_id_seq', COALESCE(MAX(data_source_id), 1) ) FROM meta.data_sources;
SELECT SETVAL('profiler.data_sources_data_source_id_seq', COALESCE(MAX(data_source_id), 1) ) FROM profiler.data_sources;
SELECT SETVAL('meta.data_sources_data_source_id_seq', COALESCE(MAX(data_source_id), 1) ) FROM meta.data_sources;
SELECT SETVAL('profiler.data_sources_data_source_id_seq', COALESCE(MAX(data_source_id), 1) ) FROM profiler.data_sources;
SELECT SETVAL('meta.data_types_data_type_id_seq', COALESCE(MAX(data_type_id), 1) ) FROM meta.data_types;
SELECT SETVAL('meta.datasets_dataset_id_seq', COALESCE(MAX(dataset_id), 1) ) FROM meta.datasets;
SELECT SETVAL('meta.event_property_types_columns_id_seq', COALESCE(MAX(id), 1) ) FROM meta.event_property_types_columns;
SELECT SETVAL('cxp.event_property_types_property_type_id_seq', COALESCE(MAX(property_type_id), 1) ) FROM cxp.event_property_types;
SELECT SETVAL('cxp.event_property_types_temp_property_type_id_seq', COALESCE(MAX(property_type_id), 1) ) FROM cxp.event_property_types_temp;
SELECT SETVAL('meta.event_type_reln_type_event_type_reln_type_id_seq_1', COALESCE(MAX(event_type_reln_type_id), 1) ) FROM meta.event_type_reln_type;
SELECT SETVAL('meta.event_types_datasets_id_seq', COALESCE(MAX(id), 1) ) FROM meta.event_types_datasets;
SELECT SETVAL('cxp.event_types_event_type_id_seq', COALESCE(MAX(event_type_id), 1) ) FROM cxp.event_types;
SELECT SETVAL('meta.event_types_records_id_seq', COALESCE(MAX(id), 1) ) FROM meta.event_types_records;
SELECT SETVAL('meta.feature_families_feature_family_id_seq', COALESCE(MAX(feature_family_id), 1) ) FROM meta.feature_families;
SELECT SETVAL('meta.feature_tests_feature_test_id_seq', COALESCE(MAX(feature_test_id), 1) ) FROM meta.feature_tests;
SELECT SETVAL('meta.feature_types_feature_type_id_seq', COALESCE(MAX(feature_type_id), 1) ) FROM meta.feature_types;
SELECT SETVAL('metaform.form_schemas_form_schema_id_seq', COALESCE(MAX(form_schema_id), 1) ) FROM metaform.form_schemas;
SELECT SETVAL('metaform.form_schemas_form_schema_id_seq', COALESCE(MAX(form_schema_id), 1) ) FROM metaform.form_schemas;
SELECT SETVAL('meta.form_schemas_form_schema_id_seq', COALESCE(MAX(form_schema_id), 1) ) FROM meta.form_schemas;
SELECT SETVAL('meta.form_schemas_form_schema_id_seq', COALESCE(MAX(form_schema_id), 1) ) FROM meta.form_schemas;
SELECT SETVAL('meta.id_mapping_rules_datasets_id_seq', COALESCE(MAX(id), 1) ) FROM meta.id_mapping_rules_datasets;
SELECT SETVAL('cxp.jobs_job_id_seq', COALESCE(MAX(job_id), 1) ) FROM cxp.jobs;
SELECT SETVAL('cxp.jobs_test_job_id_seq', COALESCE(MAX(job_id), 1) ) FROM cxp.jobs_test;
SELECT SETVAL('gcfr_meta.param_groups_param_group_id_seq', COALESCE(MAX(param_group_id), 1) ) FROM gcfr_meta.param_groups;
SELECT SETVAL('gcfr_meta.params_param_id_seq', COALESCE(MAX(param_id), 1) ) FROM gcfr_meta.params;
SELECT SETVAL('gcfr_meta.process_types_process_type_id_seq', COALESCE(MAX(process_type_id), 1) ) FROM gcfr_meta.process_types;
SELECT SETVAL('meta.records_record_id_seq', COALESCE(MAX(record_id), 1) ) FROM meta.records;
SELECT SETVAL('meta.security_classifications_security_classification_id_seq', COALESCE(MAX(security_classification_id), 1) ) FROM meta.security_classifications;
SELECT SETVAL('gcfr_meta.source_systems_source_system_id_seq', COALESCE(MAX(source_system_id), 1) ) FROM gcfr_meta.source_systems;
SELECT SETVAL('meta.streams_stream_id_seq', COALESCE(MAX(stream_id), 1) ) FROM meta.streams;
SELECT SETVAL('gcfr_meta.streams_stream_id_seq', COALESCE(MAX(stream_id), 1) ) FROM gcfr_meta.streams;
SELECT SETVAL('meta.streams_stream_id_seq', COALESCE(MAX(stream_id), 1) ) FROM meta.streams;
SELECT SETVAL('gcfr_meta.streams_stream_id_seq', COALESCE(MAX(stream_id), 1) ) FROM gcfr_meta.streams;
SELECT SETVAL('gcfr_meta.subject_areas_subject_area_id_seq', COALESCE(MAX(subject_area_id), 1) ) FROM gcfr_meta.subject_areas;
SELECT SETVAL('gcfr_meta.tables_table_id_seq', COALESCE(MAX(table_id), 1) ) FROM gcfr_meta.tables;
SELECT SETVAL('meta.tags_tag_id_seq', COALESCE(MAX(tag_id), 1) ) FROM meta.tags;
SELECT SETVAL('gcfr_meta.transform_mapping_transform_mapping_id_seq', COALESCE(MAX(transform_mapping_id), 1) ) FROM gcfr_meta.transform_mapping;
SELECT SETVAL('meta.transformations_transformation_id_seq', COALESCE(MAX(transformation_id), 1) ) FROM meta.transformations;
SELECT SETVAL('meta.value_types_value_type_id_seq', COALESCE(MAX(value_type_id), 1) ) FROM meta.value_types;
SELECT SETVAL('meta.xdjobs_job_id_seq', COALESCE(MAX(job_id), 1) ) FROM meta.xdjobs;
