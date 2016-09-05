CREATE SCHEMA cxp;
CREATE SCHEMA meta;


CREATE SEQUENCE meta.comments_comment_id_seq;

CREATE TABLE meta.comments (
  comment_id INTEGER NOT NULL DEFAULT nextval('meta.comments_comment_id_seq'),
  comment VARCHAR(255) NOT NULL,
  column_id BIGINT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT comments_pk PRIMARY KEY (comment_id)
);

ALTER SEQUENCE meta.comments_comment_id_seq OWNED BY meta.comments.comment_id;


CREATE TABLE meta.data_column_comments (
  column_id BIGINT NOT NULL,
  comment_id INTEGER NOT NULL,
  CONSTRAINT data_column_comments_pk PRIMARY KEY (column_id, comment_id)
);


CREATE TABLE meta.column_tags (
  column_id BIGINT NOT NULL,
  tag_id INTEGER NOT NULL,
  CONSTRAINT column_tags_pk PRIMARY KEY (column_id, tag_id)
);


CREATE SEQUENCE meta.metrics_metric_id_seq;

CREATE TABLE meta.metrics (
  metric_id INTEGER NOT NULL DEFAULT nextval('meta.metrics_metric_id_seq'),
  metric_name VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  CONSTRAINT metrics_pk PRIMARY KEY (metric_id)
);

ALTER SEQUENCE meta.metrics_metric_id_seq OWNED BY meta.metrics.metric_id;


CREATE SEQUENCE meta.analysis_types_analysis_type_id_seq;

CREATE TABLE meta.analysis_types (
  analysis_type_id INTEGER NOT NULL DEFAULT nextval('meta.analysis_types_analysis_type_id_seq'),
  analysis_type_name VARCHAR(100) NOT NULL,
  CONSTRAINT analysis_types_pk PRIMARY KEY (analysis_type_id)
);

ALTER SEQUENCE meta.analysis_types_analysis_type_id_seq OWNED BY meta.analysis_types.analysis_type_id;


CREATE TABLE meta.metric_values (
  analysis_type_id INTEGER NOT NULL,
  metric_id INTEGER NOT NULL,
  column_id BIGINT NOT NULL,
  numeric_value NUMERIC,
  string_value VARCHAR,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT metric_values_pk PRIMARY KEY (analysis_type_id, metric_id, column_id)
);


CREATE SEQUENCE meta.analytical_models_model_id_seq;

CREATE TABLE meta.analytical_models (
  model_id INTEGER NOT NULL DEFAULT nextval('meta.analytical_models_model_id_seq'),
  model_name VARCHAR(100) NOT NULL,
  version VARCHAR(100),
  committer VARCHAR(100),
  contact_person VARCHAR(100),
  description VARCHAR(8000),
  ensemble BOOLEAN DEFAULT FALSE NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT analytical_models_pk PRIMARY KEY (model_id)
);

ALTER SEQUENCE meta.analytical_models_model_id_seq OWNED BY meta.analytical_models.model_id;


CREATE TABLE meta.related_analytical_models (
  model_id_1 INTEGER NOT NULL,
  model_id_2 INTEGER NOT NULL,
  CONSTRAINT related_analytical_models_pk PRIMARY KEY (model_id_1, model_id_2)
);


CREATE SEQUENCE meta.analytical_model_packages_package_id_seq;

CREATE TABLE meta.analytical_model_packages (
  package_id INTEGER NOT NULL DEFAULT nextval('meta.analytical_model_packages_package_id_seq'),
  package_name VARCHAR(100) NOT NULL,
  version VARCHAR(100),
  description VARCHAR(8000),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT analytical_model_packages_pk PRIMARY KEY (package_id)
);

ALTER SEQUENCE meta.analytical_model_packages_package_id_seq OWNED BY meta.analytical_model_packages.package_id;


CREATE TABLE meta.model_packages_link (
  model_id INTEGER NOT NULL,
  package_id INTEGER NOT NULL,
  CONSTRAINT model_packages_link_pk PRIMARY KEY (model_id, package_id)
);


CREATE SEQUENCE meta.tags_tag_id_seq;

CREATE TABLE meta.tags (
  tag_id INTEGER NOT NULL DEFAULT nextval('meta.tags_tag_id_seq'),
  tag_name VARCHAR(100) NOT NULL,
  CONSTRAINT tags_pk PRIMARY KEY (tag_id)
);

ALTER SEQUENCE meta.tags_tag_id_seq OWNED BY meta.tags.tag_id;


