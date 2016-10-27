
ALTER TABLE meta.event_type_relationship ADD CONSTRAINT event_type_reln_type_event_type_relationship_fk
FOREIGN KEY (event_type_reln_type_id)
REFERENCES meta.event_type_reln_type (event_type_reln_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.datasets ADD CONSTRAINT data_source_datasets_fk
FOREIGN KEY (data_source_id)
REFERENCES meta.data_sources (data_source_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.datasets ADD CONSTRAINT security_classification_datasets_fk
FOREIGN KEY (security_classification_id)
REFERENCES meta.security_classifications (security_classification_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_property_types ADD CONSTRAINT security_classification_event_property_types_fk
FOREIGN KEY (security_classification_id)
REFERENCES meta.security_classifications (security_classification_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_property_types ADD CONSTRAINT security_classification_customer_property_types_fk
FOREIGN KEY (security_classification_id)
REFERENCES meta.security_classifications (security_classification_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.feature_types ADD CONSTRAINT security_classification_feature_types_fk
FOREIGN KEY (security_classification_id)
REFERENCES meta.security_classifications (security_classification_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.data_columns ADD CONSTRAINT data_types_columns_fk
FOREIGN KEY (data_type_id)
REFERENCES meta.data_types (data_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.customer_id_types ADD CONSTRAINT data_types_customer_id_types_fk
FOREIGN KEY (data_type_id)
REFERENCES meta.data_types (data_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.data_columns ADD CONSTRAINT value_types_columns_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_property_types ADD CONSTRAINT value_types_event_property_types_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_property_types ADD CONSTRAINT value_types_customer_property_types_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.feature_types ADD CONSTRAINT value_types_feature_types_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_types ADD CONSTRAINT value_types_event_types_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.customer_id_types ADD CONSTRAINT value_types_customer_id_types_fk
FOREIGN KEY (value_type_id)
REFERENCES meta.value_types (value_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.customer_id_mapping ADD CONSTRAINT customer_id_types_customer_id_mapping_fk
FOREIGN KEY (customer_id_type_id_1)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.customer_id_mapping ADD CONSTRAINT customer_id_types_customer_id_mapping_fk1
FOREIGN KEY (customer_id_type_id_2)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.customer_id_types ADD CONSTRAINT customer_id_types_customer_id_types_fk
FOREIGN KEY (parent_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.events ADD CONSTRAINT customer_id_types_events_fk
FOREIGN KEY (customer_id_type_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_cust_id_types ADD CONSTRAINT customer_id_types_events_types_cust_id_types_fk
FOREIGN KEY (customer_id_type_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.data_columns ADD CONSTRAINT customer_id_types_data_columns_fk
FOREIGN KEY (customer_id_type_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_ids ADD CONSTRAINT customer_id_types_customer_ids_fk
FOREIGN KEY (customer_id_type_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_id_mapping_rules ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk
FOREIGN KEY (customer_id_type_id_1)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_id_mapping_rules ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk1
FOREIGN KEY (customer_id_type_id_2)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_types ADD CONSTRAINT customer_id_types_event_types_fk
FOREIGN KEY (customer_id_type_id1)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_types ADD CONSTRAINT customer_id_types_event_types_fk1
FOREIGN KEY (customer_id_type_id2)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customers ADD CONSTRAINT customer_id_types_customers_fk
FOREIGN KEY (customer_id_type_id)
REFERENCES cxp.customer_id_types (customer_id_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.data_columns ADD CONSTRAINT datasets_columns_fk
FOREIGN KEY (dataset_id)
REFERENCES meta.datasets (dataset_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_datasets ADD CONSTRAINT datasets_event_types_datasets_fk
FOREIGN KEY (dataset_id)
REFERENCES meta.datasets (dataset_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.records ADD CONSTRAINT datasets_record_fk
FOREIGN KEY (dataset_id)
REFERENCES meta.datasets (dataset_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_records ADD CONSTRAINT datasets_event_types_records_fk
FOREIGN KEY (dataset_id)
REFERENCES meta.datasets (dataset_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.data_columns ADD CONSTRAINT record_data_columns_fk
FOREIGN KEY (record_id)
REFERENCES meta.records (record_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.events ADD CONSTRAINT jobs_events_fk
FOREIGN KEY (job_id)
REFERENCES cxp.jobs (job_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.column_profile ADD CONSTRAINT columns_column_profile_fk
FOREIGN KEY (column_id)
REFERENCES meta.data_columns (column_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_columns ADD CONSTRAINT columns_event_types_columns_fk
FOREIGN KEY (column_id)
REFERENCES meta.data_columns (column_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_property_types_columns ADD CONSTRAINT columns_event_property_types_columns_fk
FOREIGN KEY (column_id)
REFERENCES meta.data_columns (column_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.cust_property_types_columns ADD CONSTRAINT columns_cust_property_types_columns_fk
FOREIGN KEY (column_id)
REFERENCES meta.data_columns (column_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.cust_property_types_columns ADD CONSTRAINT customer_property_types_cust_property_types_columns_fk
FOREIGN KEY (property_type_id)
REFERENCES meta.customer_property_types (property_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_properties ADD CONSTRAINT customer_property_types_customer_properties_fk
FOREIGN KEY (property_type_id)
REFERENCES meta.customer_property_types (property_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_properties ADD CONSTRAINT customers_customer_properties_fk
FOREIGN KEY (customer_surrogate_key)
REFERENCES meta.customers (customer_surrogate_key)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.customer_ids ADD CONSTRAINT customers_customer_ids_fk
FOREIGN KEY (customer_surrogate_key)
REFERENCES meta.customers (customer_surrogate_key)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_properties ADD CONSTRAINT property_types_event_properties_fk
FOREIGN KEY (property_type_id)
REFERENCES cxp.event_property_types (property_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_property_types_columns ADD CONSTRAINT event_property_types_event_property_types_columns_fk
FOREIGN KEY (property_type_id)
REFERENCES cxp.event_property_types (property_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.events ADD CONSTRAINT dictionary_events_fk
FOREIGN KEY (event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_type_relationship ADD CONSTRAINT event_types_event_type_relationship_fk
FOREIGN KEY (source_event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_type_relationship ADD CONSTRAINT event_types_event_type_relationship_fk1
FOREIGN KEY (target_event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_datasets ADD CONSTRAINT event_types_event_types_datasets_fk
FOREIGN KEY (event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_columns ADD CONSTRAINT event_types_event_types_columns_fk
FOREIGN KEY (event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_cust_id_types ADD CONSTRAINT event_types_events_types_cust_id_types_fk
FOREIGN KEY (event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.event_types_records ADD CONSTRAINT event_types_event_types_records_fk
FOREIGN KEY (event_type_id)
REFERENCES cxp.event_types (event_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cxp.event_properties ADD CONSTRAINT event_log_event_properties_fk
FOREIGN KEY (customer_id_type_id, customer_id, event_type_id, ts, event_version)
REFERENCES cxp.events (customer_id_type_id, customer_id, event_type_id, ts, event_version)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE meta.feature_types ADD CONSTRAINT data_types_feature_types_fk
FOREIGN KEY (data_type_id)
REFERENCES meta.data_types (data_type_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
