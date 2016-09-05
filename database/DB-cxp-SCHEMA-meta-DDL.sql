--
-- cxpQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: cxp
--

CREATE SCHEMA meta;


ALTER SCHEMA meta OWNER TO cxp;

SET search_path = meta, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: column_profile; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE column_profile (
    column_id bigint NOT NULL,
    profile_ts timestamp without time zone NOT NULL,
    row_count bigint,
    distinct_count bigint,
    distinct_values text,
    nulls boolean,
    min_length smallint,
    max_length smallint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE column_profile OWNER TO cxp;

--
-- Name: cust_property_types_columns; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE cust_property_types_columns (
    id integer NOT NULL,
    property_type_id integer NOT NULL,
    column_id bigint NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE cust_property_types_columns OWNER TO cxp;

--
-- Name: cust_property_types_columns_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE cust_property_types_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cust_property_types_columns_id_seq OWNER TO cxp;

--
-- Name: cust_property_types_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE cust_property_types_columns_id_seq OWNED BY cust_property_types_columns.id;


--
-- Name: customer_id_mapping_rules; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_id_mapping_rules (
    customer_id_mapping_rule_id integer NOT NULL,
    customer_id_mapping_rule_name character varying(100) NOT NULL,
    customer_id_type_id_1 integer NOT NULL,
    customer_id_type_id_2 integer NOT NULL,
    filterexpression character varying,
    customer_id_1_expression character varying,
    customer_id_2_expression character varying,
    start_ts_expression character varying,
    end_ts_expression character varying,
    confidence_level numeric,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255),
    filter_expression character varying(8000),
    end_ts_format character varying(255),
    end_ts_timezone character varying(255),
    start_ts_format character varying(255),
    start_ts_timezone character varying(255)
);


ALTER TABLE customer_id_mapping_rules OWNER TO cxp;

--
-- Name: customer_id_mapping_rules_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE customer_id_mapping_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_mapping_rules_id_seq OWNER TO cxp;

--
-- Name: customer_id_mapping_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE customer_id_mapping_rules_id_seq OWNED BY customer_id_mapping_rules.customer_id_mapping_rule_id;


--
-- Name: customer_ids; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_ids (
    customer_surrogate_key integer NOT NULL,
    customer_id_type_id integer NOT NULL,
    customer_id character varying NOT NULL,
    confidence numeric,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE customer_ids OWNER TO cxp;

--
-- Name: customer_properties; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_properties (
    customer_surrogate_key integer NOT NULL,
    property_type_id integer NOT NULL,
    value character varying NOT NULL,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE customer_properties OWNER TO cxp;

--
-- Name: customer_property_types; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_property_types (
    property_type_id integer NOT NULL,
    security_classification_id integer,
    value_type_id integer,
    property_type character varying NOT NULL,
    description character varying,
    mapping_expression text,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE customer_property_types OWNER TO cxp;

--
-- Name: customer_property_types_property_type_id_seq_1; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE customer_property_types_property_type_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_property_types_property_type_id_seq_1 OWNER TO cxp;

--
-- Name: customer_property_types_property_type_id_seq_1; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE customer_property_types_property_type_id_seq_1 OWNED BY customer_property_types.property_type_id;


--
-- Name: customers; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE customers (
    customer_surrogate_key integer NOT NULL,
    customer_id_type_id integer NOT NULL,
    customer_id character varying(100) NOT NULL,
    value character varying,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE customers OWNER TO cxp;

--
-- Name: customers_customer_surrogate_key_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE customers_customer_surrogate_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_customer_surrogate_key_seq OWNER TO cxp;

--
-- Name: customers_customer_surrogate_key_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE customers_customer_surrogate_key_seq OWNED BY customers.customer_surrogate_key;


--
-- Name: data_columns; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE data_columns (
    column_id bigint NOT NULL,
    column_type character varying(10) NOT NULL,
    dataset_id bigint,
    record_id bigint,
    data_type_id integer,
    value_type_id integer,
    column_index smallint NOT NULL,
    column_name character varying NOT NULL,
    description character varying,
    character_set character varying(50),
    collation_type character varying(50),
    uniq boolean,
    nullable_type character varying,
    length smallint,
    default_value character varying,
    autoinc boolean,
    dimension boolean,
    "precision" smallint,
    scale smallint,
    feature_param_candidate boolean,
    ignore boolean,
    customer_identifier boolean,
    customer_id_type_id integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE data_columns OWNER TO cxp;

--
-- Name: COLUMN data_columns.nullable_type; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN data_columns.nullable_type IS 'Values:
* COLUMN_NO_NULLS
* COLUMN_NULLABLE
* COLUMN_NULLABLE_UNKNOWN';


--
-- Name: data_columns_column_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE data_columns_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_columns_column_id_seq OWNER TO cxp;

--
-- Name: data_columns_column_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE data_columns_column_id_seq OWNED BY data_columns.column_id;


--
-- Name: data_sources; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE data_sources (
    data_source_id bigint NOT NULL,
    data_source_type character varying(50) NOT NULL,
    data_source_name character varying(100) NOT NULL,
    sourcing_method character varying(50),
    hostname character varying(100),
    ipaddr character varying(15),
    port smallint,
    network character varying(10),
    file_path character varying,
    filename_pattern character varying,
    database_name character varying(50),
    schema character varying(50),
    connection_url character varying,
    table_name character varying(100),
    view_name character varying(100),
    query text,
    api_url character varying,
    firewall_status character varying(50),
    description character varying,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    catalog_name character varying(255),
    schema_name character varying(255)
);


ALTER TABLE data_sources OWNER TO cxp;

--
-- Name: COLUMN data_sources.data_source_type; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN data_sources.data_source_type IS 'Examples: Database, File, API';


--
-- Name: COLUMN data_sources.data_source_name; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN data_sources.data_source_name IS 'Example: SHARP-EDGE 1.0';


--
-- Name: COLUMN data_sources.network; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN data_sources.network IS 'Examples: EDN, BIGPOND, NEXUS';


--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE data_sources_data_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_sources_data_source_id_seq OWNER TO cxp;

--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE data_sources_data_source_id_seq OWNED BY data_sources.data_source_id;


--
-- Name: data_types; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE data_types (
    data_type_id integer NOT NULL,
    data_type_name character varying(100) NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE data_types OWNER TO cxp;

--
-- Name: data_types_data_type_id_seq_1; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE data_types_data_type_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_types_data_type_id_seq_1 OWNER TO cxp;

--
-- Name: data_types_data_type_id_seq_1; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE data_types_data_type_id_seq_1 OWNED BY data_types.data_type_id;


--
-- Name: datasets; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE datasets (
    dataset_id bigint NOT NULL,
    dataset_type character varying(10) NOT NULL,
    multi_recordset boolean,
    data_source_id bigint NOT NULL,
    security_classification_id integer,
    dataset_name character varying(100) NOT NULL,
    namespace character varying(100),
    description character varying,
    comments character varying,
    architecture_domain character varying(50),
    contact_person character varying(100),
    customer_data boolean,
    financial_banking_data boolean,
    id_and_service_history boolean,
    credit_card_data boolean,
    financial_reporting_data boolean,
    privacy_data boolean,
    regulatory_data boolean,
    nbn_confidential_data boolean,
    nbn_compliant boolean,
    ssu_ready character varying,
    ssu_remediation_method character varying,
    available_history_unit_of_time character varying(10),
    available_history_units smallint,
    history_data_size_gb smallint,
    refresh_data_size_gb smallint,
    compression_type character varying(10),
    column_delimiter character varying(10),
    header_row boolean,
    row_delimiter character varying(10),
    text_qualifier character varying(10),
    batch boolean,
    refresh_frequency_unit_of_time character varying(10),
    refresh_frequency_units smallint,
    time_of_day_data_available time without time zone,
    data_available_unit_of_time character varying(10),
    data_available_days_of_week character varying,
    data_latency_unit_of_time character varying(10),
    data_latency_units smallint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    footer_row boolean,
    file_type character varying(255)
);


ALTER TABLE datasets OWNER TO cxp;

--
-- Name: COLUMN datasets.dataset_type; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.dataset_type IS 'Values:
* File
* Database Table';


--
-- Name: COLUMN datasets.architecture_domain; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.architecture_domain IS 'Example: ENTERPRISE';


--
-- Name: COLUMN datasets.ssu_ready; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.ssu_ready IS 'Example: Combined but identifiable attributes';


--
-- Name: COLUMN datasets.ssu_remediation_method; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.ssu_remediation_method IS 'For sha1_siiam.v_tca_case filter on X_OWNERSHIP_CODE to lookup table for BU identfiier to split retail/wholesale. For set3_fact_assurance filter on BUS_UNIT i.e. W= Wholesale.';


--
-- Name: COLUMN datasets.available_history_unit_of_time; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.available_history_unit_of_time IS 'Example: days, months';


--
-- Name: COLUMN datasets.compression_type; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.compression_type IS 'Values:
* None
* zip
* gzip
* tar
* tar.gz
* 7z';


--
-- Name: COLUMN datasets.data_available_days_of_week; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN datasets.data_available_days_of_week IS 'Comma separated list. Sunday = 0.';


--
-- Name: datasets_dataset_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE datasets_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datasets_dataset_id_seq OWNER TO cxp;

--
-- Name: datasets_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE datasets_dataset_id_seq OWNED BY datasets.dataset_id;


--
-- Name: err_events; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE err_events (
    error_message character varying,
    skipped boolean,
    event_type_id integer,
    dataset_id bigint,
    source_filename character varying(100),
    value text,
    job_id bigint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    source_key character varying
);


ALTER TABLE err_events OWNER TO cxp;

--
-- Name: event_property_types_columns; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_property_types_columns (
    id integer NOT NULL,
    property_type_id integer NOT NULL,
    column_id bigint NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE event_property_types_columns OWNER TO cxp;

--
-- Name: event_property_types_columns_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE event_property_types_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_property_types_columns_id_seq OWNER TO cxp;

--
-- Name: event_property_types_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE event_property_types_columns_id_seq OWNED BY event_property_types_columns.id;


--
-- Name: event_type_relationship; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_type_relationship (
    source_event_type_id integer NOT NULL,
    target_event_type_id integer NOT NULL,
    event_type_reln_type_id integer NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE event_type_relationship OWNER TO cxp;

--
-- Name: event_type_reln_type; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_type_reln_type (
    event_type_reln_type_id integer NOT NULL,
    event_type_reln_type_name character varying NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE event_type_reln_type OWNER TO cxp;

--
-- Name: event_type_reln_type_event_type_reln_type_id_seq_1; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE event_type_reln_type_event_type_reln_type_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_type_reln_type_event_type_reln_type_id_seq_1 OWNER TO cxp;

--
-- Name: event_type_reln_type_event_type_reln_type_id_seq_1; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE event_type_reln_type_event_type_reln_type_id_seq_1 OWNED BY event_type_reln_type.event_type_reln_type_id;


--
-- Name: event_types_columns; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_types_columns (
    id integer NOT NULL,
    event_type_id integer NOT NULL,
    column_id bigint NOT NULL,
    role_type character(1) NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE event_types_columns OWNER TO cxp;

--
-- Name: COLUMN event_types_columns.role_type; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON COLUMN event_types_columns.role_type IS 'V - value, T - ts';


--
-- Name: event_types_cust_id_types; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_types_cust_id_types (
    event_type_id integer NOT NULL,
    customer_id_type_id integer NOT NULL,
    customer_id_expression text NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE event_types_cust_id_types OWNER TO cxp;

--
-- Name: event_types_datasets; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_types_datasets (
    id integer NOT NULL,
    event_type_id integer NOT NULL,
    dataset_id bigint NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE event_types_datasets OWNER TO cxp;

--
-- Name: event_types_datasets_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE event_types_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_datasets_id_seq OWNER TO cxp;

--
-- Name: event_types_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE event_types_datasets_id_seq OWNED BY event_types_datasets.id;


--
-- Name: event_types_records; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE event_types_records (
    id integer NOT NULL,
    event_type_id integer NOT NULL,
    dataset_id bigint NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    record_id bigint NOT NULL
);


ALTER TABLE event_types_records OWNER TO cxp;

--
-- Name: event_types_records_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE event_types_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_records_id_seq OWNER TO cxp;

--
-- Name: event_types_records_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE event_types_records_id_seq OWNED BY event_types_records.id;


--
-- Name: feature_types; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE feature_types (
    feature_type_id integer NOT NULL,
    security_classification_id integer,
    value_type_id integer,
    snapshot_ts timestamp without time zone NOT NULL,
    feature_name character varying(100) NOT NULL,
    column_name character varying(30) NOT NULL,
    description character varying,
    reference character varying(50),
    expression text,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE feature_types OWNER TO cxp;

--
-- Name: feature_types_feature_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE feature_types_feature_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feature_types_feature_type_id_seq OWNER TO cxp;

--
-- Name: feature_types_feature_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE feature_types_feature_type_id_seq OWNED BY feature_types.feature_type_id;


--
-- Name: form_schemas; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE form_schemas (
    form_schema_id integer NOT NULL,
    form_schema_name character varying(100) NOT NULL,
    description character varying,
    json_schema text NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE form_schemas OWNER TO cxp;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE form_schemas_form_schema_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE form_schemas_form_schema_id_seq OWNER TO cxp;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE form_schemas_form_schema_id_seq OWNED BY form_schemas.form_schema_id;


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hibernate_sequence OWNER TO cxp;

--
-- Name: id_mapping_rules_datasets; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE id_mapping_rules_datasets (
    id integer NOT NULL,
    customer_id_mapping_rule_id integer NOT NULL,
    dataset_id bigint NOT NULL,
    created_ts timestamp without time zone
);


ALTER TABLE id_mapping_rules_datasets OWNER TO cxp;

--
-- Name: id_mapping_rules_datasets_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE id_mapping_rules_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE id_mapping_rules_datasets_id_seq OWNER TO cxp;

--
-- Name: id_mapping_rules_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE id_mapping_rules_datasets_id_seq OWNED BY id_mapping_rules_datasets.id;


--
-- Name: key_values; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE key_values (
    key character varying(100) NOT NULL,
    value character varying,
    value_type character varying(50),
    created_ts timestamp without time zone
);


ALTER TABLE key_values OWNER TO cxp;

--
-- Name: natural_key; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE natural_key (
    dataset_id bigint NOT NULL,
    column_id bigint NOT NULL
);


ALTER TABLE natural_key OWNER TO cxp;

--
-- Name: queries; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE queries (
    query_id integer NOT NULL,
    columns character varying(255),
    created_ts timestamp without time zone,
    primary_table character varying(255),
    query character varying(8000),
    tables character varying(255),
    username character varying(255)
);


ALTER TABLE queries OWNER TO cxp;

--
-- Name: records; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE records (
    record_id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    record_name character varying(100) NOT NULL,
    prefix character varying(100) NOT NULL,
    description character varying,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE records OWNER TO cxp;

--
-- Name: records_record_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE records_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE records_record_id_seq OWNER TO cxp;

--
-- Name: records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE records_record_id_seq OWNED BY records.record_id;


--
-- Name: security_classifications; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE security_classifications (
    security_classification_id integer NOT NULL,
    security_classification_name character varying(50) NOT NULL,
    process_name character varying(50),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE security_classifications OWNER TO cxp;

--
-- Name: security_classifications_security_classification_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE security_classifications_security_classification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security_classifications_security_classification_id_seq OWNER TO cxp;

--
-- Name: security_classifications_security_classification_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE security_classifications_security_classification_id_seq OWNED BY security_classifications.security_classification_id;


--
-- Name: settings; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE settings (
    name character varying(255) NOT NULL,
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255),
    process_name character varying(255),
    value character varying(8000),
    description character varying
);


ALTER TABLE settings OWNER TO cxp;

--
-- Name: streams; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE streams (
    stream_id bigint NOT NULL,
    stream_name character varying(100) NOT NULL,
    namespace character varying(100),
    polling_directory character varying,
    filename_pattern character varying(100),
    prevent_duplicates boolean,
    job character varying(50),
    definition character varying,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE streams OWNER TO cxp;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE streams_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE streams_stream_id_seq OWNER TO cxp;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE streams_stream_id_seq OWNED BY streams.stream_id;


--
-- Name: transformations; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE transformations (
    transformation_id bigint NOT NULL,
    transformation_name character varying(100) NOT NULL,
    output_dataset_id bigint,
    routine text,
    reference character varying,
    language character varying(50),
    lead_committer character varying(100),
    contact_email character varying(100),
    repo character varying,
    commit_hash character varying,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE transformations OWNER TO cxp;

--
-- Name: transformations_transformation_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE transformations_transformation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transformations_transformation_id_seq OWNER TO cxp;

--
-- Name: transformations_transformation_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE transformations_transformation_id_seq OWNED BY transformations.transformation_id;


--
-- Name: transformed_sets; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE transformed_sets (
    transformation_id bigint NOT NULL,
    dataset_id bigint NOT NULL
);


ALTER TABLE transformed_sets OWNER TO cxp;

--
-- Name: value_types; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE value_types (
    value_type_id integer NOT NULL,
    value_type_name character varying(100) NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE value_types OWNER TO cxp;

--
-- Name: TABLE value_types; Type: COMMENT; Schema: meta; Owner: cxp
--

COMMENT ON TABLE value_types IS 'Examples:
* character
* categorical
* numeric
* integer
* boolean';


--
-- Name: value_types_value_type_id_seq_1_3_1; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE value_types_value_type_id_seq_1_3_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE value_types_value_type_id_seq_1_3_1 OWNER TO cxp;

--
-- Name: value_types_value_type_id_seq_1_3_1; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE value_types_value_type_id_seq_1_3_1 OWNED BY value_types.value_type_id;


--
-- Name: xdjobs; Type: TABLE; Schema: meta; Owner: cxp; Tablespace: 
--

CREATE TABLE xdjobs (
    job_id integer NOT NULL,
    job_name character varying(100) NOT NULL,
    jar_location character varying,
    make_unique boolean,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE xdjobs OWNER TO cxp;

--
-- Name: xdjobs_job_id_seq; Type: SEQUENCE; Schema: meta; Owner: cxp
--

CREATE SEQUENCE xdjobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE xdjobs_job_id_seq OWNER TO cxp;

--
-- Name: xdjobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: cxp
--

ALTER SEQUENCE xdjobs_job_id_seq OWNED BY xdjobs.job_id;


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY cust_property_types_columns ALTER COLUMN id SET DEFAULT nextval('cust_property_types_columns_id_seq'::regclass);


--
-- Name: customer_id_mapping_rule_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping_rules ALTER COLUMN customer_id_mapping_rule_id SET DEFAULT nextval('customer_id_mapping_rules_id_seq'::regclass);


--
-- Name: property_type_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_property_types ALTER COLUMN property_type_id SET DEFAULT nextval('customer_property_types_property_type_id_seq_1'::regclass);


--
-- Name: customer_surrogate_key; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customers ALTER COLUMN customer_surrogate_key SET DEFAULT nextval('customers_customer_surrogate_key_seq'::regclass);


--
-- Name: column_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns ALTER COLUMN column_id SET DEFAULT nextval('data_columns_column_id_seq'::regclass);


--
-- Name: data_source_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_sources ALTER COLUMN data_source_id SET DEFAULT nextval('data_sources_data_source_id_seq'::regclass);


--
-- Name: data_type_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_types ALTER COLUMN data_type_id SET DEFAULT nextval('data_types_data_type_id_seq_1'::regclass);


--
-- Name: dataset_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY datasets ALTER COLUMN dataset_id SET DEFAULT nextval('datasets_dataset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_property_types_columns ALTER COLUMN id SET DEFAULT nextval('event_property_types_columns_id_seq'::regclass);


--
-- Name: event_type_reln_type_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_type_reln_type ALTER COLUMN event_type_reln_type_id SET DEFAULT nextval('event_type_reln_type_event_type_reln_type_id_seq_1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_datasets ALTER COLUMN id SET DEFAULT nextval('event_types_datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_records ALTER COLUMN id SET DEFAULT nextval('event_types_records_id_seq'::regclass);


--
-- Name: feature_type_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY feature_types ALTER COLUMN feature_type_id SET DEFAULT nextval('feature_types_feature_type_id_seq'::regclass);


--
-- Name: form_schema_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY form_schemas ALTER COLUMN form_schema_id SET DEFAULT nextval('form_schemas_form_schema_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY id_mapping_rules_datasets ALTER COLUMN id SET DEFAULT nextval('id_mapping_rules_datasets_id_seq'::regclass);


--
-- Name: record_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY records ALTER COLUMN record_id SET DEFAULT nextval('records_record_id_seq'::regclass);


--
-- Name: security_classification_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY security_classifications ALTER COLUMN security_classification_id SET DEFAULT nextval('security_classifications_security_classification_id_seq'::regclass);


--
-- Name: stream_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY streams ALTER COLUMN stream_id SET DEFAULT nextval('streams_stream_id_seq'::regclass);


--
-- Name: transformation_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY transformations ALTER COLUMN transformation_id SET DEFAULT nextval('transformations_transformation_id_seq'::regclass);


--
-- Name: value_type_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY value_types ALTER COLUMN value_type_id SET DEFAULT nextval('value_types_value_type_id_seq_1_3_1'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY xdjobs ALTER COLUMN job_id SET DEFAULT nextval('xdjobs_job_id_seq'::regclass);


--
-- Name: column_profile_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY column_profile
    ADD CONSTRAINT column_profile_pk PRIMARY KEY (column_id, profile_ts);


--
-- Name: cust_property_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT cust_property_types_columns_pk PRIMARY KEY (id);


--
-- Name: customer_id_mapping_rules_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_mapping_rules_pk PRIMARY KEY (customer_id_mapping_rule_id);


--
-- Name: customer_ids_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customer_ids_pk PRIMARY KEY (customer_surrogate_key, customer_id_type_id);


--
-- Name: customer_properties_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customer_properties_pk PRIMARY KEY (customer_surrogate_key, property_type_id);


--
-- Name: customer_property_types_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT customer_property_types_pk PRIMARY KEY (property_type_id);


--
-- Name: customers_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (customer_surrogate_key);


--
-- Name: data_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT data_columns_pk PRIMARY KEY (column_id);


--
-- Name: data_sources_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY data_sources
    ADD CONSTRAINT data_sources_pk PRIMARY KEY (data_source_id);


--
-- Name: data_types_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY data_types
    ADD CONSTRAINT data_types_pk PRIMARY KEY (data_type_id);


--
-- Name: datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pk PRIMARY KEY (dataset_id);


--
-- Name: event_property_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT event_property_types_columns_pk PRIMARY KEY (id);


--
-- Name: event_type_relationship_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_type_relationship_pk PRIMARY KEY (source_event_type_id, target_event_type_id, event_type_reln_type_id);


--
-- Name: event_type_reln_type_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_type_reln_type
    ADD CONSTRAINT event_type_reln_type_pk PRIMARY KEY (event_type_reln_type_id);


--
-- Name: event_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT event_types_columns_pk PRIMARY KEY (id);


--
-- Name: event_types_cust_id_types_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT event_types_cust_id_types_pk PRIMARY KEY (event_type_id, customer_id_type_id);


--
-- Name: event_types_datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT event_types_datasets_pk PRIMARY KEY (id);


--
-- Name: event_types_records_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT event_types_records_pk PRIMARY KEY (id);


--
-- Name: feature_types_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT feature_types_pk PRIMARY KEY (feature_type_id);


--
-- Name: form_schemas_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY form_schemas
    ADD CONSTRAINT form_schemas_pk PRIMARY KEY (form_schema_id);


--
-- Name: id_mapping_rules_datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT id_mapping_rules_datasets_pk PRIMARY KEY (id);


--
-- Name: key_values_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY key_values
    ADD CONSTRAINT key_values_pk PRIMARY KEY (key);


--
-- Name: natural_key_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY natural_key
    ADD CONSTRAINT natural_key_pk PRIMARY KEY (dataset_id, column_id);


--
-- Name: queries_pkey; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (query_id);


--
-- Name: records_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY records
    ADD CONSTRAINT records_pk PRIMARY KEY (record_id);


--
-- Name: security_classifications_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY security_classifications
    ADD CONSTRAINT security_classifications_pk PRIMARY KEY (security_classification_id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (name);


--
-- Name: streams_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY streams
    ADD CONSTRAINT streams_pk PRIMARY KEY (stream_id);


--
-- Name: transformations_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY transformations
    ADD CONSTRAINT transformations_pk PRIMARY KEY (transformation_id);


--
-- Name: transformed_sets_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY transformed_sets
    ADD CONSTRAINT transformed_sets_pk PRIMARY KEY (transformation_id, dataset_id);


--
-- Name: value_types_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY value_types
    ADD CONSTRAINT value_types_pk PRIMARY KEY (value_type_id);


--
-- Name: xdjobs_pk; Type: CONSTRAINT; Schema: meta; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY xdjobs
    ADD CONSTRAINT xdjobs_pk PRIMARY KEY (job_id);


--
-- Name: columns_column_profile_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY column_profile
    ADD CONSTRAINT columns_column_profile_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_cust_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT columns_cust_property_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_event_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT columns_event_property_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_event_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT columns_event_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: customer_id_types_customer_id_mapping_rules_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk FOREIGN KEY (customer_id_type_id_1) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_mapping_rules_fk1; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk1 FOREIGN KEY (customer_id_type_id_2) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_ids_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customer_id_types_customer_ids_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customers_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customer_id_types_customers_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_data_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT customer_id_types_data_columns_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_events_types_cust_id_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT customer_id_types_events_types_cust_id_types_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_property_types_cust_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT customer_property_types_cust_property_types_columns_fk FOREIGN KEY (property_type_id) REFERENCES customer_property_types(property_type_id);


--
-- Name: customer_property_types_customer_properties_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customer_property_types_customer_properties_fk FOREIGN KEY (property_type_id) REFERENCES customer_property_types(property_type_id);


--
-- Name: customers_customer_ids_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customers_customer_ids_fk FOREIGN KEY (customer_surrogate_key) REFERENCES customers(customer_surrogate_key);


--
-- Name: customers_customer_properties_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customers_customer_properties_fk FOREIGN KEY (customer_surrogate_key) REFERENCES customers(customer_surrogate_key);


--
-- Name: data_source_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT data_source_datasets_fk FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id);


--
-- Name: data_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT data_types_columns_fk FOREIGN KEY (data_type_id) REFERENCES data_types(data_type_id);


--
-- Name: datasets_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT datasets_columns_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_event_types_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT datasets_event_types_datasets_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_event_types_records_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT datasets_event_types_records_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_record_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY records
    ADD CONSTRAINT datasets_record_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: event_property_types_event_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT event_property_types_event_property_types_columns_fk FOREIGN KEY (property_type_id) REFERENCES cxp.event_property_types(property_type_id);


--
-- Name: event_type_reln_type_event_type_relationship_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_type_reln_type_event_type_relationship_fk FOREIGN KEY (event_type_reln_type_id) REFERENCES event_type_reln_type(event_type_reln_type_id);


--
-- Name: event_types_event_type_relationship_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_types_event_type_relationship_fk FOREIGN KEY (source_event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_type_relationship_fk1; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_types_event_type_relationship_fk1 FOREIGN KEY (target_event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT event_types_event_types_columns_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT event_types_event_types_datasets_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_records_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT event_types_event_types_records_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_events_types_cust_id_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT event_types_events_types_cust_id_types_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: fk_2qfky6vn731w1rnue87wi7y9a; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT fk_2qfky6vn731w1rnue87wi7y9a FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: fk_2rfnqh233dbj06iihuk2x73pq; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT fk_2rfnqh233dbj06iihuk2x73pq FOREIGN KEY (record_id) REFERENCES records(record_id);


--
-- Name: fk_dhmesj1d60poxvx4tptgh5wtm; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT fk_dhmesj1d60poxvx4tptgh5wtm FOREIGN KEY (customer_id_mapping_rule_id) REFERENCES customer_id_mapping_rules(customer_id_mapping_rule_id);


--
-- Name: record_data_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT record_data_columns_fk FOREIGN KEY (record_id) REFERENCES records(record_id);


--
-- Name: security_classification_customer_property_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT security_classification_customer_property_types_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: security_classification_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT security_classification_datasets_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: security_classification_feature_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT security_classification_feature_types_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: value_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT value_types_columns_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: value_types_customer_property_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT value_types_customer_property_types_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: value_types_feature_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: cxp
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT value_types_feature_types_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: meta; Type: ACL; Schema: -; Owner: cxp
--

REVOKE ALL ON SCHEMA meta FROM PUBLIC;
REVOKE ALL ON SCHEMA meta FROM cxp;
GRANT ALL ON SCHEMA meta TO cxp;


--
-- Name: err_events; Type: ACL; Schema: meta; Owner: cxp
--

REVOKE ALL ON TABLE err_events FROM PUBLIC;
REVOKE ALL ON TABLE err_events FROM cxp;
GRANT ALL ON TABLE err_events TO cxp;


--
-- Name: key_values; Type: ACL; Schema: meta; Owner: cxp
--

REVOKE ALL ON TABLE key_values FROM PUBLIC;
REVOKE ALL ON TABLE key_values FROM cxp;
GRANT ALL ON TABLE key_values TO cxp;


--
-- Name: natural_key; Type: ACL; Schema: meta; Owner: cxp
--

REVOKE ALL ON TABLE natural_key FROM PUBLIC;
REVOKE ALL ON TABLE natural_key FROM cxp;
GRANT ALL ON TABLE natural_key TO cxp;


--
-- Name: streams; Type: ACL; Schema: meta; Owner: cxp
--

REVOKE ALL ON TABLE streams FROM PUBLIC;
REVOKE ALL ON TABLE streams FROM cxp;
GRANT ALL ON TABLE streams TO cxp;


--
-- Name: xdjobs; Type: ACL; Schema: meta; Owner: cxp
--

REVOKE ALL ON TABLE xdjobs FROM PUBLIC;
REVOKE ALL ON TABLE xdjobs FROM cxp;
GRANT ALL ON TABLE xdjobs TO cxp;


--
-- cxpQL database dump complete
--