CREATE SEQUENCE meta.feature_families_feature_family_id_seq;

CREATE TABLE meta.feature_families (
  feature_family_id INTEGER NOT NULL DEFAULT nextval('meta.feature_families_feature_family_id_seq'),
  feature_family_name VARCHAR(100) NOT NULL,
  description VARCHAR,
  wide_table_name VARCHAR(100) NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT feature_families_pk PRIMARY KEY (feature_family_id)
);

ALTER SEQUENCE meta.feature_families_feature_family_id_seq OWNED BY meta.feature_families.feature_family_id;


CREATE TABLE meta.feature_family_types (
  feature_family_id INTEGER NOT NULL,
  feature_type_id INTEGER NOT NULL,
  CONSTRAINT feature_family_types_pk PRIMARY KEY (feature_family_id, feature_type_id)
);


CREATE TABLE meta.feature_type_tags (
  feature_type_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  CONSTRAINT feature_type_tags_pk PRIMARY KEY (feature_type_id, tag_id)
);


CREATE SEQUENCE meta.feature_tests_feature_test_id_seq;

CREATE TABLE meta.feature_tests (
  feature_test_id INTEGER NOT NULL DEFAULT nextval('meta.feature_tests_feature_test_id_seq'),
  feature_type_id INTEGER NOT NULL,
  description VARCHAR(255),
  status VARCHAR(50),
  dbname VARCHAR(100),
  eval_expression VARCHAR(8000) NOT NULL,
  where_expression VARCHAR(8000) NOT NULL,
  author_name VARCHAR(100),
  author_email VARCHAR(100),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT feature_tests_pk PRIMARY KEY (feature_test_id)
);

ALTER SEQUENCE meta.feature_tests_feature_test_id_seq OWNED BY meta.feature_tests.feature_test_id;


CREATE TABLE meta.feature_test_results (
  feature_test_id INTEGER NOT NULL,
  run_ts TIMESTAMP NOT NULL,
  outcome BIT NOT NULL,
  message VARCHAR(255),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT feature_test_results_pk PRIMARY KEY (feature_test_id, run_ts)
);


CREATE SEQUENCE meta.transformations_transformation_id_seq;

CREATE TABLE meta.transformations (
  transformation_id BIGINT NOT NULL DEFAULT nextval('meta.transformations_transformation_id_seq'),
  transformation_name VARCHAR(100) NOT NULL,
  output_dataset_id BIGINT,
  routine TEXT,
  reference VARCHAR,
  language VARCHAR(50),
  lead_committer VARCHAR(100),
  contact_email VARCHAR(100),
  repo VARCHAR,
  commit_hash VARCHAR,
  version INTEGER,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT transformations_pk PRIMARY KEY (transformation_id)
);

ALTER SEQUENCE meta.transformations_transformation_id_seq OWNED BY meta.transformations.transformation_id;


CREATE TABLE meta.transformed_sets (
  transformation_id BIGINT NOT NULL,
  dataset_id BIGINT NOT NULL,
  CONSTRAINT transformed_sets_pk PRIMARY KEY (transformation_id, dataset_id)
);


CREATE SEQUENCE meta.xdjobs_job_id_seq;

CREATE TABLE meta.xdjobs (
  job_id INTEGER NOT NULL DEFAULT nextval('meta.xdjobs_job_id_seq'),
  job_name VARCHAR(100) NOT NULL,
  jar_location VARCHAR,
  make_unique BOOLEAN,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT xdjobs_pk PRIMARY KEY (job_id)
);

ALTER SEQUENCE meta.xdjobs_job_id_seq OWNED BY meta.xdjobs.job_id;


CREATE SEQUENCE meta.streams_stream_id_seq;

CREATE TABLE meta.streams (
  stream_id INTEGER NOT NULL DEFAULT nextval('meta.streams_stream_id_seq'),
  stream_name VARCHAR(100) NOT NULL,
  namespace VARCHAR(100),
  polling_directory VARCHAR,
  filename_pattern VARCHAR(100),
  prevent_duplicates BOOLEAN,
  job VARCHAR(50),
  definition VARCHAR,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT streams_pk PRIMARY KEY (stream_id)
);

ALTER SEQUENCE meta.streams_stream_id_seq OWNED BY meta.streams.stream_id;


CREATE TABLE meta.natural_key (
  dataset_id BIGINT NOT NULL,
  column_id BIGINT NOT NULL,
  CONSTRAINT natural_key_pk PRIMARY KEY (dataset_id, column_id)
);


CREATE TABLE meta.key_values (
  key VARCHAR(100) NOT NULL,
  value VARCHAR,
  value_type VARCHAR(50),
  created_ts TIMESTAMP,
  CONSTRAINT key_values_pk PRIMARY KEY (key)
);


CREATE SEQUENCE meta.queries_query_id_seq;

CREATE TABLE meta.queries (
  query_id INTEGER NOT NULL DEFAULT nextval('meta.queries_query_id_seq'),
  username VARCHAR(50) NOT NULL,
  query TEXT NOT NULL,
  primary_table VARCHAR(100),
  tables VARCHAR,
  columns VARCHAR,
  created_ts TIMESTAMP,
  CONSTRAINT queries_pk PRIMARY KEY (query_id)
);


ALTER SEQUENCE meta.queries_query_id_seq OWNED BY meta.queries.query_id;


CREATE TABLE meta.settings (
  name VARCHAR(50) NOT NULL,
  value TEXT NOT NULL,
  description VARCHAR(255),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT settings_pk PRIMARY KEY (name)
);


CREATE TABLE meta.err_events (
  error_message VARCHAR,
  skipped BOOLEAN,
  event_type_id INTEGER,
  dataset_id BIGINT,
  source_filename VARCHAR,
  source_key VARCHAR,
  value TEXT,
  job_id BIGINT,
  process_name VARCHAR(100),
  created_ts TIMESTAMP
);


CREATE SEQUENCE meta.form_schemas_form_schema_id_seq;

CREATE TABLE meta.form_schemas (
  form_schema_id INTEGER NOT NULL DEFAULT nextval('meta.form_schemas_form_schema_id_seq'),
  form_schema_name VARCHAR(100) NOT NULL,
  description VARCHAR,
  json_schema TEXT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT form_schemas_pk PRIMARY KEY (form_schema_id)
);

ALTER SEQUENCE meta.form_schemas_form_schema_id_seq OWNED BY meta.form_schemas.form_schema_id;


CREATE SEQUENCE meta.event_type_reln_type_event_type_reln_type_id_seq_1;

CREATE TABLE meta.event_type_reln_type (
  event_type_reln_type_id INTEGER NOT NULL DEFAULT nextval('meta.event_type_reln_type_event_type_reln_type_id_seq_1'),
  event_type_reln_type_name VARCHAR NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_type_reln_type_pk PRIMARY KEY (event_type_reln_type_id)
);

ALTER SEQUENCE meta.event_type_reln_type_event_type_reln_type_id_seq_1 OWNED BY meta.event_type_reln_type.event_type_reln_type_id;


CREATE SEQUENCE meta.data_sources_data_source_id_seq;

CREATE TABLE meta.data_sources (
  data_source_id BIGINT NOT NULL DEFAULT nextval('meta.data_sources_data_source_id_seq'),
  data_source_type VARCHAR(50) NOT NULL,
  data_source_name VARCHAR(100) NOT NULL,
  sourcing_method VARCHAR(50),
  hostname VARCHAR(100),
  ipaddr VARCHAR(15),
  port SMALLINT,
  network VARCHAR(10),
  file_path VARCHAR,
  filename_pattern VARCHAR,
  server_type VARCHAR(100),
  server_version VARCHAR(50),
  database_name VARCHAR(50),
  connection_url VARCHAR,
  catalog_name VARCHAR(50),
  schema_name VARCHAR(50),
  table_name VARCHAR(100),
  view_name VARCHAR(100),
  username VARCHAR(100),
  password VARCHAR(100),
  query TEXT,
  api_url VARCHAR,
  firewall_status VARCHAR(50),
  description VARCHAR,
  analysis_status VARCHAR(50),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT data_sources_pk PRIMARY KEY (data_source_id)
);
COMMENT ON COLUMN meta.data_sources.data_source_type IS 'Examples: Database, File, API';
COMMENT ON COLUMN meta.data_sources.data_source_name IS 'Example: SHARP-EDGE 1.0';
COMMENT ON COLUMN meta.data_sources.network IS 'Examples: EDN, BIGPOND, NEXUS';

ALTER SEQUENCE meta.data_sources_data_source_id_seq OWNED BY meta.data_sources.data_source_id;


CREATE SEQUENCE meta.security_classifications_security_classification_id_seq;

CREATE TABLE meta.security_classifications (
  security_classification_id INTEGER NOT NULL DEFAULT nextval('meta.security_classifications_security_classification_id_seq'),
  security_classification_name VARCHAR(50) NOT NULL,
  process_name VARCHAR(50),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT security_classifications_pk PRIMARY KEY (security_classification_id)
);


ALTER SEQUENCE meta.security_classifications_security_classification_id_seq OWNED BY meta.security_classifications.security_classification_id;

CREATE SEQUENCE meta.data_types_data_type_id_seq;

CREATE TABLE meta.data_types (
  data_type_id INTEGER NOT NULL DEFAULT nextval('meta.data_types_data_type_id_seq'),
  data_type_name VARCHAR(100) NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT data_types_pk PRIMARY KEY (data_type_id)
);


ALTER SEQUENCE meta.data_types_data_type_id_seq OWNED BY meta.data_types.data_type_id;

CREATE SEQUENCE meta.value_types_value_type_id_seq;

CREATE TABLE meta.value_types (
  value_type_id INTEGER NOT NULL DEFAULT nextval('meta.value_types_value_type_id_seq'),
  value_type_name VARCHAR(100) NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT value_types_pk PRIMARY KEY (value_type_id)
);
COMMENT ON TABLE meta.value_types IS 'Examples:
* character
* categorical
* numeric
* integer
* boolean';


ALTER SEQUENCE meta.value_types_value_type_id_seq OWNED BY meta.value_types.value_type_id;


CREATE SEQUENCE cxp.customer_id_types_cust_id_type_id_seq;

CREATE TABLE cxp.customer_id_types (
  customer_id_type_id INTEGER NOT NULL DEFAULT nextval('cxp.customer_id_types_cust_id_type_id_seq'),
  customer_id_type_name VARCHAR(50) NOT NULL,
  description VARCHAR,
  composite BOOLEAN,
  composition_rule TEXT,
  parent_id INTEGER,
  data_type_id INTEGER,
  value_type_id INTEGER,
  marked_for_deletion BOOLEAN,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT customer_id_types_pk PRIMARY KEY (customer_id_type_id)
);

ALTER SEQUENCE cxp.customer_id_types_cust_id_type_id_seq OWNED BY cxp.customer_id_types.customer_id_type_id;


CREATE SEQUENCE meta.customer_id_mapping_rules_id_seq;

CREATE TABLE meta.customer_id_mapping_rules (
  customer_id_mapping_rule_id INTEGER NOT NULL DEFAULT nextval('meta.customer_id_mapping_rules_id_seq'),
  customer_id_mapping_rule_name VARCHAR(100) NOT NULL,
  customer_id_type_id_1 INTEGER NOT NULL,
  customer_id_type_id_2 INTEGER NOT NULL,
  filterExpression VARCHAR,
  customer_id_1_expression VARCHAR,
  customer_id_2_expression VARCHAR,
  start_ts_expression VARCHAR,
  start_ts_format VARCHAR(50),
  start_ts_timezone VARCHAR(50) DEFAULT 'Australia/Melbourne',
  end_ts_expression VARCHAR,
  end_ts_format VARCHAR(50),
  end_ts_timezone VARCHAR(50) DEFAULT 'Australia/Melbourne',
  confidence_level FLOAT8,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT customer_id_mapping_rules_pk PRIMARY KEY (customer_id_mapping_rule_id)
);

ALTER SEQUENCE meta.customer_id_mapping_rules_id_seq OWNED BY meta.customer_id_mapping_rules.customer_id_mapping_rule_id;


CREATE SEQUENCE meta.id_mapping_rules_datasets_id_seq;

CREATE TABLE meta.id_mapping_rules_datasets (
  id INTEGER NOT NULL DEFAULT nextval('meta.id_mapping_rules_datasets_id_seq'),
  customer_id_mapping_rule_id INTEGER NOT NULL,
  dataset_id BIGINT NOT NULL,
  created_ts TIMESTAMP,
  CONSTRAINT id_mapping_rules_datasets_pk PRIMARY KEY (id)
);

ALTER SEQUENCE meta.id_mapping_rules_datasets_id_seq OWNED BY meta.id_mapping_rules_datasets.id;


CREATE SEQUENCE cxp.customer_id_mapping_id_seq;

CREATE TABLE cxp.customer_id_mapping (
  id BIGINT NOT NULL DEFAULT nextval('cxp.customer_id_mapping_id_seq'),
  customer_id_type_id_1 INTEGER NOT NULL,
  customer_id_1 VARCHAR NOT NULL,
  customer_id_type_id_2 INTEGER NOT NULL,
  customer_id_2 VARCHAR NOT NULL,
  confidence FLOAT8,
  start_ts TIMESTAMP,
  end_ts TIMESTAMP,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT customer_id_mapping_pk PRIMARY KEY (id)
);

ALTER SEQUENCE cxp.customer_id_mapping_id_seq OWNED BY cxp.customer_id_mapping.id;


CREATE SEQUENCE meta.datasets_dataset_id_seq;

CREATE TABLE meta.datasets (
  dataset_id BIGINT NOT NULL DEFAULT nextval('meta.datasets_dataset_id_seq'),
  dataset_type VARCHAR(10) NOT NULL,
  multi_recordset BOOLEAN,
  file_type VARCHAR(10) NOT NULL DEFAULT 'DELIMITED',
  data_source_id BIGINT NOT NULL,
  security_classification_id INTEGER,
  dataset_name VARCHAR NOT NULL,
  namespace VARCHAR(100),
  description VARCHAR,
  comments VARCHAR,
  architecture_domain VARCHAR(50),
  contact_person VARCHAR(100),
  customer_data BOOLEAN,
  financial_banking_data BOOLEAN,
  id_and_service_history BOOLEAN,
  credit_card_data BOOLEAN,
  financial_reporting_data BOOLEAN,
  privacy_data BOOLEAN,
  regulatory_data BOOLEAN,
  nbn_confidential_data BOOLEAN,
  nbn_compliant BOOLEAN,
  ssu_ready VARCHAR,
  ssu_remediation_method VARCHAR,
  available_history_unit_of_time VARCHAR(10),
  available_history_units SMALLINT,
  history_data_size_gb SMALLINT,
  refresh_data_size_gb SMALLINT,
  compression_type VARCHAR(10),
  column_delimiter VARCHAR(10),
  header_row BOOLEAN,
  footer_row BOOLEAN,
  row_delimiter VARCHAR(10),
  text_qualifier VARCHAR(10),
  batch BOOLEAN,
  refresh_frequency_unit_of_time VARCHAR(10),
  refresh_frequency_units SMALLINT,
  time_of_day_data_available TIME,
  data_available_unit_of_time VARCHAR(10),
  data_available_days_of_week VARCHAR,
  data_latency_unit_of_time VARCHAR(10),
  data_latency_units SMALLINT,
  analysis_status VARCHAR(50),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT datasets_pk PRIMARY KEY (dataset_id)
);
COMMENT ON COLUMN meta.datasets.dataset_type IS 'Values:
* File
* Database Table';
COMMENT ON COLUMN meta.datasets.architecture_domain IS 'Example: ENTERPRISE';
COMMENT ON COLUMN meta.datasets.ssu_ready IS 'Example: Combined but identifiable attributes';
COMMENT ON COLUMN meta.datasets.ssu_remediation_method IS 'For sha1_siiam.v_tca_case filter on X_OWNERSHIP_CODE to lookup table for BU identfiier to split retail/wholesale. For set3_fact_assurance filter on BUS_UNIT i.e. W= Wholesale.';
COMMENT ON COLUMN meta.datasets.available_history_unit_of_time IS 'Example: days, months';
COMMENT ON COLUMN meta.datasets.compression_type IS 'Values:
* None
* zip
* gzip
* tar
* tar.gz
* 7z';
COMMENT ON COLUMN meta.datasets.data_available_days_of_week IS 'Comma separated list. Sunday = 0.';

ALTER SEQUENCE meta.datasets_dataset_id_seq OWNED BY meta.datasets.dataset_id;


CREATE SEQUENCE meta.records_record_id_seq;

CREATE TABLE meta.records (
  record_id BIGINT NOT NULL DEFAULT nextval('meta.records_record_id_seq'),
  dataset_id BIGINT NOT NULL,
  record_name VARCHAR(100) NOT NULL,
  prefix VARCHAR(100) NOT NULL,
  description VARCHAR,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT records_pk PRIMARY KEY (record_id)
);

ALTER SEQUENCE meta.records_record_id_seq OWNED BY meta.records.record_id;


CREATE SEQUENCE cxp.jobs_job_id_seq;

CREATE TABLE cxp.jobs (
  job_id BIGINT NOT NULL DEFAULT nextval('cxp.jobs_job_id_seq'),
  dataset_id BIGINT,
  source_filename VARCHAR,
  process_name VARCHAR(100),
  job_start_ts TIMESTAMP NOT NULL,
  job_end_ts TIMESTAMP,
  job_status VARCHAR(50),
  exit_message VARCHAR,
  records_processed BIGINT,
  records_skipped BIGINT,
  events_created BIGINT,
  errors_logged BIGINT,
  CONSTRAINT jobs_pk PRIMARY KEY (job_id)
);

ALTER SEQUENCE cxp.jobs_job_id_seq OWNED BY cxp.jobs.job_id;


CREATE SEQUENCE cxp.jobs_test_job_id_seq;

CREATE TABLE cxp.jobs_test (
  job_id BIGINT NOT NULL DEFAULT nextval('cxp.jobs_test_job_id_seq'),
  dataset_id BIGINT,
  source_filename VARCHAR,
  process_name VARCHAR(100),
  job_start_ts TIMESTAMP NOT NULL,
  job_end_ts TIMESTAMP,
  job_status VARCHAR(50),
  exit_message VARCHAR,
  records_processed BIGINT,
  records_skipped BIGINT,
  events_created BIGINT,
  errors_logged BIGINT,
  CONSTRAINT jobs_test_pk PRIMARY KEY (job_id)
);

ALTER SEQUENCE cxp.jobs_test_job_id_seq OWNED BY cxp.jobs_test.job_id;


CREATE SEQUENCE meta.data_columns_column_id_seq;

CREATE TABLE meta.data_columns (
  column_id BIGINT NOT NULL DEFAULT nextval('meta.data_columns_column_id_seq'),
  column_type VARCHAR(10) NOT NULL,
  dataset_id BIGINT,
  record_id BIGINT,
  data_type_id INTEGER,
  original_data_type_id INTEGER,
  value_type_id INTEGER,
  column_index SMALLINT NOT NULL,
  column_name VARCHAR NOT NULL,
  description VARCHAR,
  character_set VARCHAR(50),
  collation_type VARCHAR(50),
  uniq BOOLEAN,
  nullable_type VARCHAR,
  length SMALLINT,
  default_value VARCHAR,
  autoinc BOOLEAN,
  dimension BOOLEAN,
  precision SMALLINT,
  scale SMALLINT,
  feature_param_candidate BOOLEAN,
  ignore BOOLEAN,
  customer_identifier BOOLEAN,
  customer_id_type_id INTEGER,
  analysis_status VARCHAR(50),
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT data_columns_pk PRIMARY KEY (column_id)
);
COMMENT ON COLUMN meta.data_columns.nullable_type IS 'Values:
* COLUMN_NO_NULLS
* COLUMN_NULLABLE
* COLUMN_NULLABLE_UNKNOWN';


ALTER SEQUENCE meta.data_columns_column_id_seq OWNED BY meta.data_columns.column_id;

CREATE TABLE meta.column_profile (
  column_id BIGINT NOT NULL,
  profile_ts TIMESTAMP NOT NULL,
  row_count BIGINT,
  distinct_count BIGINT,
  distinct_values TEXT,
  nulls BOOLEAN,
  min_length SMALLINT,
  max_length SMALLINT,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT column_profile_pk PRIMARY KEY (column_id, profile_ts)
);


CREATE SEQUENCE meta.feature_types_feature_type_id_seq;

CREATE TABLE meta.feature_types (
  feature_type_id INTEGER NOT NULL DEFAULT nextval('meta.feature_types_feature_type_id_seq'),
  feature_name VARCHAR(100) NOT NULL,
  attribute_type VARCHAR(50),
  status VARCHAR(50),
  security_classification_id INTEGER,
  customer_id_type_id INTEGER,
  value_type_id INTEGER,
  snapshot_ts TIMESTAMP NOT NULL,
  column_name VARCHAR(30) NOT NULL,
  description VARCHAR,
  reference_type VARCHAR(50),
  reference VARCHAR(50),
  author_name VARCHAR(100),
  author_email VARCHAR(100),
  lang VARCHAR(50),
  dbname VARCHAR(100),
  expression TEXT,
  version INTEGER,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT feature_types_pk PRIMARY KEY (feature_type_id)
);

ALTER SEQUENCE meta.feature_types_feature_type_id_seq OWNED BY meta.feature_types.feature_type_id;


CREATE TABLE meta.feature_type_dependencies (
  independent_feature_type_id INTEGER NOT NULL,
  dependent_feature_type_id INTEGER NOT NULL,
  CONSTRAINT feature_type_dependencies_pk PRIMARY KEY (dependent_feature_type_id, independent_feature_type_id)
);


CREATE TABLE cxp.features (
  entity_id VARCHAR NOT NULL,
  feature_type_id INTEGER NOT NULL,
  value VARCHAR NOT NULL,
  eval_ts TIMESTAMP NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP
  --CONSTRAINT features_pk PRIMARY KEY (entity_id, feature_type_id, value, eval_ts)
);


CREATE SEQUENCE meta.customer_property_types_property_type_id_seq;

CREATE TABLE meta.customer_property_types (
  property_type_id BIGINT NOT NULL DEFAULT nextval('meta.customer_property_types_property_type_id_seq'),
  security_classification_id INTEGER,
  value_type_id INTEGER,
  property_type VARCHAR NOT NULL,
  description VARCHAR,
  mapping_expression TEXT,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT customer_property_types_pk PRIMARY KEY (property_type_id)
);

ALTER SEQUENCE meta.customer_property_types_property_type_id_seq OWNED BY meta.customer_property_types.property_type_id;


CREATE SEQUENCE meta.cust_property_types_columns_id_seq;

CREATE TABLE meta.cust_property_types_columns (
  id INTEGER NOT NULL DEFAULT nextval('meta.cust_property_types_columns_id_seq'),
  property_type_id INTEGER NOT NULL,
  column_id BIGINT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT cust_property_types_columns_pk PRIMARY KEY (id)
);


ALTER SEQUENCE meta.cust_property_types_columns_id_seq OWNED BY meta.cust_property_types_columns.id;

CREATE SEQUENCE meta.customers_customer_surrogate_key_seq;

CREATE TABLE meta.customers (
  customer_surrogate_key BIGINT NOT NULL DEFAULT nextval('meta.customers_customer_surrogate_key_seq'),
  customer_id_type_id INTEGER NOT NULL,
  customer_id VARCHAR NOT NULL,
  value VARCHAR,
  version INTEGER,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT customers_pk PRIMARY KEY (customer_surrogate_key)
);


ALTER SEQUENCE meta.customers_customer_surrogate_key_seq OWNED BY meta.customers.customer_surrogate_key;

CREATE TABLE meta.customer_ids (
  customer_surrogate_key BIGINT NOT NULL,
  customer_id_type_id INTEGER NOT NULL,
  customer_id VARCHAR NOT NULL,
  confidence FLOAT8,
  version INTEGER,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT customer_ids_pk PRIMARY KEY (customer_surrogate_key, customer_id_type_id)
);


CREATE TABLE meta.customer_properties (
  customer_surrogate_key BIGINT NOT NULL,
  property_type_id INTEGER NOT NULL,
  value VARCHAR NOT NULL,
  version INTEGER,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT customer_properties_pk PRIMARY KEY (customer_surrogate_key, property_type_id)
);


CREATE SEQUENCE cxp.event_property_types_property_type_id_seq;

CREATE TABLE cxp.event_property_types (
  property_type_id BIGINT NOT NULL DEFAULT nextval('cxp.event_property_types_property_type_id_seq'),
  security_classification_id INTEGER,
  value_type_id INTEGER,
  property_type VARCHAR NOT NULL,
  description VARCHAR,
  mapping_expression TEXT,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_property_types_pk PRIMARY KEY (property_type_id)
);

ALTER SEQUENCE cxp.event_property_types_property_type_id_seq OWNED BY cxp.event_property_types.property_type_id;


CREATE SEQUENCE meta.event_property_types_columns_id_seq;

CREATE TABLE meta.event_property_types_columns (
  id INTEGER NOT NULL DEFAULT nextval('meta.event_property_types_columns_id_seq'),
  property_type_id INTEGER NOT NULL,
  column_id BIGINT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_property_types_columns_pk PRIMARY KEY (id)
);


ALTER SEQUENCE meta.event_property_types_columns_id_seq OWNED BY meta.event_property_types_columns.id;


CREATE SEQUENCE cxp.event_types_event_type_id_seq;

CREATE TABLE cxp.event_types (
  event_type_id INTEGER NOT NULL DEFAULT nextval('cxp.event_types_event_type_id_seq'),
  namespace VARCHAR,
  source_system VARCHAR(100), -- legacy support for Dimitri's columns
  event_type VARCHAR NOT NULL,
  event_subtype VARCHAR,
  description VARCHAR,
  ssu_group VARCHAR(10),
  value_type_id INTEGER,
  nested_document_expression TEXT,
  customer_id_type_id1 INTEGER,
  customer_id_expression1 TEXT,
  customer_id_type_id2 INTEGER,
  customer_id_expression2 TEXT,
  filter_expression TEXT,
  value_expression TEXT,
  ts_expression TEXT,
  datetime_format VARCHAR(50),
  timezone VARCHAR(50) DEFAULT 'Australia/Melbourne',
  event_value_desc VARCHAR,
  marked_for_deletion BOOLEAN,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  created_by VARCHAR(50),
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_types_pk PRIMARY KEY (event_type_id)
);
COMMENT ON COLUMN cxp.event_types.event_type IS 'Should be intuitive to a human.';
COMMENT ON COLUMN cxp.event_types.event_value_desc IS 'To support Dimitri''s work. Describes what the event value (comment) represents.';

ALTER SEQUENCE cxp.event_types_event_type_id_seq OWNED BY cxp.event_types.event_type_id;


CREATE SEQUENCE meta.event_types_records_id_seq;

CREATE TABLE meta.event_types_records (
  id INTEGER NOT NULL DEFAULT nextval('meta.event_types_records_id_seq'),
  event_type_id INTEGER NOT NULL,
  dataset_id BIGINT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_types_records_pk PRIMARY KEY (id)
);

ALTER SEQUENCE meta.event_types_records_id_seq OWNED BY meta.event_types_records.id;


CREATE TABLE meta.event_types_cust_id_types (
  event_type_id INTEGER NOT NULL,
  customer_id_type_id INTEGER NOT NULL,
  customer_id_expression TEXT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  CONSTRAINT event_types_cust_id_types_pk PRIMARY KEY (event_type_id, customer_id_type_id)
);


CREATE TABLE meta.event_types_columns (
  id INTEGER NOT NULL,
  event_type_id INTEGER NOT NULL,
  column_id BIGINT NOT NULL,
  role_type CHAR(1) NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_types_columns_pk PRIMARY KEY (id)
);
COMMENT ON COLUMN meta.event_types_columns.role_type IS 'V - value, T - ts';


CREATE SEQUENCE meta.event_types_datasets_id_seq;

CREATE TABLE meta.event_types_datasets (
  id INTEGER NOT NULL DEFAULT nextval('meta.event_types_datasets_id_seq'),
  event_type_id INTEGER NOT NULL,
  dataset_id BIGINT NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_types_datasets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE meta.event_types_datasets_id_seq OWNED BY meta.event_types_datasets.id;

CREATE TABLE meta.event_type_relationship (
  source_event_type_id INTEGER NOT NULL,
  target_event_type_id INTEGER NOT NULL,
  event_type_reln_type_id INTEGER NOT NULL,
  process_name VARCHAR(100),
  created_ts TIMESTAMP,
  modified_ts TIMESTAMP,
  modified_by VARCHAR(50),
  CONSTRAINT event_type_relationship_pk PRIMARY KEY (source_event_type_id, target_event_type_id, event_type_reln_type_id)
);


CREATE TABLE cxp.events (
  customer_id_type_id INTEGER NOT NULL,
  customer_id VARCHAR NOT NULL,
  event_type_id INTEGER NOT NULL,
  event_ts TIMESTAMP NOT NULL,
  event_version INTEGER NOT NULL,
  event_property TEXT,
  source_key VARCHAR,
  --value TEXT,
  --properties TEXT,
  job_id BIGINT,
  process_name VARCHAR(100),
  created_ts TIMESTAMP
  --CONSTRAINT events_pk PRIMARY KEY (customer_id_type_id, customer_id, event_type_id, event_ts, event_version)
)
WITH (
    OIDS=FALSE
)
;
COMMENT ON COLUMN cxp.events.customer_id IS 'Natural customer id in dataset.';
COMMENT ON COLUMN cxp.events.event_ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';


CREATE TABLE cxp.event_properties (
  customer_id_type_id INTEGER NOT NULL,
  customer_id VARCHAR NOT NULL,
  event_type_id INTEGER NOT NULL,
  event_ts TIMESTAMP NOT NULL,
  event_version INTEGER NOT NULL,
  property_type_id INTEGER NOT NULL,
  version INTEGER NOT NULL,
  value VARCHAR NOT NULL
  --CONSTRAINT event_properties_pk PRIMARY KEY (customer_id_type_id, customer_id, event_type_id, event_ts, event_version, property_type_id, version)
)
WITH (
OIDS=FALSE
)
;
COMMENT ON COLUMN cxp.event_properties.customer_id IS 'Natural customer id in dataset.';
COMMENT ON COLUMN cxp.event_properties.event_ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';
