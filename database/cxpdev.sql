--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: cxp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA cxp;


ALTER SCHEMA cxp OWNER TO postgres;

--
-- Name: gcfr_meta; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gcfr_meta;


ALTER SCHEMA gcfr_meta OWNER TO postgres;

--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA meta;


ALTER SCHEMA meta OWNER TO postgres;

--
-- Name: metaform; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA metaform;


ALTER SCHEMA metaform OWNER TO postgres;

--
-- Name: profiler; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA profiler;


ALTER SCHEMA profiler OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = cxp, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customer_id_mapping; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE customer_id_mapping (
    id bigint NOT NULL,
    customer_id_type_id_1 smallint NOT NULL,
    customer_id_1 character varying NOT NULL,
    customer_id_type_id_2 smallint NOT NULL,
    customer_id_2 character varying NOT NULL,
    confidence numeric,
    start_ts timestamp without time zone,
    end_ts timestamp without time zone,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255),
    customer_id1 character varying(255),
    customer_id2 character varying(255)
);


ALTER TABLE customer_id_mapping OWNER TO postgres;

--
-- Name: customer_id_mapping_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE customer_id_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_mapping_id_seq OWNER TO postgres;

--
-- Name: customer_id_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE customer_id_mapping_id_seq OWNED BY customer_id_mapping.id;


--
-- Name: customer_id_types; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE customer_id_types (
    customer_id_type_id integer NOT NULL,
    customer_id_type_name character varying(50) NOT NULL,
    description character varying,
    composite boolean,
    composition_rule text,
    parent_id smallint,
    data_type_id integer,
    value_type_id integer,
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    process_name character varying(255),
    marked_for_deletion boolean
);


ALTER TABLE customer_id_types OWNER TO postgres;

--
-- Name: customer_id_types_cust_id_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE customer_id_types_cust_id_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_types_cust_id_type_id_seq OWNER TO postgres;

--
-- Name: customer_id_types_cust_id_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE customer_id_types_cust_id_type_id_seq OWNED BY customer_id_types.customer_id_type_id;


--
-- Name: event_properties; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE event_properties (
    customer_id_type_id smallint NOT NULL,
    customer_id character varying(100) NOT NULL,
    event_type_id integer NOT NULL,
    ts timestamp without time zone NOT NULL,
    event_version integer NOT NULL,
    property_type_id integer NOT NULL,
    version integer NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE event_properties OWNER TO postgres;

--
-- Name: COLUMN event_properties.customer_id; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN event_properties.customer_id IS 'Natural customer id in dataset.';


--
-- Name: COLUMN event_properties.ts; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN event_properties.ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';


--
-- Name: event_property_types; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE event_property_types (
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
    modified_by character varying(50),
    event_type_id integer
);


ALTER TABLE event_property_types OWNER TO postgres;

--
-- Name: event_property_types_property_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE event_property_types_property_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_property_types_property_type_id_seq OWNER TO postgres;

--
-- Name: event_property_types_property_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE event_property_types_property_type_id_seq OWNED BY event_property_types.property_type_id;


--
-- Name: event_property_types_temp; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE event_property_types_temp (
    property_type_id integer NOT NULL,
    original_property_type_id integer,
    event_type_id integer,
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


ALTER TABLE event_property_types_temp OWNER TO postgres;

--
-- Name: event_property_types_temp_property_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE event_property_types_temp_property_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_property_types_temp_property_type_id_seq OWNER TO postgres;

--
-- Name: event_property_types_temp_property_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE event_property_types_temp_property_type_id_seq OWNED BY event_property_types_temp.property_type_id;


--
-- Name: event_types; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE event_types (
    event_type_id integer NOT NULL,
    namespace character varying,
    event_type character varying NOT NULL,
    event_subtype character varying,
    description character varying,
    value_type_id integer,
    customer_id_type_id1 smallint,
    customer_id_expression1 text,
    customer_id_type_id2 smallint,
    customer_id_expression2 text,
    filter_expression text,
    value_expression text,
    ts_expression text,
    event_value_desc character varying,
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    process_name character varying(255),
    datetime_format character varying(255),
    timezone character varying(255),
    marked_for_deletion boolean,
    nested_document_expression text
);


ALTER TABLE event_types OWNER TO postgres;

--
-- Name: COLUMN event_types.event_type; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN event_types.event_type IS 'Should be intuitive to a human.';


--
-- Name: COLUMN event_types.event_value_desc; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN event_types.event_value_desc IS 'To support Dimitri''s work. Describes what the event value (comment) represents.';


--
-- Name: event_types_event_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE event_types_event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_event_type_id_seq OWNER TO postgres;

--
-- Name: event_types_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE event_types_event_type_id_seq OWNED BY event_types.event_type_id;


--
-- Name: events; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE events (
    customer_id_type_id smallint NOT NULL,
    customer_id character varying(100) NOT NULL,
    event_type_id integer NOT NULL,
    ts timestamp without time zone NOT NULL,
    event_version integer NOT NULL,
    value text,
    job_id bigint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    event_property text,
    source_key text
);


ALTER TABLE events OWNER TO postgres;

--
-- Name: COLUMN events.customer_id; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN events.customer_id IS 'Natural customer id in dataset.';


--
-- Name: COLUMN events.ts; Type: COMMENT; Schema: cxp; Owner: postgres
--

COMMENT ON COLUMN events.ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';


--
-- Name: events_test; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE events_test (
    customer_id_type_id smallint,
    customer_id character varying(100),
    event_type_id integer,
    ts timestamp without time zone,
    event_version integer,
    value text,
    job_id bigint,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE events_test OWNER TO postgres;

--
-- Name: features; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE features (
    entity_id character varying NOT NULL,
    feature_type_id integer NOT NULL,
    value character varying NOT NULL,
    eval_ts timestamp without time zone NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE features OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE jobs (
    job_id bigint NOT NULL,
    dataset_id bigint,
    process_name character varying(100),
    job_start_ts timestamp without time zone NOT NULL,
    job_end_ts timestamp without time zone,
    job_status character varying(50),
    exit_message character varying,
    modified_ts timestamp without time zone,
    records_processed bigint,
    events_created bigint,
    source_filename character varying,
    errors_logged bigint,
    records_skipped bigint
);


ALTER TABLE jobs OWNER TO postgres;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_job_id_seq OWNER TO postgres;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE jobs_job_id_seq OWNED BY jobs.job_id;


--
-- Name: jobs_test; Type: TABLE; Schema: cxp; Owner: postgres; Tablespace:
--

CREATE TABLE jobs_test (
    job_id bigint NOT NULL,
    dataset_id bigint,
    source_filename character varying,
    process_name character varying(100),
    job_start_ts timestamp without time zone NOT NULL,
    job_end_ts timestamp without time zone,
    job_status character varying(50),
    exit_message character varying,
    records_processed bigint,
    records_skipped bigint,
    events_created bigint,
    errors_logged bigint
);


ALTER TABLE jobs_test OWNER TO postgres;

--
-- Name: jobs_test_job_id_seq; Type: SEQUENCE; Schema: cxp; Owner: postgres
--

CREATE SEQUENCE jobs_test_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_test_job_id_seq OWNER TO postgres;

--
-- Name: jobs_test_job_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: postgres
--

ALTER SEQUENCE jobs_test_job_id_seq OWNED BY jobs_test.job_id;


SET search_path = gcfr_meta, pg_catalog;

--
-- Name: bkey_key_sets; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE bkey_key_sets (
    key_set_id integer NOT NULL,
    key_set_name character varying(100) NOT NULL,
    key_set_code character varying(10) NOT NULL,
    key_table_name character varying(100) NOT NULL,
    key_table_db_name character varying(100) NOT NULL
);


ALTER TABLE bkey_key_sets OWNER TO postgres;

--
-- Name: bkey_key_sets_key_set_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE bkey_key_sets_key_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bkey_key_sets_key_set_id_seq OWNER TO postgres;

--
-- Name: bkey_key_sets_key_set_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE bkey_key_sets_key_set_id_seq OWNED BY bkey_key_sets.key_set_id;


--
-- Name: character_sets; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE character_sets (
    character_set_id integer NOT NULL,
    character_set_name character varying(10) NOT NULL,
    description character varying(255),
    min_character_length integer,
    max_character_length integer
);


ALTER TABLE character_sets OWNER TO postgres;

--
-- Name: character_sets_character_set_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE character_sets_character_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE character_sets_character_set_id_seq OWNER TO postgres;

--
-- Name: character_sets_character_set_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE character_sets_character_set_id_seq OWNED BY character_sets.character_set_id;


--
-- Name: columns_column_id_seq_1; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE columns_column_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE columns_column_id_seq_1 OWNER TO postgres;

--
-- Name: columns; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE columns (
    column_id integer DEFAULT nextval('columns_column_id_seq_1'::regclass) NOT NULL,
    column_name character varying(30) NOT NULL,
    table_id integer NOT NULL
);


ALTER TABLE columns OWNER TO postgres;

--
-- Name: param_groups; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE param_groups (
    param_group_id integer NOT NULL,
    param_group_name character varying(100) NOT NULL,
    description character varying(255)
);


ALTER TABLE param_groups OWNER TO postgres;

--
-- Name: param_groups_param_group_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE param_groups_param_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE param_groups_param_group_id_seq OWNER TO postgres;

--
-- Name: param_groups_param_group_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE param_groups_param_group_id_seq OWNED BY param_groups.param_group_id;


--
-- Name: params; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE params (
    param_id integer NOT NULL,
    process_type_id integer NOT NULL,
    param_group_id integer NOT NULL,
    param_name character varying(100) NOT NULL,
    description character varying(255),
    param_value character varying(100) NOT NULL,
    param_cast character varying(50) NOT NULL,
    param_order integer
);


ALTER TABLE params OWNER TO postgres;

--
-- Name: params_param_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE params_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE params_param_id_seq OWNER TO postgres;

--
-- Name: params_param_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE params_param_id_seq OWNED BY params.param_id;


--
-- Name: process_types; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE process_types (
    process_type_id integer NOT NULL,
    process_type_code character varying(10) NOT NULL,
    process_type_name character varying(100) NOT NULL,
    description character varying(255)
);


ALTER TABLE process_types OWNER TO postgres;

--
-- Name: process_types_process_type_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE process_types_process_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE process_types_process_type_id_seq OWNER TO postgres;

--
-- Name: process_types_process_type_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE process_types_process_type_id_seq OWNED BY process_types.process_type_id;


--
-- Name: settings; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE settings (
    name character varying(50) NOT NULL,
    description character varying,
    value character varying(255)
);


ALTER TABLE settings OWNER TO postgres;

--
-- Name: source_column_mapping; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE source_column_mapping (
    transform_mapping_id integer NOT NULL,
    column_id integer NOT NULL
);


ALTER TABLE source_column_mapping OWNER TO postgres;

--
-- Name: source_systems; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE source_systems (
    source_system_id integer NOT NULL,
    source_system_name character varying(100) NOT NULL,
    ctl_id integer NOT NULL,
    path_name character varying(255),
    description character varying(255)
);


ALTER TABLE source_systems OWNER TO postgres;

--
-- Name: source_systems_source_system_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE source_systems_source_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source_systems_source_system_id_seq OWNER TO postgres;

--
-- Name: source_systems_source_system_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE source_systems_source_system_id_seq OWNED BY source_systems.source_system_id;


--
-- Name: streams; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE streams (
    stream_id integer NOT NULL,
    stream_name character varying(100) NOT NULL,
    stream_key integer NOT NULL,
    cycle_freq integer NOT NULL,
    business_date date NOT NULL
);


ALTER TABLE streams OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE streams_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE streams_stream_id_seq OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE streams_stream_id_seq OWNED BY streams.stream_id;


--
-- Name: subject_areas; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE subject_areas (
    subject_area_id integer NOT NULL,
    subject_area_name character varying(50) NOT NULL
);


ALTER TABLE subject_areas OWNER TO postgres;

--
-- Name: subject_areas_subject_area_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE subject_areas_subject_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subject_areas_subject_area_id_seq OWNER TO postgres;

--
-- Name: subject_areas_subject_area_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE subject_areas_subject_area_id_seq OWNED BY subject_areas.subject_area_id;


--
-- Name: tables; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE tables (
    table_id integer NOT NULL,
    table_name character varying(30) NOT NULL
);


ALTER TABLE tables OWNER TO postgres;

--
-- Name: tables_table_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE tables_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tables_table_id_seq OWNER TO postgres;

--
-- Name: tables_table_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE tables_table_id_seq OWNED BY tables.table_id;


--
-- Name: transform_mapping; Type: TABLE; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

CREATE TABLE transform_mapping (
    transform_mapping_id integer NOT NULL,
    subject_area_id integer NOT NULL,
    mapping_sequence integer,
    target_column_id integer NOT NULL,
    source_system_id integer NOT NULL,
    transform_type character varying(50) NOT NULL,
    pseudocode character varying(255),
    code character varying(255),
    comments character varying(4000) NOT NULL
);


ALTER TABLE transform_mapping OWNER TO postgres;

--
-- Name: transform_mapping_transform_mapping_id_seq; Type: SEQUENCE; Schema: gcfr_meta; Owner: postgres
--

CREATE SEQUENCE transform_mapping_transform_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transform_mapping_transform_mapping_id_seq OWNER TO postgres;

--
-- Name: transform_mapping_transform_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: gcfr_meta; Owner: postgres
--

ALTER SEQUENCE transform_mapping_transform_mapping_id_seq OWNED BY transform_mapping.transform_mapping_id;


SET search_path = meta, pg_catalog;

--
-- Name: analysis_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE analysis_types (
    analysis_type_id integer NOT NULL,
    analysis_type_name character varying(100) NOT NULL
);


ALTER TABLE analysis_types OWNER TO postgres;

--
-- Name: analysis_types_analysis_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE analysis_types_analysis_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analysis_types_analysis_type_id_seq OWNER TO postgres;

--
-- Name: analysis_types_analysis_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE analysis_types_analysis_type_id_seq OWNED BY analysis_types.analysis_type_id;


--
-- Name: analytical_model_packages; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE analytical_model_packages (
    package_id integer NOT NULL,
    package_name character varying(100) NOT NULL,
    description character varying(8000),
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    version character varying(100)
);


ALTER TABLE analytical_model_packages OWNER TO postgres;

--
-- Name: analytical_model_packages_package_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE analytical_model_packages_package_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytical_model_packages_package_id_seq OWNER TO postgres;

--
-- Name: analytical_model_packages_package_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE analytical_model_packages_package_id_seq OWNED BY analytical_model_packages.package_id;


--
-- Name: analytical_models; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE analytical_models (
    model_id integer NOT NULL,
    model_name character varying(100) NOT NULL,
    version character varying(100),
    committer character varying(100),
    contact_person character varying(100),
    description character varying(8000),
    ensemble boolean DEFAULT false NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE analytical_models OWNER TO postgres;

--
-- Name: analytical_models_model_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE analytical_models_model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytical_models_model_id_seq OWNER TO postgres;

--
-- Name: analytical_models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE analytical_models_model_id_seq OWNED BY analytical_models.model_id;


--
-- Name: column_profile; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE column_profile OWNER TO postgres;

--
-- Name: column_tags; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE column_tags (
    column_id bigint NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE column_tags OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE comments (
    comment_id integer NOT NULL,
    comment character varying(255) NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    column_id bigint NOT NULL
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_comment_id_seq OWNER TO postgres;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE comments_comment_id_seq OWNED BY comments.comment_id;


--
-- Name: cust_property_types_columns; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE cust_property_types_columns OWNER TO postgres;

--
-- Name: cust_property_types_columns_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE cust_property_types_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cust_property_types_columns_id_seq OWNER TO postgres;

--
-- Name: cust_property_types_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE cust_property_types_columns_id_seq OWNED BY cust_property_types_columns.id;


--
-- Name: customer_id_mapping_rules; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE customer_id_mapping_rules (
    customer_id_mapping_rule_id integer NOT NULL,
    customer_id_mapping_rule_name character varying(100) NOT NULL,
    customer_id_type_id_1 smallint NOT NULL,
    customer_id_type_id_2 smallint NOT NULL,
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


ALTER TABLE customer_id_mapping_rules OWNER TO postgres;

--
-- Name: customer_id_mapping_rules_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE customer_id_mapping_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_mapping_rules_id_seq OWNER TO postgres;

--
-- Name: customer_id_mapping_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE customer_id_mapping_rules_id_seq OWNED BY customer_id_mapping_rules.customer_id_mapping_rule_id;


--
-- Name: customer_ids; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE customer_ids (
    customer_surrogate_key integer NOT NULL,
    customer_id_type_id smallint NOT NULL,
    customer_id character varying NOT NULL,
    confidence numeric,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE customer_ids OWNER TO postgres;

--
-- Name: customer_properties; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE customer_properties (
    customer_surrogate_key integer NOT NULL,
    property_type_id integer NOT NULL,
    value character varying NOT NULL,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE customer_properties OWNER TO postgres;

--
-- Name: customer_property_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE customer_property_types OWNER TO postgres;

--
-- Name: customer_property_types_property_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE customer_property_types_property_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_property_types_property_type_id_seq OWNER TO postgres;

--
-- Name: customer_property_types_property_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE customer_property_types_property_type_id_seq OWNED BY customer_property_types.property_type_id;


--
-- Name: customers; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE customers (
    customer_surrogate_key integer NOT NULL,
    customer_id_type_id smallint NOT NULL,
    customer_id character varying(100) NOT NULL,
    value character varying,
    version integer,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(255),
    modified_ts timestamp without time zone,
    modified_by character varying(255)
);


ALTER TABLE customers OWNER TO postgres;

--
-- Name: customers_customer_surrogate_key_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE customers_customer_surrogate_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_customer_surrogate_key_seq OWNER TO postgres;

--
-- Name: customers_customer_surrogate_key_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE customers_customer_surrogate_key_seq OWNED BY customers.customer_surrogate_key;


--
-- Name: data_column_comments; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE data_column_comments (
    column_id bigint NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE data_column_comments OWNER TO postgres;

--
-- Name: data_columns; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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
    customer_id_type_id smallint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    original_data_type_id integer,
    analysis_status character varying(50)
);


ALTER TABLE data_columns OWNER TO postgres;

--
-- Name: COLUMN data_columns.nullable_type; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN data_columns.nullable_type IS 'Values:
* COLUMN_NO_NULLS
* COLUMN_NULLABLE
* COLUMN_NULLABLE_UNKNOWN';


--
-- Name: data_columns_column_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE data_columns_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_columns_column_id_seq OWNER TO postgres;

--
-- Name: data_columns_column_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE data_columns_column_id_seq OWNED BY data_columns.column_id;


--
-- Name: data_sources; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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
    schema_name character varying(255),
    username character varying(100),
    password character varying(100),
    server_type character varying(100),
    server_version character varying(50),
    analysis_status character varying(50)
);


ALTER TABLE data_sources OWNER TO postgres;

--
-- Name: COLUMN data_sources.data_source_type; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN data_sources.data_source_type IS 'Examples: Database, File, API';


--
-- Name: COLUMN data_sources.data_source_name; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN data_sources.data_source_name IS 'Example: SHARP-EDGE 1.0';


--
-- Name: COLUMN data_sources.network; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN data_sources.network IS 'Examples: EDN, BIGPOND, NEXUS';


--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE data_sources_data_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_sources_data_source_id_seq OWNER TO postgres;

--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE data_sources_data_source_id_seq OWNED BY data_sources.data_source_id;


--
-- Name: data_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE data_types OWNER TO postgres;

--
-- Name: data_types_data_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE data_types_data_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_types_data_type_id_seq OWNER TO postgres;

--
-- Name: data_types_data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE data_types_data_type_id_seq OWNED BY data_types.data_type_id;


--
-- Name: datasets; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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
    file_type character varying(255),
    analysis_status character varying(50)
);


ALTER TABLE datasets OWNER TO postgres;

--
-- Name: COLUMN datasets.dataset_type; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.dataset_type IS 'Values:
* File
* Database Table';


--
-- Name: COLUMN datasets.architecture_domain; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.architecture_domain IS 'Example: ENTERPRISE';


--
-- Name: COLUMN datasets.ssu_ready; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.ssu_ready IS 'Example: Combined but identifiable attributes';


--
-- Name: COLUMN datasets.ssu_remediation_method; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.ssu_remediation_method IS 'For sha1_siiam.v_tca_case filter on X_OWNERSHIP_CODE to lookup table for BU identfiier to split retail/wholesale. For set3_fact_assurance filter on BUS_UNIT i.e. W= Wholesale.';


--
-- Name: COLUMN datasets.available_history_unit_of_time; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.available_history_unit_of_time IS 'Example: days, months';


--
-- Name: COLUMN datasets.compression_type; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.compression_type IS 'Values:
* None
* zip
* gzip
* tar
* tar.gz
* 7z';


--
-- Name: COLUMN datasets.data_available_days_of_week; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN datasets.data_available_days_of_week IS 'Comma separated list. Sunday = 0.';


--
-- Name: datasets_dataset_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE datasets_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datasets_dataset_id_seq OWNER TO postgres;

--
-- Name: datasets_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE datasets_dataset_id_seq OWNED BY datasets.dataset_id;


--
-- Name: err_events; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE err_events OWNER TO postgres;

--
-- Name: event_property_types_columns; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_property_types_columns OWNER TO postgres;

--
-- Name: event_property_types_columns_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE event_property_types_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_property_types_columns_id_seq OWNER TO postgres;

--
-- Name: event_property_types_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE event_property_types_columns_id_seq OWNED BY event_property_types_columns.id;


--
-- Name: event_type_relationship; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_type_relationship OWNER TO postgres;

--
-- Name: event_type_reln_type; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_type_reln_type OWNER TO postgres;

--
-- Name: event_type_reln_type_event_type_reln_type_id_seq_1; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE event_type_reln_type_event_type_reln_type_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_type_reln_type_event_type_reln_type_id_seq_1 OWNER TO postgres;

--
-- Name: event_type_reln_type_event_type_reln_type_id_seq_1; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE event_type_reln_type_event_type_reln_type_id_seq_1 OWNED BY event_type_reln_type.event_type_reln_type_id;


--
-- Name: event_types_columns; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_types_columns OWNER TO postgres;

--
-- Name: COLUMN event_types_columns.role_type; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON COLUMN event_types_columns.role_type IS 'V - value, T - ts';


--
-- Name: event_types_cust_id_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE event_types_cust_id_types (
    event_type_id integer NOT NULL,
    customer_id_type_id smallint NOT NULL,
    customer_id_expression text NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE event_types_cust_id_types OWNER TO postgres;

--
-- Name: event_types_datasets; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_types_datasets OWNER TO postgres;

--
-- Name: event_types_datasets_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE event_types_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_datasets_id_seq OWNER TO postgres;

--
-- Name: event_types_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE event_types_datasets_id_seq OWNED BY event_types_datasets.id;


--
-- Name: event_types_records; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE event_types_records OWNER TO postgres;

--
-- Name: event_types_records_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE event_types_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_records_id_seq OWNER TO postgres;

--
-- Name: event_types_records_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE event_types_records_id_seq OWNED BY event_types_records.id;


--
-- Name: feature_families; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_families (
    feature_family_id integer NOT NULL,
    feature_family_name character varying(100) NOT NULL,
    description character varying,
    wide_table_name character varying(100) NOT NULL,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE feature_families OWNER TO postgres;

--
-- Name: feature_families_feature_family_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE feature_families_feature_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feature_families_feature_family_id_seq OWNER TO postgres;

--
-- Name: feature_families_feature_family_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE feature_families_feature_family_id_seq OWNED BY feature_families.feature_family_id;


--
-- Name: feature_family_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_family_types (
    feature_family_id integer NOT NULL,
    feature_type_id integer NOT NULL
);


ALTER TABLE feature_family_types OWNER TO postgres;

--
-- Name: feature_test_results; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_test_results (
    feature_test_id integer NOT NULL,
    run_ts timestamp without time zone NOT NULL,
    outcome bit(1) NOT NULL,
    message character varying(255),
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE feature_test_results OWNER TO postgres;

--
-- Name: feature_tests; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_tests (
    feature_test_id integer NOT NULL,
    feature_type_id integer NOT NULL,
    description character varying(255),
    status character varying(50),
    dbname character varying(100),
    eval_expression character varying(8000) NOT NULL,
    author_name character varying(100),
    author_email character varying(100),
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    where_expression character varying(8000)
);


ALTER TABLE feature_tests OWNER TO postgres;

--
-- Name: feature_tests_feature_test_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE feature_tests_feature_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feature_tests_feature_test_id_seq OWNER TO postgres;

--
-- Name: feature_tests_feature_test_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE feature_tests_feature_test_id_seq OWNED BY feature_tests.feature_test_id;


--
-- Name: feature_type_dependencies; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_type_dependencies (
    dependent_feature_type_id integer NOT NULL,
    independent_feature_type_id integer NOT NULL
);


ALTER TABLE feature_type_dependencies OWNER TO postgres;

--
-- Name: feature_type_tags; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_type_tags (
    feature_type_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE feature_type_tags OWNER TO postgres;

--
-- Name: feature_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE feature_types (
    feature_type_id integer NOT NULL,
    security_classification_id integer,
    value_type_id integer,
    data_type_id integer,
    snapshot_ts timestamp without time zone,
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
    modified_by character varying(255),
    author_name character varying(100),
    author_email character varying(100),
    lang character varying(50),
    customer_id_type_id integer,
    attribute_type character varying(50),
    status character varying(50),
    reference_type character varying(50),
    dbname character varying(100)
);


ALTER TABLE feature_types OWNER TO postgres;

--
-- Name: feature_types_feature_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE feature_types_feature_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feature_types_feature_type_id_seq OWNER TO postgres;

--
-- Name: feature_types_feature_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE feature_types_feature_type_id_seq OWNED BY feature_types.feature_type_id;


--
-- Name: form_schemas; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE form_schemas OWNER TO postgres;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE form_schemas_form_schema_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE form_schemas_form_schema_id_seq OWNER TO postgres;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE form_schemas_form_schema_id_seq OWNED BY form_schemas.form_schema_id;


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hibernate_sequence OWNER TO postgres;

--
-- Name: id_mapping_rules_datasets; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE id_mapping_rules_datasets (
    id integer NOT NULL,
    customer_id_mapping_rule_id integer NOT NULL,
    dataset_id bigint NOT NULL,
    created_ts timestamp without time zone
);


ALTER TABLE id_mapping_rules_datasets OWNER TO postgres;

--
-- Name: id_mapping_rules_datasets_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE id_mapping_rules_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE id_mapping_rules_datasets_id_seq OWNER TO postgres;

--
-- Name: id_mapping_rules_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE id_mapping_rules_datasets_id_seq OWNED BY id_mapping_rules_datasets.id;


--
-- Name: key_values; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE key_values (
    key character varying(100) NOT NULL,
    value character varying,
    value_type character varying(50),
    created_ts timestamp without time zone
);


ALTER TABLE key_values OWNER TO postgres;

--
-- Name: metric_values; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE metric_values (
    analysis_type_id integer NOT NULL,
    metric_id integer NOT NULL,
    column_id bigint NOT NULL,
    numeric_value numeric,
    string_value character varying,
    process_name character varying(100),
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50)
);


ALTER TABLE metric_values OWNER TO postgres;

--
-- Name: metrics; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE metrics (
    metric_id integer NOT NULL,
    metric_name character varying(100) NOT NULL,
    description character varying(255)
);


ALTER TABLE metrics OWNER TO postgres;

--
-- Name: metrics_metric_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE metrics_metric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metrics_metric_id_seq OWNER TO postgres;

--
-- Name: metrics_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE metrics_metric_id_seq OWNED BY metrics.metric_id;


--
-- Name: model_packages_link; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE model_packages_link (
    model_id integer NOT NULL,
    package_id integer NOT NULL
);


ALTER TABLE model_packages_link OWNER TO postgres;

--
-- Name: natural_key; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE natural_key (
    dataset_id bigint NOT NULL,
    column_id bigint NOT NULL
);


ALTER TABLE natural_key OWNER TO postgres;

--
-- Name: queries; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE queries OWNER TO postgres;

--
-- Name: records; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE records OWNER TO postgres;

--
-- Name: records_record_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE records_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE records_record_id_seq OWNER TO postgres;

--
-- Name: records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE records_record_id_seq OWNED BY records.record_id;


--
-- Name: related_analytical_models; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE related_analytical_models (
    model_id_1 integer NOT NULL,
    model_id_2 integer NOT NULL
);


ALTER TABLE related_analytical_models OWNER TO postgres;

--
-- Name: security_classifications; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE security_classifications OWNER TO postgres;

--
-- Name: security_classifications_security_classification_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE security_classifications_security_classification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security_classifications_security_classification_id_seq OWNER TO postgres;

--
-- Name: security_classifications_security_classification_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE security_classifications_security_classification_id_seq OWNED BY security_classifications.security_classification_id;


--
-- Name: settings; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE settings OWNER TO postgres;

--
-- Name: streams; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE streams OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE streams_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE streams_stream_id_seq OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE streams_stream_id_seq OWNED BY streams.stream_id;


--
-- Name: tags; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE tags (
    tag_id integer NOT NULL,
    tag_name character varying(100) NOT NULL
);


ALTER TABLE tags OWNER TO postgres;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE tags_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tags_tag_id_seq OWNER TO postgres;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE tags_tag_id_seq OWNED BY tags.tag_id;


--
-- Name: transformations; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE transformations OWNER TO postgres;

--
-- Name: transformations_transformation_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE transformations_transformation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transformations_transformation_id_seq OWNER TO postgres;

--
-- Name: transformations_transformation_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE transformations_transformation_id_seq OWNED BY transformations.transformation_id;


--
-- Name: transformed_sets; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
--

CREATE TABLE transformed_sets (
    transformation_id bigint NOT NULL,
    dataset_id bigint NOT NULL
);


ALTER TABLE transformed_sets OWNER TO postgres;

--
-- Name: value_types; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE value_types OWNER TO postgres;

--
-- Name: TABLE value_types; Type: COMMENT; Schema: meta; Owner: postgres
--

COMMENT ON TABLE value_types IS 'Examples:
* character
* categorical
* numeric
* integer
* boolean';


--
-- Name: value_types_value_type_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE value_types_value_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE value_types_value_type_id_seq OWNER TO postgres;

--
-- Name: value_types_value_type_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE value_types_value_type_id_seq OWNED BY value_types.value_type_id;


--
-- Name: xdjobs; Type: TABLE; Schema: meta; Owner: postgres; Tablespace:
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


ALTER TABLE xdjobs OWNER TO postgres;

--
-- Name: xdjobs_job_id_seq; Type: SEQUENCE; Schema: meta; Owner: postgres
--

CREATE SEQUENCE xdjobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE xdjobs_job_id_seq OWNER TO postgres;

--
-- Name: xdjobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: postgres
--

ALTER SEQUENCE xdjobs_job_id_seq OWNED BY xdjobs.job_id;


SET search_path = metaform, pg_catalog;

--
-- Name: form_schemas; Type: TABLE; Schema: metaform; Owner: postgres; Tablespace:
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


ALTER TABLE form_schemas OWNER TO postgres;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE; Schema: metaform; Owner: postgres
--

CREATE SEQUENCE form_schemas_form_schema_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE form_schemas_form_schema_id_seq OWNER TO postgres;

--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE OWNED BY; Schema: metaform; Owner: postgres
--

ALTER SEQUENCE form_schemas_form_schema_id_seq OWNED BY form_schemas.form_schema_id;


SET search_path = profiler, pg_catalog;

--
-- Name: data_sources; Type: TABLE; Schema: profiler; Owner: postgres; Tablespace:
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
    connection_url character varying,
    catalog_name character varying(50),
    schema_name character varying(50),
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
    modified_by character varying(50)
);


ALTER TABLE data_sources OWNER TO postgres;

--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE; Schema: profiler; Owner: postgres
--

CREATE SEQUENCE data_sources_data_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_sources_data_source_id_seq OWNER TO postgres;

--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE OWNED BY; Schema: profiler; Owner: postgres
--

ALTER SEQUENCE data_sources_data_source_id_seq OWNED BY data_sources.data_source_id;


SET search_path = cxp, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping ALTER COLUMN id SET DEFAULT nextval('customer_id_mapping_id_seq'::regclass);


--
-- Name: customer_id_type_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_types ALTER COLUMN customer_id_type_id SET DEFAULT nextval('customer_id_types_cust_id_type_id_seq'::regclass);


--
-- Name: property_type_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_property_types ALTER COLUMN property_type_id SET DEFAULT nextval('event_property_types_property_type_id_seq'::regclass);


--
-- Name: property_type_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_property_types_temp ALTER COLUMN property_type_id SET DEFAULT nextval('event_property_types_temp_property_type_id_seq'::regclass);


--
-- Name: event_type_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_types ALTER COLUMN event_type_id SET DEFAULT nextval('event_types_event_type_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY jobs ALTER COLUMN job_id SET DEFAULT nextval('jobs_job_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY jobs_test ALTER COLUMN job_id SET DEFAULT nextval('jobs_test_job_id_seq'::regclass);


SET search_path = gcfr_meta, pg_catalog;

--
-- Name: key_set_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY bkey_key_sets ALTER COLUMN key_set_id SET DEFAULT nextval('bkey_key_sets_key_set_id_seq'::regclass);


--
-- Name: character_set_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY character_sets ALTER COLUMN character_set_id SET DEFAULT nextval('character_sets_character_set_id_seq'::regclass);


--
-- Name: param_group_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY param_groups ALTER COLUMN param_group_id SET DEFAULT nextval('param_groups_param_group_id_seq'::regclass);


--
-- Name: param_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY params ALTER COLUMN param_id SET DEFAULT nextval('params_param_id_seq'::regclass);


--
-- Name: process_type_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY process_types ALTER COLUMN process_type_id SET DEFAULT nextval('process_types_process_type_id_seq'::regclass);


--
-- Name: source_system_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY source_systems ALTER COLUMN source_system_id SET DEFAULT nextval('source_systems_source_system_id_seq'::regclass);


--
-- Name: stream_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY streams ALTER COLUMN stream_id SET DEFAULT nextval('streams_stream_id_seq'::regclass);


--
-- Name: subject_area_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY subject_areas ALTER COLUMN subject_area_id SET DEFAULT nextval('subject_areas_subject_area_id_seq'::regclass);


--
-- Name: table_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY tables ALTER COLUMN table_id SET DEFAULT nextval('tables_table_id_seq'::regclass);


--
-- Name: transform_mapping_id; Type: DEFAULT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY transform_mapping ALTER COLUMN transform_mapping_id SET DEFAULT nextval('transform_mapping_transform_mapping_id_seq'::regclass);


SET search_path = meta, pg_catalog;

--
-- Name: analysis_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY analysis_types ALTER COLUMN analysis_type_id SET DEFAULT nextval('analysis_types_analysis_type_id_seq'::regclass);


--
-- Name: package_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY analytical_model_packages ALTER COLUMN package_id SET DEFAULT nextval('analytical_model_packages_package_id_seq'::regclass);


--
-- Name: model_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY analytical_models ALTER COLUMN model_id SET DEFAULT nextval('analytical_models_model_id_seq'::regclass);


--
-- Name: comment_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN comment_id SET DEFAULT nextval('comments_comment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY cust_property_types_columns ALTER COLUMN id SET DEFAULT nextval('cust_property_types_columns_id_seq'::regclass);


--
-- Name: customer_id_mapping_rule_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping_rules ALTER COLUMN customer_id_mapping_rule_id SET DEFAULT nextval('customer_id_mapping_rules_id_seq'::regclass);


--
-- Name: property_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_property_types ALTER COLUMN property_type_id SET DEFAULT nextval('customer_property_types_property_type_id_seq'::regclass);


--
-- Name: customer_surrogate_key; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customers ALTER COLUMN customer_surrogate_key SET DEFAULT nextval('customers_customer_surrogate_key_seq'::regclass);


--
-- Name: column_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns ALTER COLUMN column_id SET DEFAULT nextval('data_columns_column_id_seq'::regclass);


--
-- Name: data_source_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_sources ALTER COLUMN data_source_id SET DEFAULT nextval('data_sources_data_source_id_seq'::regclass);


--
-- Name: data_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_types ALTER COLUMN data_type_id SET DEFAULT nextval('data_types_data_type_id_seq'::regclass);


--
-- Name: dataset_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY datasets ALTER COLUMN dataset_id SET DEFAULT nextval('datasets_dataset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_property_types_columns ALTER COLUMN id SET DEFAULT nextval('event_property_types_columns_id_seq'::regclass);


--
-- Name: event_type_reln_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_type_reln_type ALTER COLUMN event_type_reln_type_id SET DEFAULT nextval('event_type_reln_type_event_type_reln_type_id_seq_1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_datasets ALTER COLUMN id SET DEFAULT nextval('event_types_datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_records ALTER COLUMN id SET DEFAULT nextval('event_types_records_id_seq'::regclass);


--
-- Name: feature_family_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY feature_families ALTER COLUMN feature_family_id SET DEFAULT nextval('feature_families_feature_family_id_seq'::regclass);


--
-- Name: feature_test_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY feature_tests ALTER COLUMN feature_test_id SET DEFAULT nextval('feature_tests_feature_test_id_seq'::regclass);


--
-- Name: feature_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY feature_types ALTER COLUMN feature_type_id SET DEFAULT nextval('feature_types_feature_type_id_seq'::regclass);


--
-- Name: form_schema_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY form_schemas ALTER COLUMN form_schema_id SET DEFAULT nextval('form_schemas_form_schema_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY id_mapping_rules_datasets ALTER COLUMN id SET DEFAULT nextval('id_mapping_rules_datasets_id_seq'::regclass);


--
-- Name: metric_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY metrics ALTER COLUMN metric_id SET DEFAULT nextval('metrics_metric_id_seq'::regclass);


--
-- Name: record_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY records ALTER COLUMN record_id SET DEFAULT nextval('records_record_id_seq'::regclass);


--
-- Name: security_classification_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY security_classifications ALTER COLUMN security_classification_id SET DEFAULT nextval('security_classifications_security_classification_id_seq'::regclass);


--
-- Name: stream_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY streams ALTER COLUMN stream_id SET DEFAULT nextval('streams_stream_id_seq'::regclass);


--
-- Name: tag_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY tags ALTER COLUMN tag_id SET DEFAULT nextval('tags_tag_id_seq'::regclass);


--
-- Name: transformation_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY transformations ALTER COLUMN transformation_id SET DEFAULT nextval('transformations_transformation_id_seq'::regclass);


--
-- Name: value_type_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY value_types ALTER COLUMN value_type_id SET DEFAULT nextval('value_types_value_type_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY xdjobs ALTER COLUMN job_id SET DEFAULT nextval('xdjobs_job_id_seq'::regclass);


SET search_path = metaform, pg_catalog;

--
-- Name: form_schema_id; Type: DEFAULT; Schema: metaform; Owner: postgres
--

ALTER TABLE ONLY form_schemas ALTER COLUMN form_schema_id SET DEFAULT nextval('form_schemas_form_schema_id_seq'::regclass);


SET search_path = profiler, pg_catalog;

--
-- Name: data_source_id; Type: DEFAULT; Schema: profiler; Owner: postgres
--

ALTER TABLE ONLY data_sources ALTER COLUMN data_source_id SET DEFAULT nextval('data_sources_data_source_id_seq'::regclass);


--
-- Name: 99981; Type: BLOB; Schema: -; Owner: postgres
--

SELECT pg_catalog.lo_create('99981');


ALTER LARGE OBJECT 99981 OWNER TO postgres;

SET search_path = cxp, pg_catalog;

--
-- Data for Name: customer_id_mapping; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY customer_id_mapping (id, customer_id_type_id_1, customer_id_1, customer_id_type_id_2, customer_id_2, confidence, start_ts, end_ts, process_name, created_ts, created_by, modified_ts, modified_by, customer_id1, customer_id2) FROM stdin;
\.


--
-- Name: customer_id_mapping_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('customer_id_mapping_id_seq', 1, true);


--
-- Data for Name: customer_id_types; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY customer_id_types (customer_id_type_id, customer_id_type_name, description, composite, composition_rule, parent_id, data_type_id, value_type_id, created_ts, created_by, modified_ts, modified_by, process_name, marked_for_deletion) FROM stdin;
\.

--
-- Name: customer_id_types_cust_id_type_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('customer_id_types_cust_id_type_id_seq', 35730, true);


--
-- Data for Name: event_properties; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY event_properties (customer_id_type_id, customer_id, event_type_id, ts, event_version, property_type_id, version, value) FROM stdin;
\.


--
-- Data for Name: event_property_types; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY event_property_types (property_type_id, security_classification_id, value_type_id, property_type, description, mapping_expression, process_name, created_ts, created_by, modified_ts, modified_by, event_type_id) FROM stdin;
\.

--
-- Name: event_property_types_property_type_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('event_property_types_property_type_id_seq', 41868, true);


--
-- Data for Name: event_property_types_temp; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY event_property_types_temp (property_type_id, original_property_type_id, event_type_id, security_classification_id, value_type_id, property_type, description, mapping_expression, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: event_property_types_temp_property_type_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('event_property_types_temp_property_type_id_seq', 1, true);


--
-- Data for Name: event_types; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY event_types (event_type_id, namespace, event_type, event_subtype, description, value_type_id, customer_id_type_id1, customer_id_expression1, customer_id_type_id2, customer_id_expression2, filter_expression, value_expression, ts_expression, event_value_desc, created_ts, created_by, modified_ts, modified_by, process_name, datetime_format, timezone, marked_for_deletion, nested_document_expression) FROM stdin;
\.


--
-- Name: event_types_event_type_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('event_types_event_type_id_seq', 41839, true);


--
-- Data for Name: events; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY events (customer_id_type_id, customer_id, event_type_id, ts, event_version, value, job_id, process_name, created_ts, event_property, source_key) FROM stdin;
\.


--
-- Data for Name: events_test; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY events_test (customer_id_type_id, customer_id, event_type_id, ts, event_version, value, job_id, process_name, created_ts) FROM stdin;
\.


--
-- Data for Name: features; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY features (entity_id, feature_type_id, value, eval_ts, process_name, created_ts) FROM stdin;
1234	41832	test	2015-07-23 00:00:00	api	2015-07-23 18:37:52.535
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY jobs (job_id, dataset_id, process_name, job_start_ts, job_end_ts, job_status, exit_message, modified_ts, records_processed, events_created, source_filename, errors_logged, records_skipped) FROM stdin;
\.

--
-- Name: jobs_job_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('jobs_job_id_seq', 51547, true);


--
-- Data for Name: jobs_test; Type: TABLE DATA; Schema: cxp; Owner: postgres
--

COPY jobs_test (job_id, dataset_id, source_filename, process_name, job_start_ts, job_end_ts, job_status, exit_message, records_processed, records_skipped, events_created, errors_logged) FROM stdin;
\.


--
-- Name: jobs_test_job_id_seq; Type: SEQUENCE SET; Schema: cxp; Owner: postgres
--

SELECT pg_catalog.setval('jobs_test_job_id_seq', 1, true);


SET search_path = gcfr_meta, pg_catalog;

--
-- Data for Name: bkey_key_sets; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY bkey_key_sets (key_set_id, key_set_name, key_set_code, key_table_name, key_table_db_name) FROM stdin;
1	BK_CUST	1	BK_CUST	DEV_CAA_CTLFW_T_UTLFW
2	BK_ACCT	2	BK_ACCT	DEV_CAA_CTLFW_T_UTLFW
3	BK_CUST_ACCT_RELSHP	3	BK_CUST_ACCT_RELSHP	DEV_CAA_CTLFW_T_UTLFW
4	BK_CUST_ACCT_REL_CD	4	BK_CUST_ACCT_REL_CD	DEV_CAA_CTLFW_T_UTLFW
\.


--
-- Name: bkey_key_sets_key_set_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('bkey_key_sets_key_set_id_seq', 4, true);


--
-- Data for Name: character_sets; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY character_sets (character_set_id, character_set_name, description, min_character_length, max_character_length) FROM stdin;
1	UTF16	The UTF16 client character set supports UTF-16, one of the standard ways of encoding. UTF16 uses 16-bit units to encode Unicode characters Unicode character data	2	2
2	ASCII	The ASCII is based on Standard ASCII (0X00 to 0X7F) with Teradata extensions to cover ISO 8859-1 (Latin1) and ISO 8859-15 (Latin9).	1	1
3	UTF8	(UTF8) client character set is available for all languages. UTF8 is a version of Unicode optimized for backward compatibility with ASCII. In Teradata UTF8, a character can consist of from one to three bytes.	1	3
\.


--
-- Name: character_sets_character_set_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('character_sets_character_set_id_seq', 3, true);


--
-- Data for Name: columns; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY columns (column_id, column_name, table_id) FROM stdin;
\.


--
-- Name: columns_column_id_seq_1; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('columns_column_id_seq_1', 1, false);


--
-- Data for Name: param_groups; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY param_groups (param_group_id, param_group_name, description) FROM stdin;
1	BULK_PATTERN	Parameters for GCFR Bulk Patterns
2	CHARACTER_SET	Parameters related to International Character Set
3	CONTROL_FILE	Parameters related to control file and source rows count etc.
4	GCFR_QueryBand	Parameters for GCFR Query Band
5	GENERAL	Parameters related to checking, releasing TPT load locks etc.
6	REG_SOURCE_DATA	Parameters in Register Source Data Pattern
7	REVERSAL_PATTERN	Parameters for GCFR Reversal Pattern
8	TPT_DATACONNECTOR_OPERATOR	Parameters for TPT DataConnector Operator in TPT Script.  Refer to TPT Load/Export Operator Attributes in TPT Reference Document
9	TPT_DDL_OPERATOR	Parameters for TPT DDL Operator in TPT Script.  Refer to TPT Load Operator Attributes in TPT Reference Document
10	TPT_LOAD_OPERATOR	Parameters for TPT Load Operator in TPT Script. Refer to TPT Load Operator Attributes in TPT Reference Document
11	TPT_MAIN	Parameters in TPT Main Script
12	TPT_UPDATE_OPERATOR	Parameters for TPT Update Operator in TPT Script.  Refer to TPT Load Operator Attributes in TPT Reference Document
\.


--
-- Name: param_groups_param_group_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('param_groups_param_group_id_seq', 12, true);


--
-- Data for Name: params; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY params (param_id, process_type_id, param_group_id, param_name, description, param_value, param_cast, param_order) FROM stdin;
1	1	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
2	1	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
3	1	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
4	1	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
5	1	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
6	1	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
7	1	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
8	1	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
9	1	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
10	1	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
11	1	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
12	1	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
13	1	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
14	1	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
15	1	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
16	1	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
17	1	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
18	1	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
19	1	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
20	1	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
21	1	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
22	1	4	INCL_TAG_VAR	Include the Tag Variable  in the Session Query Band	1	char(1)	\N
23	1	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
24	1	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
25	1	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
26	2	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
27	2	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
28	2	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
29	2	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
30	2	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
31	2	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
32	2	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
33	2	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
34	2	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
35	2	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
36	2	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
37	2	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
38	2	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
39	2	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
40	2	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
41	2	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
42	2	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
43	2	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
44	2	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
45	2	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
46	2	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
47	2	4	INCL_TAG_VAR	Include the Tag Variable  in the Session Query Band	1	char(1)	\N
48	2	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
49	2	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
50	2	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
51	2	6	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the register process.	loading	varchar	\N
52	3	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
53	3	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
54	3	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
55	3	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
56	3	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
57	3	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
58	3	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
59	3	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
60	3	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
61	3	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
62	3	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
63	3	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
64	3	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
65	3	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
66	3	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
67	3	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
68	3	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
69	3	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
70	3	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
71	3	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
72	3	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
73	3	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
74	3	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
75	3	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
76	3	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
77	4	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
78	4	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
79	4	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
80	4	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
81	4	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
82	4	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
83	4	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
84	4	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
85	4	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
86	4	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
87	4	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
88	4	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
89	4	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
90	4	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
91	4	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
92	4	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
93	4	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
94	4	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
95	4	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
96	4	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
97	4	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
98	4	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
99	4	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
100	4	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
101	4	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
102	4	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
103	4	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
104	4	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
105	4	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
106	4	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
107	4	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
108	4	11	LOGON_FILE_PATH	Full path of Logon file directory	 	varchar	\N
109	4	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
110	4	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
111	4	11	SKIP_DUPLICATES_VALIDATION	Skip Duplicate validation check in Loading Pattern TPT Stats Validation	   0	Integer	\N
112	5	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
113	5	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
114	5	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
115	5	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
116	5	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
117	5	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
118	5	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
119	5	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
120	5	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
121	5	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
122	5	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
123	5	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
124	5	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
125	5	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
126	5	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
127	5	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
128	5	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
129	5	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
130	5	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
131	5	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
132	5	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
133	5	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
134	5	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
135	5	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
136	5	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
137	5	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
138	5	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
139	5	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
140	5	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
141	5	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
142	5	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
143	5	11	LOGON_FILE_PATH	Full path of Logon file directory	 	varchar	\N
144	5	11	OPERATOR_NAME	Name of consumer operator for this process type	UPDATE	varchar	\N
145	5	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
146	6	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
147	6	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
148	6	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
149	6	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
150	6	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
151	6	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
152	6	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
153	6	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
154	6	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
155	6	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
156	6	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
157	6	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
158	6	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
159	6	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
160	6	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
161	6	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
162	6	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
163	6	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
164	6	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
165	6	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
166	6	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
167	6	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
168	6	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
169	6	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
170	6	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
171	6	11	ARCHIVE_DIRECTORY	Name of archive directory, where the log file(s) will be moved, after Export PP.	archive	varchar	\N
172	6	11	EXPORT_INSTANCE	READER_INSTANCE	   2	Integer	\N
173	6	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
174	6	11	OPERATOR_NAME	Name of consumer operator for this process type	EXPORT	varchar	\N
175	7	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
176	7	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
177	7	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
178	7	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
179	7	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
180	7	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
181	7	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
182	7	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
183	7	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
184	7	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
185	7	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
186	7	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
187	7	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
188	7	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
189	7	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
190	7	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
191	7	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
192	7	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
193	7	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
194	7	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
195	7	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
196	7	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
197	7	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
198	7	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
199	7	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
200	7	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
201	7	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
202	7	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
203	7	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
204	7	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
205	7	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
206	7	11	LOGON_FILE_PATH	Full path of Logon file directory	 	varchar	\N
207	7	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
208	7	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
209	8	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
210	8	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
211	8	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
212	8	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
213	8	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
214	8	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
215	8	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
216	8	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
217	8	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
218	8	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
219	8	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
220	8	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
221	8	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
222	8	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
223	8	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
224	8	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
225	8	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
226	8	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
227	8	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
228	8	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
229	8	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
230	8	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
231	8	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
232	8	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
233	8	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
234	8	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
235	8	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
236	8	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
237	8	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
238	8	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
239	8	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
240	8	11	LOGON_FILE_PATH	Full path of Logon file directory	 	varchar	\N
241	8	11	OPERATOR_NAME	Name of consumer operator for this process type	UPDATE	varchar	\N
242	8	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
243	9	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
244	9	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
245	9	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
246	9	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
247	9	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
248	9	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
249	9	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
250	9	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
251	9	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
252	9	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
253	9	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
254	9	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
255	9	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
256	9	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
257	9	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
258	9	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
259	9	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
260	9	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
261	9	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
262	9	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
263	9	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
264	9	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
265	9	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
266	9	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
267	9	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
268	9	11	ARCHIVE_DIRECTORY	Name of archive directory, where the log file(s) will be moved, after Export PP.	archive	varchar	\N
269	9	11	EXPORT_INSTANCE	READER_INSTANCE	   2	Integer	\N
270	9	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
271	9	11	OPERATOR_NAME	Name of consumer operator for this process type	EXPORT	varchar	\N
272	10	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
273	10	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
274	10	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
275	10	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
276	10	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
277	10	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
278	10	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
279	10	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
280	10	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
281	10	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
282	10	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
283	10	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
284	10	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
285	10	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
286	10	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
287	10	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
288	10	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
289	10	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
290	10	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
291	10	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
292	10	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
293	10	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
294	10	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
295	10	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
296	10	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
297	10	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	N	varchar	\N
298	10	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
299	10	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
300	10	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
301	10	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
302	11	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
303	11	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
304	11	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
305	11	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
306	11	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
307	11	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
308	11	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
309	11	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
310	11	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
311	11	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
312	11	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
313	11	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
314	11	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
315	11	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
316	11	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
317	11	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
318	11	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
319	11	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
320	11	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
321	11	5	VERIFICATION_OFF	VERIFICATION_OFF	   0	Integer	\N
322	12	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
323	12	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
324	12	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
325	12	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
326	12	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
327	12	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
328	12	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
329	12	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
330	12	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
331	12	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
332	12	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
333	12	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
334	12	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
335	12	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
336	12	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
337	12	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
338	12	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
339	12	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
340	12	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
341	13	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
342	13	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
343	13	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
344	13	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
345	13	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
346	13	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
347	13	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
348	13	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
349	13	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
350	13	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
351	13	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
352	13	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
353	13	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
354	13	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
355	13	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
356	13	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
357	13	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
358	13	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
359	13	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
360	13	5	EXEC_LARGE_SQL	Execute dynamic SQL using GCFR XSP UT_Execute_Large_SQL Procedure	N	varchar	\N
361	13	5	SKIP_IMAGE_TABLE	SKIP_IMAGE_TABLE	   0	Integer	\N
362	14	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
363	14	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
364	14	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
365	14	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
366	14	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
367	14	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
368	14	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
369	14	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
370	14	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
371	14	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
372	14	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
373	14	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
374	14	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
375	14	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
376	14	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
377	14	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
378	14	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
379	14	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
380	14	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
381	14	5	EXEC_LARGE_SQL	Execute dynamic SQL using GCFR XSP UT_Execute_Large_SQL Procedure	N	varchar	\N
382	14	5	SKIP_IMAGE_TABLE	SKIP_IMAGE_TABLE	   0	Integer	\N
383	15	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
384	15	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
385	15	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
386	15	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
387	15	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
388	15	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
389	15	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
390	15	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
391	15	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
392	15	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
393	15	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
394	15	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
395	15	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
396	15	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
397	15	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
398	15	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
399	15	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
400	15	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
401	15	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
402	15	5	EXEC_LARGE_SQL	Execute dynamic SQL using GCFR XSP UT_Execute_Large_SQL Procedure	N	varchar	\N
403	15	5	SKIP_IMAGE_TABLE	SKIP_IMAGE_TABLE	   0	Integer	\N
404	16	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
405	16	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
406	16	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
407	16	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
408	16	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
409	16	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
410	16	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
411	16	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
412	16	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
413	16	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
414	16	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
415	16	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
416	16	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
417	16	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
418	16	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
419	16	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
420	16	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
421	16	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
422	16	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
423	17	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
424	17	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
425	17	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
426	17	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
427	17	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
428	17	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
429	17	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
430	17	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
431	17	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
432	17	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
433	17	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
434	17	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
435	17	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
436	17	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
437	17	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
438	17	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
439	17	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
440	17	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
441	17	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
442	18	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
443	18	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
444	18	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
445	18	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
446	18	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
447	18	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
448	18	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
449	18	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
450	18	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
451	18	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
452	18	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
453	18	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
454	18	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
455	18	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
456	18	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
457	18	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
458	18	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
459	18	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
460	18	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
461	18	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
462	18	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
463	18	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
464	18	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
465	18	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
466	18	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
467	18	11	ARCHIVE_DIRECTORY	Name of archive directory, where the log file(s) will be moved, after Export PP.	archive	varchar	\N
468	18	11	EXPORT_INSTANCE	READER_INSTANCE	   2	Integer	\N
469	18	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
470	18	11	OPERATOR_NAME	Name of consumer operator for this process type	EXPORT	varchar	\N
471	19	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
472	19	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
473	19	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
474	19	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
475	19	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
476	19	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
477	19	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
478	19	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
479	19	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
480	19	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
481	19	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
482	19	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
483	19	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
484	19	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
485	19	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
486	19	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
487	19	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
488	19	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
489	19	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
490	20	1	RECORD_BATCH_STATS	Batch level stats recording	   0	Integer	\N
491	20	1	RECORD_INDIVIDUAL_STATS	Individual level stats recording	   0	Integer	\N
492	20	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
493	20	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
494	20	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
495	20	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
496	20	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
497	20	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
498	20	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
499	20	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
500	20	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
501	20	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
502	20	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
503	20	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
504	20	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
505	20	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
506	20	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
507	20	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
508	20	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
509	20	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
510	20	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
511	20	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
512	20	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
513	20	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
514	20	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
515	20	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
516	20	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
517	20	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
518	20	6	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
519	20	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
520	20	11	ARCHIVE_DIRECTORY	Name of archive directory, where the Control file will be placed after load.	archive	varchar	\N
521	20	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
522	20	11	LOADING_DIRECTORY	Name of loading directory, where the Control file will be placed for getting loaded.	loading	varchar	\N
523	20	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
524	20	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
525	20	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
526	21	1	RECORD_BATCH_STATS	Batch level stats recording	   0	Integer	\N
527	21	1	RECORD_INDIVIDUAL_STATS	Individual level stats recording	   0	Integer	\N
528	21	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
529	21	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
530	21	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
531	21	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
532	21	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
533	21	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
534	21	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
535	21	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
536	21	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
537	21	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
538	21	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
539	21	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
540	21	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
541	21	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
542	21	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
543	21	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
544	21	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
545	21	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
546	21	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
547	21	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
548	21	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
549	21	4	INCL_Tag_Var	Include the Tag Variable in the Session Query Band	1	char(1)	\N
550	21	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
551	21	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
552	21	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
553	21	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
554	21	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
555	21	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
556	21	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
557	21	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
558	21	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
559	21	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
560	21	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
561	21	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
562	22	1	RECORD_BATCH_STATS	Batch level stats recording	   0	Integer	\N
563	22	1	RECORD_INDIVIDUAL_STATS	Individual level stats recording	   0	Integer	\N
564	22	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
565	22	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
566	22	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
567	22	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
568	22	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
569	22	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
570	22	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
571	22	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
572	22	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
573	22	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
574	22	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
575	22	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
576	22	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
577	22	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
578	22	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
579	22	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
580	22	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
581	22	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
582	22	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
583	22	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
584	22	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
585	22	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
586	22	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
587	22	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
588	22	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
589	22	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
590	22	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
591	22	11	APPEND_MODE	Pattern will append data in the acquisition table	   0	Integer	\N
592	22	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data file will be placed after load.	archive	varchar	\N
593	22	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
594	22	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
595	22	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
596	22	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
597	22	11	OPERATOR_NAME	Name of consumer operator for this process type	UPDATE	varchar	\N
598	22	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
599	23	1	RECORD_BATCH_STATS	Batch level stats recording	   0	Integer	\N
600	23	1	RECORD_INDIVIDUAL_STATS	Individual level stats recording	   0	Integer	\N
601	23	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
602	23	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
603	23	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
604	23	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
605	23	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
606	23	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
607	23	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
608	23	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
609	23	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
610	23	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
611	23	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
612	23	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
613	23	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
614	23	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
615	23	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
616	23	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
617	23	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
618	23	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
619	23	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
620	23	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
621	23	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
622	23	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
623	23	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
624	23	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
625	23	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
626	23	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
627	23	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
628	23	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data and log file(s) will be moved, after Load PP.	archive	varchar	\N
629	23	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
630	23	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
631	23	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
632	23	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
633	23	11	OPERATOR_NAME	Name of consumer operator for this process type	LOAD	varchar	\N
634	23	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
635	24	1	RECORD_BATCH_STATS	Batch level stats recording	   0	Integer	\N
636	24	1	RECORD_INDIVIDUAL_STATS	Individual level stats recording	   0	Integer	\N
637	24	4	INCL_API_NAME	Include the API Name in the Session Query Band	1	char(1)	\N
638	24	4	INCL_BUSINESS_DATE	Include the Business Date in the Session Query Band	1	char(1)	\N
639	24	4	INCL_CLIENT_LOAD_SESSIONS	Include the CLIENT_LOAD_SESSIONS in the Session Query Band	1	char(1)	\N
640	24	4	INCL_CTL_FILE_NAME	Include the Control File Name in the Session Query Band	1	char(1)	\N
641	24	4	INCL_CTL_ID	Include the Control Id in the Session Query Band	1	char(1)	\N
642	24	4	INCL_DATA_FILE_NAME	Include the Data File Name in the Session Query Band	1	char(1)	\N
643	24	4	INCL_ETL_FRAMEWORK	Include the ETL_FRAMEWORK in the Session Query Band	1	char(1)	\N
644	24	4	INCL_FILE_DESCRIPTION	Include the File Description in the Session Query Band	1	char(1)	\N
645	24	4	INCL_FILE_QUEUE_NAME	Include the File Queue Name in the Session Query Band	1	char(1)	\N
646	24	4	INCL_IN_DB_NAME	Include the Input Database Name in the Session Query Band	1	char(1)	\N
647	24	4	INCL_IN_OBJECT_NAME	Include the Input Object Name in the Session Query Band	1	char(1)	\N
648	24	4	INCL_OUT_DB_NAME	Include the Output Database Name in the Session Query Band	1	char(1)	\N
649	24	4	INCL_OUT_OBJECT_NAME	Include the Output Object Name in the Session Query Band	1	char(1)	\N
650	24	4	INCL_PROCESS_DESCRIPTION	Include the Process Description in the Session Query Band	1	char(1)	\N
651	24	4	INCL_PROCESS_ID	Include the Process_Id in the Session Query Band	1	char(1)	\N
652	24	4	INCL_PROCESS_NAME	Include the Process Name in the Session Query Band	1	char(1)	\N
653	24	4	INCL_PROCESS_TYPE	Include the Process Type in the Session Query Band	1	char(1)	\N
654	24	4	INCL_STEP_ID	Include the Step_Id in the Session Query Band	1	char(1)	\N
655	24	4	INCL_STREAM_ID	Include the Stream_Id  in the Session Query Band	1	char(1)	\N
656	24	4	INCL_STREAM_KEY	Include the Stream Key in the Session Query Band	1	char(1)	\N
657	24	4	INCL_STREAM_NAME	Include the Stream Name in the Session Query Band	1	char(1)	\N
658	24	4	INCL_TAG_VAR	Include the Tag Variable in the Session Query Band	1	char(1)	\N
659	24	4	INCL_TARGET_TABLEDATABASENAME	Include the Target Database Name in the Session Query Band	1	char(1)	\N
660	24	4	INCL_TARGET_TABLENAME	Include the Target Table Name in the Session Query Band	1	char(1)	\N
661	24	4	INCL_TEMP_DATABASENAME	Include the temporary Database Name in the Session Query Band	1	char(1)	\N
662	24	5	RELEASE_LOAD_LOCKS	RELEASE_LOAD_LOCKS	Y	varchar	\N
663	24	9	ErrorList	Specifies a list of database errors (by number) to ignore for DDL operator. Load process set this to 3807 to ignore  database error occurs during dropping of previous log, and error tables	3807	varchar	\N
664	24	11	APPEND_MODE	Pattern will append data in the acquisition table	   0	Integer	\N
665	24	11	ARCHIVE_DIRECTORY	Name of archive directory, where the source data and log file(s) will be moved, after Load PP.	archive	varchar	\N
666	24	11	LOADER_INSTANCE	LOADER_INSTANCE	   2	Integer	\N
667	24	11	LOADING_DIRECTORY	Name of loading directory, where the source data file will be placed for the load process.	loading	varchar	\N
668	24	11	LOAD_IN_TYPED_TABLES	Load in typed staging tables	N	varchar	\N
669	24	11	LOGON_FILE_PATH	Full path of Logon file directory for TPT Export	 	varchar	\N
670	24	11	OPERATOR_NAME	Name of consumer operator for this process type	UPDATE	varchar	\N
671	24	11	READER_INSTANCE	READER_INSTANCE	   2	Integer	\N
\.


--
-- Name: params_param_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('params_param_id_seq', 671, true);


--
-- Data for Name: process_types; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY process_types (process_type_id, process_type_code, process_type_name, description) FROM stdin;
1	10	Register Data Set Loaded	Register Data Set Loaded
2	11	Register Data Set Availability	Register Data Set Availability
3	12	Register Data Set Exported	Register Data Set Exported
4	13	TPT Load-FastLoad	TPT Load (FastLoad)
5	14	TPT Update-MLoad	TPT Update (Mload)
6	16	TPT Export-FastExport	TPT Export (FastExport)
7	17	TPT Load-Big SQL	TPT Load (FastLoad) using Large Dynamic SQL based TPT script (up to 2GB in size) generated via Java
8	18	TPT Update-Big SQL	TPT Update (Mload) using Large Dynamic SQL based TPT script (up to 2GB in size) generated via Java
9	19	TPT Export-Big SQL	TPT Export (FastExport) using Large Dynamic SQL based TPT script (up to 2GB in size) generated via Java
10	20	TPT Load Pre-Coded	TPT Load Pre-Coded Script
11	21	Manage missing Surrogate Key	Manage missing Surrogate Key - BKEY
12	22	Manage missing Reference Code	Manage missing Reference Code - BMAP
13	23	Full Transformation	Master Transformation (Full Dump)
14	24	Delta Transformation	Delta Transformation (Delta)
15	25	Transactional Transformation	Transaction Transformation
16	29	History Merge Pattern-Full Tfm	History Merge Pattern - FULL Transform
17	30	History Merge Pattern-DeltaTfm	History Merge Pattern - Delta Transform
18	32	TPT Export Pre-Coded	TPT Export Pre-Coded Script
19	35	Reverse Transaction Transform	Reverse Transaction Transform
20	40	TPT Bulk Register Data Set	TPT Bulk Register Data Set Availability
21	41	TPT Bulk Load-FastLoad	TPT Bulk Load-FastLoad
22	42	TPT Bulk Update-MLoad	TPT Bulk Update-MLoad
23	43	TPT Bulk Load CLOB-FastLoad	TPT Bulk Load CLOB (FastLoad) using Large Dynamic SQL based TPT script (up to 2GB in size) generated via Java
24	44	TPT Bulk Update CLOB-MLoad	TPT Bulk Update CLOB (MLoad) using Large Dynamic SQL based TPT script (up to 2GB in size) generated via Java
\.


--
-- Name: process_types_process_type_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('process_types_process_type_id_seq', 24, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY settings (name, description, value) FROM stdin;
\.


--
-- Data for Name: source_column_mapping; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY source_column_mapping (transform_mapping_id, column_id) FROM stdin;
\.


--
-- Data for Name: source_systems; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--



--
-- Name: source_systems_source_system_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('source_systems_source_system_id_seq', 3, true);


--
-- Data for Name: streams; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--



--
-- Name: streams_stream_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('streams_stream_id_seq', 2, true);


--
-- Data for Name: subject_areas; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY subject_areas (subject_area_id, subject_area_name) FROM stdin;
1	CUSTOMER
2	ACCOUNT
3	TRANSACTION
4	INTERACTION
\.


--
-- Name: subject_areas_subject_area_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('subject_areas_subject_area_id_seq', 4, true);


--
-- Data for Name: tables; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY tables (table_id, table_name) FROM stdin;
\.


--
-- Name: tables_table_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('tables_table_id_seq', 1, true);


--
-- Data for Name: transform_mapping; Type: TABLE DATA; Schema: gcfr_meta; Owner: postgres
--

COPY transform_mapping (transform_mapping_id, subject_area_id, mapping_sequence, target_column_id, source_system_id, transform_type, pseudocode, code, comments) FROM stdin;
\.


--
-- Name: transform_mapping_transform_mapping_id_seq; Type: SEQUENCE SET; Schema: gcfr_meta; Owner: postgres
--

SELECT pg_catalog.setval('transform_mapping_transform_mapping_id_seq', 1, true);


SET search_path = meta, pg_catalog;

--
-- Data for Name: analysis_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY analysis_types (analysis_type_id, analysis_type_name) FROM stdin;
1	default
\.


--
-- Name: analysis_types_analysis_type_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('analysis_types_analysis_type_id_seq', 1, true);


--
-- Data for Name: analytical_model_packages; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY analytical_model_packages (package_id, package_name, description, process_name, created_ts, created_by, modified_ts, modified_by, version) FROM stdin;
41878	dplyr	Data munging	\N	2015-08-01 11:48:32.97	\N	2015-08-01 11:48:32.97	\N	\N
\.


--
-- Name: analytical_model_packages_package_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('analytical_model_packages_package_id_seq', 41878, true);


--
-- Data for Name: analytical_models; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY analytical_models (model_id, model_name, version, committer, contact_person, description, ensemble, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
41891	testmodel	a634e5de46edee46c20d2f1b5878953aaaa51b44	postgres	postgres@me.com	# testmodel\nMy Test Model Repo\n	f	\N	2015-08-03 21:16:17.26	\N	2015-08-03 21:16:17.26	\N
\.


--
-- Name: analytical_models_model_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('analytical_models_model_id_seq', 41891, true);


--
-- Data for Name: column_profile; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY column_profile (column_id, profile_ts, row_count, distinct_count, distinct_values, nulls, min_length, max_length, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Data for Name: column_tags; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY column_tags (column_id, tag_id) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY comments (comment_id, comment, process_name, created_ts, created_by, modified_ts, modified_by, column_id) FROM stdin;
\.


--
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('comments_comment_id_seq', 4, true);


--
-- Data for Name: cust_property_types_columns; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY cust_property_types_columns (id, property_type_id, column_id, process_name, created_ts, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: cust_property_types_columns_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('cust_property_types_columns_id_seq', 1, true);


--
-- Data for Name: customer_id_mapping_rules; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY customer_id_mapping_rules (customer_id_mapping_rule_id, customer_id_mapping_rule_name, customer_id_type_id_1, customer_id_type_id_2, filterexpression, customer_id_1_expression, customer_id_2_expression, start_ts_expression, end_ts_expression, confidence_level, process_name, created_ts, created_by, modified_ts, modified_by, filter_expression, end_ts_format, end_ts_timezone, start_ts_format, start_ts_timezone) FROM stdin;
\.


--
-- Name: customer_id_mapping_rules_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('customer_id_mapping_rules_id_seq', 41834, true);


--
-- Data for Name: customer_ids; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY customer_ids (customer_surrogate_key, customer_id_type_id, customer_id, confidence, version, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Data for Name: customer_properties; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY customer_properties (customer_surrogate_key, property_type_id, value, version, process_name, created_ts) FROM stdin;
\.


--
-- Data for Name: customer_property_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY customer_property_types (property_type_id, security_classification_id, value_type_id, property_type, description, mapping_expression, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: customer_property_types_property_type_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('customer_property_types_property_type_id_seq', 1, true);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY customers (customer_surrogate_key, customer_id_type_id, customer_id, value, version, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: customers_customer_surrogate_key_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('customers_customer_surrogate_key_seq', 1, true);


--
-- Data for Name: data_column_comments; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY data_column_comments (column_id, comment_id) FROM stdin;
\.


--
-- Data for Name: data_columns; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY data_columns (column_id, column_type, dataset_id, record_id, data_type_id, value_type_id, column_index, column_name, description, character_set, collation_type, uniq, nullable_type, length, default_value, autoinc, dimension, "precision", scale, feature_param_candidate, ignore, customer_identifier, customer_id_type_id, process_name, created_ts, created_by, modified_ts, modified_by, original_data_type_id, analysis_status) FROM stdin;
\.


--
-- Name: data_columns_column_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('data_columns_column_id_seq', 2094889, true);


--
-- Data for Name: data_sources; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY data_sources (data_source_id, data_source_type, data_source_name, sourcing_method, hostname, ipaddr, port, network, file_path, filename_pattern, database_name, schema, connection_url, table_name, view_name, query, api_url, firewall_status, description, process_name, created_ts, created_by, modified_ts, modified_by, catalog_name, schema_name, username, password, server_type, server_version, analysis_status) FROM stdin;
\.


--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('data_sources_data_source_id_seq', 41890, true);


--
-- Data for Name: data_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY data_types (data_type_id, data_type_name, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
3	NUMERIC	\N	2015-04-06 16:42:01.67	\N	2015-04-06 16:42:01.67	\N
4	INTEGER	\N	2015-04-06 16:42:10.523	\N	2015-04-06 16:42:10.523	\N
1	NVARCHAR	\N	2015-04-06 16:41:46.056	\N	2015-04-06 16:41:46.056	\N
5	TIMESTAMP	\N	2015-04-06 16:42:22.55	\N	2015-04-06 16:42:22.55	\N
2	TEXT	\N	2015-04-06 16:41:54.606	\N	2015-04-06 16:41:54.606	\N
6	BOOLEAN	\N	2015-04-06 16:42:34.397	\N	2015-04-06 16:42:34.397	\N
\.


--
-- Name: data_types_data_type_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('data_types_data_type_id_seq', 6, true);


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY datasets (dataset_id, dataset_type, multi_recordset, data_source_id, security_classification_id, dataset_name, namespace, description, comments, architecture_domain, contact_person, customer_data, financial_banking_data, id_and_service_history, credit_card_data, financial_reporting_data, privacy_data, regulatory_data, nbn_confidential_data, nbn_compliant, ssu_ready, ssu_remediation_method, available_history_unit_of_time, available_history_units, history_data_size_gb, refresh_data_size_gb, compression_type, column_delimiter, header_row, row_delimiter, text_qualifier, batch, refresh_frequency_unit_of_time, refresh_frequency_units, time_of_day_data_available, data_available_unit_of_time, data_available_days_of_week, data_latency_unit_of_time, data_latency_units, process_name, created_ts, created_by, modified_ts, modified_by, footer_row, file_type, analysis_status) FROM stdin;
\.


--
-- Name: datasets_dataset_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('datasets_dataset_id_seq', 41877, true);


--
-- Data for Name: err_events; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY err_events (error_message, skipped, event_type_id, dataset_id, source_filename, value, job_id, process_name, created_ts, source_key) FROM stdin;
\.


--
-- Data for Name: event_property_types_columns; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_property_types_columns (id, property_type_id, column_id, process_name, created_ts, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: event_property_types_columns_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('event_property_types_columns_id_seq', 19037, true);


--
-- Data for Name: event_type_relationship; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_type_relationship (source_event_type_id, target_event_type_id, event_type_reln_type_id, process_name, created_ts, modified_ts, modified_by) FROM stdin;
\.


--
-- Data for Name: event_type_reln_type; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_type_reln_type (event_type_reln_type_id, event_type_reln_type_name, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: event_type_reln_type_event_type_reln_type_id_seq_1; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('event_type_reln_type_event_type_reln_type_id_seq_1', 1, true);


--
-- Data for Name: event_types_columns; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_types_columns (id, event_type_id, column_id, role_type, process_name, created_ts, modified_ts, modified_by) FROM stdin;
\.


--
-- Data for Name: event_types_cust_id_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_types_cust_id_types (event_type_id, customer_id_type_id, customer_id_expression, process_name, created_ts) FROM stdin;
\.


--
-- Data for Name: event_types_datasets; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_types_datasets (id, event_type_id, dataset_id, process_name, created_ts, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: event_types_datasets_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('event_types_datasets_id_seq', 474, true);


--
-- Data for Name: event_types_records; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY event_types_records (id, event_type_id, dataset_id, process_name, created_ts, modified_ts, modified_by, record_id) FROM stdin;
\.


--
-- Name: event_types_records_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('event_types_records_id_seq', 1, true);


--
-- Data for Name: feature_families; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_families (feature_family_id, feature_family_name, description, wide_table_name, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
41871	Test	Test Family	test_wide_table	\N	2015-07-27 23:05:30.789	\N	2015-07-27 23:05:30.789	\N
\.


--
-- Name: feature_families_feature_family_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('feature_families_feature_family_id_seq', 41871, true);


--
-- Data for Name: feature_family_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_family_types (feature_family_id, feature_type_id) FROM stdin;
41871	41832
\.


--
-- Data for Name: feature_test_results; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_test_results (feature_test_id, run_ts, outcome, message, process_name, created_ts) FROM stdin;
\.


--
-- Data for Name: feature_tests; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_tests (feature_test_id, feature_type_id, description, status, dbname, eval_expression, author_name, author_email, process_name, created_ts, created_by, modified_ts, modified_by, where_expression) FROM stdin;
41875	41832	Test that sum of num_active_txn_accounts is 6	DEV	cxp	SELECT CASE WHEN SUM(val) = 6 THEN 1 ELSE 0 END	Mark Moloney	mmoloney@deloitte.com.au	\N	2015-07-28 00:46:47.786	\N	2015-07-28 00:46:47.786	\N	\N
\.


--
-- Name: feature_tests_feature_test_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('feature_tests_feature_test_id_seq', 41875, true);


--
-- Data for Name: feature_type_dependencies; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_type_dependencies (dependent_feature_type_id, independent_feature_type_id) FROM stdin;
41833	41832
\.


--
-- Data for Name: feature_type_tags; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_type_tags (feature_type_id, tag_id) FROM stdin;
\.


--
-- Data for Name: feature_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY feature_types (feature_type_id, security_classification_id, value_type_id, snapshot_ts, feature_name, column_name, description, reference, expression, version, process_name, created_ts, created_by, modified_ts, modified_by, author_name, author_email, lang, customer_id_type_id, attribute_type, status, reference_type, dbname) FROM stdin;
\.


--
-- Name: feature_types_feature_type_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('feature_types_feature_type_id_seq', 41833, true);


--
-- Data for Name: form_schemas; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY form_schemas (form_schema_id, form_schema_name, description, json_schema, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
1	form-schema	Schema for a Form	{"schema": {"id": "$baseurl/form-schemas/form-schema","$schema": "http://json-schema.org/schema#","name": "Form Schema","description": "Schema for a Form","type": "object","properties": {"name": {"title": "Name","description": "Form name","type": "string"},"description": {"title": "Description","description": "Event Type description","type": "string"},"schema": {"title": "JSON Schema","description": "JSON schema","type": "string"}}},"form": {"schema": {"type": "textarea","rows": 10}}}	\N	2015-04-03 21:22:30.883	\N	2015-04-03 21:22:30.883	\N
2	customer-property-type	Schema for a Customer Property Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/customer-property-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Customer Property Type",\n    "description": "Schema for a Customer Property Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Customer Property Type name",\n        "type": "string"\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the customer property.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "securityClassification": {\n        "title": "Security Classification",\n        "description": "Security classification of the customer property.",\n        "type": "array",\n        "items": {\n          "$ref": "security-classification.json"\n        }\n      },\n      "description": {\n        "title": "Description",\n        "description": "Customer Property Type description",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "securityClassification": {\n      "label": "name",\n      "source": "$ds1url/security-classifications"\n    },\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:23:20.498	\N	2015-04-03 21:23:20.498	\N
3	data-type	Schema for a Data Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/data-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Data Type",\n    "description": "Schema for a Data Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Data Type name",\n        "type": "string"\n      }\n    }\n  }\n}	\N	2015-04-03 21:23:38.611	\N	2015-04-03 21:23:38.611	\N
4	event-property-type	Schema for an Event Property Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-property-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Event Property Type",\n    "description": "Schema for an Event Property Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Event Property Type name",\n        "type": "string"\n      },\n      "securityClassification": {\n        "title": "Security Classification",\n        "description": "Security classification of the event property.",\n        "type": "array",\n        "items": {\n          "$ref": "security-classification.json"\n        }\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the event property.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "description": {\n        "title": "Description",\n        "description": "Event Property Type description",\n        "type": "string"\n      },\n      "mappingExpression": {\n        "title": "Mapping Expression",\n        "description": "Maps one or more source columns to the property value using Spring Expression Language.",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "securityClassification": {\n      "label": "name",\n      "source": "$ds1url/security-classifications"\n    },\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "description": {\n      "type": "textarea"\n    },\n    "mappingExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:23:59.664	\N	2015-04-03 21:23:59.664	\N
3814	column-names	Schema for updating column names	{\n  "schema": {\n    "id": "$baseurl/form-schemas/column-names",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Column Names",\n    "description": "Schema for updating column names",\n    "type": "object",\n    "properties": {\n      "dataset": {\n        "title": "Dataset",\n        "description": "The dataset to update with new column names.",\n        "type": "array",\n        "items": {\n          "$ref": "file-dataset.json"\n        }\n      },\n      "delimiter": {\n        "title": "Delimiter",\n        "description": "Column delimiter",\n        "type": "string"\n      },\n      "names": {\n        "title": "Column names",\n        "description": "New column names",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "dataset": {\n      "label": "name",\n      "source": "$ds1url/file-datasets"\n    },\n    "names": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-04 09:41:01.534	\N	2015-05-04 09:41:01.534	\N
6	event-type	Schema for an Event Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Event Type",\n    "description": "Schema for an Event Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Event Type name",\n        "type": "string"\n      },\n      "namespace": {\n        "title": "Namespace",\n        "description": "Namespace",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Event Type description",\n        "type": "string"\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "customerIdType1": {\n        "title": "Customer ID Type 1",\n        "description": "First Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "customerIdExpression1": {\n        "title": "Customer ID Expression 1",\n        "description": "Maps one or more source columns to the customer ID using Spring Expression Language.",\n        "type": "string"\n      },\n      "customerIdType2": {\n        "title": "Customer ID Type 2",\n        "description": "Second Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "customerIdExpression2": {\n        "title": "Customer ID Expression 2",\n        "description": "Maps one or more source columns to the customer ID using Spring Expression Language.",\n        "type": "string"\n      },\n      "filterExpression": {\n        "title": "Filter Expression",\n        "description": "Condition on which row should be included using Spring Expression Language. If null, then include.",\n        "type": "string"\n      },\n      "valueExpression": {\n        "title": "Value Expression",\n        "description": "Maps one or more source columns to the event value using Spring Expression Language.",\n        "type": "string"\n      },\n      "tsExpression": {\n        "title": "Timestamp Expression",\n        "description": "Maps one or more source columns to the event timestamp using Spring Expression Language.",\n        "type": "string"\n      },\n      "datetimeFormat": {\n        "title": "Timestamp Format",\n        "description": "The format used to parse the timestamp.",\n        "type": "string"\n      },\n      "timezone": {\n        "title": "Timezone",\n        "description": "Timezone of the timestamp value.",\n        "type": "array",\n        "enum": [\n          "Africa/Abidjan",\n          "Africa/Accra",\n          "Africa/Addis_Ababa",\n          "Africa/Algiers",\n          "Africa/Asmara",\n          "Africa/Asmera",\n          "Africa/Bamako",\n          "Africa/Bangui",\n          "Africa/Banjul",\n          "Africa/Bissau",\n          "Africa/Blantyre",\n          "Africa/Brazzaville",\n          "Africa/Bujumbura",\n          "Africa/Cairo",\n          "Africa/Casablanca",\n          "Africa/Ceuta",\n          "Africa/Conakry",\n          "Africa/Dakar",\n          "Africa/Dar_es_Salaam",\n          "Africa/Djibouti",\n          "Africa/Douala",\n          "Africa/El_Aaiun",\n          "Africa/Freetown",\n          "Africa/Gaborone",\n          "Africa/Harare",\n          "Africa/Johannesburg",\n          "Africa/Juba",\n          "Africa/Kampala",\n          "Africa/Khartoum",\n          "Africa/Kigali",\n          "Africa/Kinshasa",\n          "Africa/Lagos",\n          "Africa/Libreville",\n          "Africa/Lome",\n          "Africa/Luanda",\n          "Africa/Lubumbashi",\n          "Africa/Lusaka",\n          "Africa/Malabo",\n          "Africa/Maputo",\n          "Africa/Maseru",\n          "Africa/Mbabane",\n          "Africa/Mogadishu",\n          "Africa/Monrovia",\n          "Africa/Nairobi",\n          "Africa/Ndjamena",\n          "Africa/Niamey",\n          "Africa/Nouakchott",\n          "Africa/Ouagadougou",\n          "Africa/Porto-Novo",\n          "Africa/Sao_Tome",\n          "Africa/Timbuktu",\n          "Africa/Tripoli",\n          "Africa/Tunis",\n          "Africa/Windhoek",\n          "America/Adak",\n          "America/Anchorage",\n          "America/Anguilla",\n          "America/Antigua",\n          "America/Araguaina",\n          "America/Argentina/Buenos_Aires",\n          "America/Argentina/Catamarca",\n          "America/Argentina/ComodRivadavia",\n          "America/Argentina/Cordoba",\n          "America/Argentina/Jujuy",\n          "America/Argentina/La_Rioja",\n          "America/Argentina/Mendoza",\n          "America/Argentina/Rio_Gallegos",\n          "America/Argentina/Salta",\n          "America/Argentina/San_Juan",\n          "America/Argentina/San_Luis",\n          "America/Argentina/Tucuman",\n          "America/Argentina/Ushuaia",\n          "America/Aruba",\n          "America/Asuncion",\n          "America/Atikokan",\n          "America/Atka",\n          "America/Bahia",\n          "America/Bahia_Banderas",\n          "America/Barbados",\n          "America/Belem",\n          "America/Belize",\n          "America/Blanc-Sablon",\n          "America/Boa_Vista",\n          "America/Bogota",\n          "America/Boise",\n          "America/Buenos_Aires",\n          "America/Cambridge_Bay",\n          "America/Campo_Grande",\n          "America/Cancun",\n          "America/Caracas",\n          "America/Catamarca",\n          "America/Cayenne",\n          "America/Cayman",\n          "America/Chicago",\n          "America/Chihuahua",\n          "America/Coral_Harbour",\n          "America/Cordoba",\n          "America/Costa_Rica",\n          "America/Creston",\n          "America/Cuiaba",\n          "America/Curacao",\n          "America/Danmarkshavn",\n          "America/Dawson",\n          "America/Dawson_Creek",\n          "America/Denver",\n          "America/Detroit",\n          "America/Dominica",\n          "America/Edmonton",\n          "America/Eirunepe",\n          "America/El_Salvador",\n          "America/Ensenada",\n          "America/Fort_Wayne",\n          "America/Fortaleza",\n          "America/Glace_Bay",\n          "America/Godthab",\n          "America/Goose_Bay",\n          "America/Grand_Turk",\n          "America/Grenada",\n          "America/Guadeloupe",\n          "America/Guatemala",\n          "America/Guayaquil",\n          "America/Guyana",\n          "America/Halifax",\n          "America/Havana",\n          "America/Hermosillo",\n          "America/Indiana/Indianapolis",\n          "America/Indiana/Knox",\n          "America/Indiana/Marengo",\n          "America/Indiana/Petersburg",\n          "America/Indiana/Tell_City",\n          "America/Indiana/Valparaiso",\n          "America/Indiana/Vevay",\n          "America/Indiana/Vincennes",\n          "America/Indiana/Winamac",\n          "America/Indianapolis",\n          "America/Inuvik",\n          "America/Iqaluit",\n          "America/Jamaica",\n          "America/Jujuy",\n          "America/Juneau",\n          "America/Kentucky/Louisville",\n          "America/Kentucky/Monticello",\n          "America/Knox_IN",\n          "America/Kralendijk",\n          "America/La_Paz",\n          "America/Lima",\n          "America/Los_Angeles",\n          "America/Louisville",\n          "America/Lower_Princes",\n          "America/Maceio",\n          "America/Managua",\n          "America/Manaus",\n          "America/Marigot",\n          "America/Martinique",\n          "America/Matamoros",\n          "America/Mazatlan",\n          "America/Mendoza",\n          "America/Menominee",\n          "America/Merida",\n          "America/Metlakatla",\n          "America/Mexico_City",\n          "America/Miquelon",\n          "America/Moncton",\n          "America/Monterrey",\n          "America/Montevideo",\n          "America/Montreal",\n          "America/Montserrat",\n          "America/Nassau",\n          "America/New_York",\n          "America/Nipigon",\n          "America/Nome",\n          "America/Noronha",\n          "America/North_Dakota/Beulah",\n          "America/North_Dakota/Center",\n          "America/North_Dakota/New_Salem",\n          "America/Ojinaga",\n          "America/Panama",\n          "America/Pangnirtung",\n          "America/Paramaribo",\n          "America/Phoenix",\n          "America/Port_of_Spain",\n          "America/Port-au-Prince",\n          "America/Porto_Acre",\n          "America/Porto_Velho",\n          "America/Puerto_Rico",\n          "America/Rainy_River",\n          "America/Rankin_Inlet",\n          "America/Recife",\n          "America/Regina",\n          "America/Resolute",\n          "America/Rio_Branco",\n          "America/Rosario",\n          "America/Santa_Isabel",\n          "America/Santarem",\n          "America/Santiago",\n          "America/Santo_Domingo",\n          "America/Sao_Paulo",\n          "America/Scoresbysund",\n          "America/Shiprock",\n          "America/Sitka",\n          "America/St_Barthelemy",\n          "America/St_Johns",\n          "America/St_Kitts",\n          "America/St_Lucia",\n          "America/St_Thomas",\n          "America/St_Vincent",\n          "America/Swift_Current",\n          "America/Tegucigalpa",\n          "America/Thule",\n          "America/Thunder_Bay",\n          "America/Tijuana",\n          "America/Toronto",\n          "America/Tortola",\n          "America/Vancouver",\n          "America/Virgin",\n          "America/Whitehorse",\n          "America/Winnipeg",\n          "America/Yakutat",\n          "America/Yellowknife",\n          "Antarctica/Casey",\n          "Antarctica/Davis",\n          "Antarctica/DumontDUrville",\n          "Antarctica/Macquarie",\n          "Antarctica/Mawson",\n          "Antarctica/McMurdo",\n          "Antarctica/Palmer",\n          "Antarctica/Rothera",\n          "Antarctica/South_Pole",\n          "Antarctica/Syowa",\n          "Antarctica/Troll",\n          "Antarctica/Vostok",\n          "Arctic/Longyearbyen",\n          "Asia/Aden",\n          "Asia/Almaty",\n          "Asia/Amman",\n          "Asia/Anadyr",\n          "Asia/Aqtau",\n          "Asia/Aqtobe",\n          "Asia/Ashgabat",\n          "Asia/Ashkhabad",\n          "Asia/Baghdad",\n          "Asia/Bahrain",\n          "Asia/Baku",\n          "Asia/Bangkok",\n          "Asia/Beirut",\n          "Asia/Bishkek",\n          "Asia/Brunei",\n          "Asia/Calcutta",\n          "Asia/Choibalsan",\n          "Asia/Chongqing",\n          "Asia/Chungking",\n          "Asia/Colombo",\n          "Asia/Dacca",\n          "Asia/Damascus",\n          "Asia/Dhaka",\n          "Asia/Dili",\n          "Asia/Dubai",\n          "Asia/Dushanbe",\n          "Asia/Gaza",\n          "Asia/Harbin",\n          "Asia/Hebron",\n          "Asia/Ho_Chi_Minh",\n          "Asia/Hong_Kong",\n          "Asia/Hovd",\n          "Asia/Irkutsk",\n          "Asia/Istanbul",\n          "Asia/Jakarta",\n          "Asia/Jayapura",\n          "Asia/Jerusalem",\n          "Asia/Kabul",\n          "Asia/Kamchatka",\n          "Asia/Karachi",\n          "Asia/Kashgar",\n          "Asia/Kathmandu",\n          "Asia/Katmandu",\n          "Asia/Khandyga",\n          "Asia/Kolkata",\n          "Asia/Krasnoyarsk",\n          "Asia/Kuala_Lumpur",\n          "Asia/Kuching",\n          "Asia/Kuwait",\n          "Asia/Macao",\n          "Asia/Macau",\n          "Asia/Magadan",\n          "Asia/Makassar",\n          "Asia/Manila",\n          "Asia/Muscat",\n          "Asia/Nicosia",\n          "Asia/Novokuznetsk",\n          "Asia/Novosibirsk",\n          "Asia/Omsk",\n          "Asia/Oral",\n          "Asia/Phnom_Penh",\n          "Asia/Pontianak",\n          "Asia/Pyongyang",\n          "Asia/Qatar",\n          "Asia/Qyzylorda",\n          "Asia/Rangoon",\n          "Asia/Riyadh",\n          "Asia/Saigon",\n          "Asia/Sakhalin",\n          "Asia/Samarkand",\n          "Asia/Seoul",\n          "Asia/Shanghai",\n          "Asia/Singapore",\n          "Asia/Taipei",\n          "Asia/Tashkent",\n          "Asia/Tbilisi",\n          "Asia/Tehran",\n          "Asia/Tel_Aviv",\n          "Asia/Thimbu",\n          "Asia/Thimphu",\n          "Asia/Tokyo",\n          "Asia/Ujung_Pandang",\n          "Asia/Ulaanbaatar",\n          "Asia/Ulan_Bator",\n          "Asia/Urumqi",\n          "Asia/Ust-Nera",\n          "Asia/Vientiane",\n          "Asia/Vladivostok",\n          "Asia/Yakutsk",\n          "Asia/Yekaterinburg",\n          "Asia/Yerevan",\n          "Atlantic/Azores",\n          "Atlantic/Bermuda",\n          "Atlantic/Canary",\n          "Atlantic/Cape_Verde",\n          "Atlantic/Faeroe",\n          "Atlantic/Faroe",\n          "Atlantic/Jan_Mayen",\n          "Atlantic/Madeira",\n          "Atlantic/Reykjavik",\n          "Atlantic/South_Georgia",\n          "Atlantic/St_Helena",\n          "Atlantic/Stanley",\n          "Australia/ACT",\n          "Australia/Adelaide",\n          "Australia/Brisbane",\n          "Australia/Broken_Hill",\n          "Australia/Canberra",\n          "Australia/Currie",\n          "Australia/Darwin",\n          "Australia/Eucla",\n          "Australia/Hobart",\n          "Australia/LHI",\n          "Australia/Lindeman",\n          "Australia/Lord_Howe",\n          "Australia/Melbourne",\n          "Australia/North",\n          "Australia/NSW",\n          "Australia/Perth",\n          "Australia/Queensland",\n          "Australia/South",\n          "Australia/Sydney",\n          "Australia/Tasmania",\n          "Australia/Victoria",\n          "Australia/West",\n          "Australia/Yancowinna",\n          "Brazil/Acre",\n          "Brazil/DeNoronha",\n          "Brazil/East",\n          "Brazil/West",\n          "Canada/Atlantic",\n          "Canada/Central",\n          "Canada/Eastern",\n          "Canada/East-Saskatchewan",\n          "Canada/Mountain",\n          "Canada/Newfoundland",\n          "Canada/Pacific",\n          "Canada/Saskatchewan",\n          "Canada/Yukon",\n          "Chile/Continental",\n          "Chile/EasterIsland",\n          "Cuba",\n          "Egypt",\n          "Eire",\n          "Etc/GMT",\n          "Etc/GMT+0",\n          "Etc/UCT",\n          "Etc/Universal",\n          "Etc/UTC",\n          "Etc/Zulu",\n          "Europe/Amsterdam",\n          "Europe/Andorra",\n          "Europe/Athens",\n          "Europe/Belfast",\n          "Europe/Belgrade",\n          "Europe/Berlin",\n          "Europe/Bratislava",\n          "Europe/Brussels",\n          "Europe/Bucharest",\n          "Europe/Budapest",\n          "Europe/Busingen",\n          "Europe/Chisinau",\n          "Europe/Copenhagen",\n          "Europe/Dublin",\n          "Europe/Gibraltar",\n          "Europe/Guernsey",\n          "Europe/Helsinki",\n          "Europe/Isle_of_Man",\n          "Europe/Istanbul",\n          "Europe/Jersey",\n          "Europe/Kaliningrad",\n          "Europe/Kiev",\n          "Europe/Lisbon",\n          "Europe/Ljubljana",\n          "Europe/London",\n          "Europe/Luxembourg",\n          "Europe/Madrid",\n          "Europe/Malta",\n          "Europe/Mariehamn",\n          "Europe/Minsk",\n          "Europe/Monaco",\n          "Europe/Moscow",\n          "Europe/Nicosia",\n          "Europe/Oslo",\n          "Europe/Paris",\n          "Europe/Podgorica",\n          "Europe/Prague",\n          "Europe/Riga",\n          "Europe/Rome",\n          "Europe/Samara",\n          "Europe/San_Marino",\n          "Europe/Sarajevo",\n          "Europe/Simferopol",\n          "Europe/Skopje",\n          "Europe/Sofia",\n          "Europe/Stockholm",\n          "Europe/Tallinn",\n          "Europe/Tirane",\n          "Europe/Tiraspol",\n          "Europe/Uzhgorod",\n          "Europe/Vaduz",\n          "Europe/Vatican",\n          "Europe/Vienna",\n          "Europe/Vilnius",\n          "Europe/Volgograd",\n          "Europe/Warsaw",\n          "Europe/Zagreb",\n          "Europe/Zaporozhye",\n          "Europe/Zurich",\n          "GB",\n          "GB-Eire",\n          "GMT",\n          "GMT+0",\n          "GMT0",\n          "GMT-0",\n          "Greenwich",\n          "Hongkong",\n          "Iceland",\n          "Indian/Antananarivo",\n          "Indian/Chagos",\n          "Indian/Christmas",\n          "Indian/Cocos",\n          "Indian/Comoro",\n          "Indian/Kerguelen",\n          "Indian/Mahe",\n          "Indian/Maldives",\n          "Indian/Mauritius",\n          "Indian/Mayotte",\n          "Indian/Reunion",\n          "Iran",\n          "Israel",\n          "Jamaica",\n          "Japan",\n          "Kwajalein",\n          "Libya",\n          "Mexico/BajaNorte",\n          "Mexico/BajaSur",\n          "Mexico/General",\n          "Navajo",\n          "NZ",\n          "NZ-CHAT",\n          "Pacific/Apia",\n          "Pacific/Auckland",\n          "Pacific/Chatham",\n          "Pacific/Chuuk",\n          "Pacific/Easter",\n          "Pacific/Efate",\n          "Pacific/Enderbury",\n          "Pacific/Fakaofo",\n          "Pacific/Fiji",\n          "Pacific/Funafuti",\n          "Pacific/Galapagos",\n          "Pacific/Gambier",\n          "Pacific/Guadalcanal",\n          "Pacific/Guam",\n          "Pacific/Honolulu",\n          "Pacific/Johnston",\n          "Pacific/Kiritimati",\n          "Pacific/Kosrae",\n          "Pacific/Kwajalein",\n          "Pacific/Majuro",\n          "Pacific/Marquesas",\n          "Pacific/Midway",\n          "Pacific/Nauru",\n          "Pacific/Niue",\n          "Pacific/Norfolk",\n          "Pacific/Noumea",\n          "Pacific/Pago_Pago",\n          "Pacific/Palau",\n          "Pacific/Pitcairn",\n          "Pacific/Pohnpei",\n          "Pacific/Ponape",\n          "Pacific/Port_Moresby",\n          "Pacific/Rarotonga",\n          "Pacific/Saipan",\n          "Pacific/Samoa",\n          "Pacific/Tahiti",\n          "Pacific/Tarawa",\n          "Pacific/Tongatapu",\n          "Pacific/Truk",\n          "Pacific/Wake",\n          "Pacific/Wallis",\n          "Pacific/Yap",\n          "Poland",\n          "Portugal",\n          "PRC",\n          "ROC",\n          "ROK",\n          "Singapore",\n          "Turkey",\n          "UCT",\n          "Universal",\n          "US/Alaska",\n          "US/Aleutian",\n          "US/Arizona",\n          "US/Central",\n          "US/Eastern",\n          "US/East-Indiana",\n          "US/Hawaii",\n          "US/Indiana-Starke",\n          "US/Michigan",\n          "US/Mountain",\n          "US/Pacific",\n          "US/Samoa",\n          "UTC",\n          "W-SU",\n          "Zulu"\n        ]\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    },\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "customerIdType1": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "customerIdExpression1": {\n      "type": "textarea"\n    },\n    "customerIdType2": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "customerIdExpression2": {\n      "type": "textarea"\n    },\n    "filterExpression": {\n      "type": "textarea"\n    },\n    "customerIdExpression": {\n      "type": "textarea"\n    },\n    "valueExpression": {\n      "type": "textarea"\n    },\n    "tsExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:24:17.202	\N	2015-05-04 09:43:00.436	\N
3815	setting	Schema for a Setting	{\n  "schema": {\n    "id": "$baseurl/form-schemas/setting",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Setting",\n    "description": "Schema for a Setting",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Setting name",\n        "type": "string"\n      },\n      "value": {\n        "title": "Value",\n        "description": "Setting value",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "value": {\n      "type": "textarea",\n      "rows": 12\n    }\n  }\n}	\N	2015-05-04 09:44:40.399	\N	2015-05-04 09:44:40.399	\N
7	file-data-source	Schema for File Data Source	{\n  "schema": {\n    "id": "$baseurl/form-schemas/file-data-source",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "File Data Source",\n    "description": "Schema for File Data Source",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Data Source Name",\n        "type": "string"\n      },\n      "sourcingMethod": {\n        "title": "Sourcing Method",\n        "description": "Sourcing method",\n        "type": "string"\n      },\n      "hostname": {\n        "title": "Host Name",\n        "description": "Server hostname",\n        "type": "string"\n      },\n      "ipaddr": {\n        "title": "Host IP Address",\n        "description": "Server IP address",\n        "type": "string"\n      },\n      "port": {\n        "title": "Port",\n        "description": "Server port number",\n        "type": "string"\n      },\n      "firewallStatus": {\n        "title": "Firewall Status",\n        "description": "Firewall status",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Data source description",\n        "type": "string"\n      },\n      "network": {\n        "title": "Network",\n        "description": "Network",\n        "type": "string"\n      },\n      "filepath": {\n        "title": "File Path",\n        "description": "Path of file to ingest",\n        "type": "string"\n      },\n      "filenamePattern": {\n        "title": "Filename Pattern",\n        "description": "Filename pattern of file to ingest",\n        "type": "string"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:25:15.117	\N	2015-04-03 21:25:15.117	\N
8	security-classification	Schema for a Security Classification	{\n  "schema": {\n    "id": "$baseurl/form-schemas/security-classification",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Security Classification",\n    "description": "Schema for a Security Classification",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Security classification name",\n        "type": "string"\n      }\n    }\n  }\n}	\N	2015-04-03 21:25:58.566	\N	2015-04-03 21:25:58.566	\N
9	value-type	Schema for a Value Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/value-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Value Type",\n    "description": "Schema for a Value Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Value Type name",\n        "type": "string"\n      }\n    }\n  }\n}	\N	2015-04-03 21:26:18.343	\N	2015-04-03 21:26:18.343	\N
12	customer-id-type	Schema for a Customer ID Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/customer-id-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Customer ID Type",\n    "description": "Schema for a Customer ID Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Customer ID Type",\n        "description": "Customer ID Type",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Customer ID Type description",\n        "type": "string"\n      },\n      "composite": {\n        "title": "Composite Identifier?",\n        "description": "Is the ID composed of many customer attributes?",\n        "type": "boolean"\n      },\n      "children": {\n        "title": "Child Customer ID Types",\n        "description": "Child customer ID types.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "compositionRule": {\n        "title": "Composition Rule",\n        "description": "If this is a composite identifier, then this describes how the customer attributes are used to derive a unique key.",\n        "type": "string"\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "dataType": {\n        "title": "Data Type",\n        "description": "The data type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "data-type.json"\n        }\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    },\n    "compositionRule": {\n      "type": "textarea"\n    },\n    "children": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types",\n      "type": "multiselect"\n    },\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "dataType": {\n      "label": "name",\n      "source": "$ds1url/data-types"\n    }\n  }\n}	\N	2015-04-03 21:23:00.856	\N	2015-04-08 17:35:35.02	\N
14	customer-id-type-mapping	Schema for a Customer ID Type Mapping	{\n  "schema": {\n    "id": "$baseurl/form-schemas/customer-id-type-mapping",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Customer ID Type",\n    "description": "Schema for a Customer ID Type Mapping",\n    "type": "object",\n    "properties": {\n      "customerIdType": {\n        "title": "Customer ID Type",\n        "description": "The type of Customer ID.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "customerIdExpression": {\n        "title": "Customer ID Expression",\n        "description": "Maps one or more source columns to the customer ID using Spring Expression Language.",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "customerIdType": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "customerIdExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-19 10:09:15.935	\N	2015-04-19 10:31:14.706	\N
15	record	Schema for a Record	{\n  "schema": {\n    "id": "$baseurl/form-schemas/record",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for a Record",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Record name",\n        "type": "string"\n      },\n      "prefix": {\n        "title": "Record Prefix",\n        "description": "Record type prefix",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Record description",\n        "type": "string"\n      },\n      "dataset": {\n        "title": "Dataset",\n        "description": "The record dataset.",\n        "type": "array",\n        "items": {\n          "$ref": "dataset.json"\n        }\n      },\n      "eventTypes": {\n        "title": "Event Types",\n        "description": "Event Types generated from this dataset.",\n        "type": "array",\n        "items": {\n          "$ref": "event-type.json"\n        }\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    },\n    "dataset": {\n      "label": "name",\n      "source": "$ds1url/file-datasets"\n    },\n    "eventTypes": {\n      "label": "name",\n      "source": "$ds1url/event-types",\n      "type": "multiselect"\n    }\n  }\n}	\N	2015-04-19 10:09:15.935	\N	2015-04-19 10:31:14.706	\N
13	customer-id-mapping-rule	Schema for a Customer ID Mapping Rule	{\n  "schema": {\n    "id": "$baseurl/form-schemas/customer-id-mapping-rule",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Customer ID Mapping Rule",\n    "description": "Schema for a Customer ID Mapping Rule",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Rule name",\n        "type": "string"\n      },\n      "filterExpression": {\n        "title": "Filter Expression",\n        "description": "Condition on which row should be included using Spring Expression Language. If null, then include.",\n        "type": "string"\n      },\n      "customerIdType1": {\n        "title": "Customer ID Type 1",\n        "description": "The source Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "customerIdExpression1": {\n        "title": "Customer ID Expression 1",\n        "description": "Mapping of instance columns to the first Customer ID.",\n        "type": "string"\n      },\n      "customerIdType2": {\n        "title": "Customer ID Type 2",\n        "description": "The target Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "customerIdExpression2": {\n        "title": "Customer ID Expression 2",\n        "description": "Mapping of instance columns to the second Customer ID.",\n        "type": "string"\n      },\n      "startTimeExpression": {\n        "title": "Start time Expression",\n        "description": "Mapping of instance columns to the start timestamp.",\n        "type": "string"\n      },\n      "startTimeFormat": {\n        "title": "Start time Format",\n        "description": "The format used to parse the effective start timestamp.",\n        "type": "string"\n      },\n      "startTimezone": {\n        "title": "Start Timezone",\n        "description": "Timezone of the effective start timestamp.",\n        "type": "array",\n        "enum": [\n          "Africa/Abidjan",\n          "Africa/Accra",\n          "Africa/Addis_Ababa",\n          "Africa/Algiers",\n          "Africa/Asmara",\n          "Africa/Asmera",\n          "Africa/Bamako",\n          "Africa/Bangui",\n          "Africa/Banjul",\n          "Africa/Bissau",\n          "Africa/Blantyre",\n          "Africa/Brazzaville",\n          "Africa/Bujumbura",\n          "Africa/Cairo",\n          "Africa/Casablanca",\n          "Africa/Ceuta",\n          "Africa/Conakry",\n          "Africa/Dakar",\n          "Africa/Dar_es_Salaam",\n          "Africa/Djibouti",\n          "Africa/Douala",\n          "Africa/El_Aaiun",\n          "Africa/Freetown",\n          "Africa/Gaborone",\n          "Africa/Harare",\n          "Africa/Johannesburg",\n          "Africa/Juba",\n          "Africa/Kampala",\n          "Africa/Khartoum",\n          "Africa/Kigali",\n          "Africa/Kinshasa",\n          "Africa/Lagos",\n          "Africa/Libreville",\n          "Africa/Lome",\n          "Africa/Luanda",\n          "Africa/Lubumbashi",\n          "Africa/Lusaka",\n          "Africa/Malabo",\n          "Africa/Maputo",\n          "Africa/Maseru",\n          "Africa/Mbabane",\n          "Africa/Mogadishu",\n          "Africa/Monrovia",\n          "Africa/Nairobi",\n          "Africa/Ndjamena",\n          "Africa/Niamey",\n          "Africa/Nouakchott",\n          "Africa/Ouagadougou",\n          "Africa/Porto-Novo",\n          "Africa/Sao_Tome",\n          "Africa/Timbuktu",\n          "Africa/Tripoli",\n          "Africa/Tunis",\n          "Africa/Windhoek",\n          "America/Adak",\n          "America/Anchorage",\n          "America/Anguilla",\n          "America/Antigua",\n          "America/Araguaina",\n          "America/Argentina/Buenos_Aires",\n          "America/Argentina/Catamarca",\n          "America/Argentina/ComodRivadavia",\n          "America/Argentina/Cordoba",\n          "America/Argentina/Jujuy",\n          "America/Argentina/La_Rioja",\n          "America/Argentina/Mendoza",\n          "America/Argentina/Rio_Gallegos",\n          "America/Argentina/Salta",\n          "America/Argentina/San_Juan",\n          "America/Argentina/San_Luis",\n          "America/Argentina/Tucuman",\n          "America/Argentina/Ushuaia",\n          "America/Aruba",\n          "America/Asuncion",\n          "America/Atikokan",\n          "America/Atka",\n          "America/Bahia",\n          "America/Bahia_Banderas",\n          "America/Barbados",\n          "America/Belem",\n          "America/Belize",\n          "America/Blanc-Sablon",\n          "America/Boa_Vista",\n          "America/Bogota",\n          "America/Boise",\n          "America/Buenos_Aires",\n          "America/Cambridge_Bay",\n          "America/Campo_Grande",\n          "America/Cancun",\n          "America/Caracas",\n          "America/Catamarca",\n          "America/Cayenne",\n          "America/Cayman",\n          "America/Chicago",\n          "America/Chihuahua",\n          "America/Coral_Harbour",\n          "America/Cordoba",\n          "America/Costa_Rica",\n          "America/Creston",\n          "America/Cuiaba",\n          "America/Curacao",\n          "America/Danmarkshavn",\n          "America/Dawson",\n          "America/Dawson_Creek",\n          "America/Denver",\n          "America/Detroit",\n          "America/Dominica",\n          "America/Edmonton",\n          "America/Eirunepe",\n          "America/El_Salvador",\n          "America/Ensenada",\n          "America/Fort_Wayne",\n          "America/Fortaleza",\n          "America/Glace_Bay",\n          "America/Godthab",\n          "America/Goose_Bay",\n          "America/Grand_Turk",\n          "America/Grenada",\n          "America/Guadeloupe",\n          "America/Guatemala",\n          "America/Guayaquil",\n          "America/Guyana",\n          "America/Halifax",\n          "America/Havana",\n          "America/Hermosillo",\n          "America/Indiana/Indianapolis",\n          "America/Indiana/Knox",\n          "America/Indiana/Marengo",\n          "America/Indiana/Petersburg",\n          "America/Indiana/Tell_City",\n          "America/Indiana/Valparaiso",\n          "America/Indiana/Vevay",\n          "America/Indiana/Vincennes",\n          "America/Indiana/Winamac",\n          "America/Indianapolis",\n          "America/Inuvik",\n          "America/Iqaluit",\n          "America/Jamaica",\n          "America/Jujuy",\n          "America/Juneau",\n          "America/Kentucky/Louisville",\n          "America/Kentucky/Monticello",\n          "America/Knox_IN",\n          "America/Kralendijk",\n          "America/La_Paz",\n          "America/Lima",\n          "America/Los_Angeles",\n          "America/Louisville",\n          "America/Lower_Princes",\n          "America/Maceio",\n          "America/Managua",\n          "America/Manaus",\n          "America/Marigot",\n          "America/Martinique",\n          "America/Matamoros",\n          "America/Mazatlan",\n          "America/Mendoza",\n          "America/Menominee",\n          "America/Merida",\n          "America/Metlakatla",\n          "America/Mexico_City",\n          "America/Miquelon",\n          "America/Moncton",\n          "America/Monterrey",\n          "America/Montevideo",\n          "America/Montreal",\n          "America/Montserrat",\n          "America/Nassau",\n          "America/New_York",\n          "America/Nipigon",\n          "America/Nome",\n          "America/Noronha",\n          "America/North_Dakota/Beulah",\n          "America/North_Dakota/Center",\n          "America/North_Dakota/New_Salem",\n          "America/Ojinaga",\n          "America/Panama",\n          "America/Pangnirtung",\n          "America/Paramaribo",\n          "America/Phoenix",\n          "America/Port_of_Spain",\n          "America/Port-au-Prince",\n          "America/Porto_Acre",\n          "America/Porto_Velho",\n          "America/Puerto_Rico",\n          "America/Rainy_River",\n          "America/Rankin_Inlet",\n          "America/Recife",\n          "America/Regina",\n          "America/Resolute",\n          "America/Rio_Branco",\n          "America/Rosario",\n          "America/Santa_Isabel",\n          "America/Santarem",\n          "America/Santiago",\n          "America/Santo_Domingo",\n          "America/Sao_Paulo",\n          "America/Scoresbysund",\n          "America/Shiprock",\n          "America/Sitka",\n          "America/St_Barthelemy",\n          "America/St_Johns",\n          "America/St_Kitts",\n          "America/St_Lucia",\n          "America/St_Thomas",\n          "America/St_Vincent",\n          "America/Swift_Current",\n          "America/Tegucigalpa",\n          "America/Thule",\n          "America/Thunder_Bay",\n          "America/Tijuana",\n          "America/Toronto",\n          "America/Tortola",\n          "America/Vancouver",\n          "America/Virgin",\n          "America/Whitehorse",\n          "America/Winnipeg",\n          "America/Yakutat",\n          "America/Yellowknife",\n          "Antarctica/Casey",\n          "Antarctica/Davis",\n          "Antarctica/DumontDUrville",\n          "Antarctica/Macquarie",\n          "Antarctica/Mawson",\n          "Antarctica/McMurdo",\n          "Antarctica/Palmer",\n          "Antarctica/Rothera",\n          "Antarctica/South_Pole",\n          "Antarctica/Syowa",\n          "Antarctica/Troll",\n          "Antarctica/Vostok",\n          "Arctic/Longyearbyen",\n          "Asia/Aden",\n          "Asia/Almaty",\n          "Asia/Amman",\n          "Asia/Anadyr",\n          "Asia/Aqtau",\n          "Asia/Aqtobe",\n          "Asia/Ashgabat",\n          "Asia/Ashkhabad",\n          "Asia/Baghdad",\n          "Asia/Bahrain",\n          "Asia/Baku",\n          "Asia/Bangkok",\n          "Asia/Beirut",\n          "Asia/Bishkek",\n          "Asia/Brunei",\n          "Asia/Calcutta",\n          "Asia/Choibalsan",\n          "Asia/Chongqing",\n          "Asia/Chungking",\n          "Asia/Colombo",\n          "Asia/Dacca",\n          "Asia/Damascus",\n          "Asia/Dhaka",\n          "Asia/Dili",\n          "Asia/Dubai",\n          "Asia/Dushanbe",\n          "Asia/Gaza",\n          "Asia/Harbin",\n          "Asia/Hebron",\n          "Asia/Ho_Chi_Minh",\n          "Asia/Hong_Kong",\n          "Asia/Hovd",\n          "Asia/Irkutsk",\n          "Asia/Istanbul",\n          "Asia/Jakarta",\n          "Asia/Jayapura",\n          "Asia/Jerusalem",\n          "Asia/Kabul",\n          "Asia/Kamchatka",\n          "Asia/Karachi",\n          "Asia/Kashgar",\n          "Asia/Kathmandu",\n          "Asia/Katmandu",\n          "Asia/Khandyga",\n          "Asia/Kolkata",\n          "Asia/Krasnoyarsk",\n          "Asia/Kuala_Lumpur",\n          "Asia/Kuching",\n          "Asia/Kuwait",\n          "Asia/Macao",\n          "Asia/Macau",\n          "Asia/Magadan",\n          "Asia/Makassar",\n          "Asia/Manila",\n          "Asia/Muscat",\n          "Asia/Nicosia",\n          "Asia/Novokuznetsk",\n          "Asia/Novosibirsk",\n          "Asia/Omsk",\n          "Asia/Oral",\n          "Asia/Phnom_Penh",\n          "Asia/Pontianak",\n          "Asia/Pyongyang",\n          "Asia/Qatar",\n          "Asia/Qyzylorda",\n          "Asia/Rangoon",\n          "Asia/Riyadh",\n          "Asia/Saigon",\n          "Asia/Sakhalin",\n          "Asia/Samarkand",\n          "Asia/Seoul",\n          "Asia/Shanghai",\n          "Asia/Singapore",\n          "Asia/Taipei",\n          "Asia/Tashkent",\n          "Asia/Tbilisi",\n          "Asia/Tehran",\n          "Asia/Tel_Aviv",\n          "Asia/Thimbu",\n          "Asia/Thimphu",\n          "Asia/Tokyo",\n          "Asia/Ujung_Pandang",\n          "Asia/Ulaanbaatar",\n          "Asia/Ulan_Bator",\n          "Asia/Urumqi",\n          "Asia/Ust-Nera",\n          "Asia/Vientiane",\n          "Asia/Vladivostok",\n          "Asia/Yakutsk",\n          "Asia/Yekaterinburg",\n          "Asia/Yerevan",\n          "Atlantic/Azores",\n          "Atlantic/Bermuda",\n          "Atlantic/Canary",\n          "Atlantic/Cape_Verde",\n          "Atlantic/Faeroe",\n          "Atlantic/Faroe",\n          "Atlantic/Jan_Mayen",\n          "Atlantic/Madeira",\n          "Atlantic/Reykjavik",\n          "Atlantic/South_Georgia",\n          "Atlantic/St_Helena",\n          "Atlantic/Stanley",\n          "Australia/ACT",\n          "Australia/Adelaide",\n          "Australia/Brisbane",\n          "Australia/Broken_Hill",\n          "Australia/Canberra",\n          "Australia/Currie",\n          "Australia/Darwin",\n          "Australia/Eucla",\n          "Australia/Hobart",\n          "Australia/LHI",\n          "Australia/Lindeman",\n          "Australia/Lord_Howe",\n          "Australia/Melbourne",\n          "Australia/North",\n          "Australia/NSW",\n          "Australia/Perth",\n          "Australia/Queensland",\n          "Australia/South",\n          "Australia/Sydney",\n          "Australia/Tasmania",\n          "Australia/Victoria",\n          "Australia/West",\n          "Australia/Yancowinna",\n          "Brazil/Acre",\n          "Brazil/DeNoronha",\n          "Brazil/East",\n          "Brazil/West",\n          "Canada/Atlantic",\n          "Canada/Central",\n          "Canada/Eastern",\n          "Canada/East-Saskatchewan",\n          "Canada/Mountain",\n          "Canada/Newfoundland",\n          "Canada/Pacific",\n          "Canada/Saskatchewan",\n          "Canada/Yukon",\n          "Chile/Continental",\n          "Chile/EasterIsland",\n          "Cuba",\n          "Egypt",\n          "Eire",\n          "Etc/GMT",\n          "Etc/GMT+0",\n          "Etc/UCT",\n          "Etc/Universal",\n          "Etc/UTC",\n          "Etc/Zulu",\n          "Europe/Amsterdam",\n          "Europe/Andorra",\n          "Europe/Athens",\n          "Europe/Belfast",\n          "Europe/Belgrade",\n          "Europe/Berlin",\n          "Europe/Bratislava",\n          "Europe/Brussels",\n          "Europe/Bucharest",\n          "Europe/Budapest",\n          "Europe/Busingen",\n          "Europe/Chisinau",\n          "Europe/Copenhagen",\n          "Europe/Dublin",\n          "Europe/Gibraltar",\n          "Europe/Guernsey",\n          "Europe/Helsinki",\n          "Europe/Isle_of_Man",\n          "Europe/Istanbul",\n          "Europe/Jersey",\n          "Europe/Kaliningrad",\n          "Europe/Kiev",\n          "Europe/Lisbon",\n          "Europe/Ljubljana",\n          "Europe/London",\n          "Europe/Luxembourg",\n          "Europe/Madrid",\n          "Europe/Malta",\n          "Europe/Mariehamn",\n          "Europe/Minsk",\n          "Europe/Monaco",\n          "Europe/Moscow",\n          "Europe/Nicosia",\n          "Europe/Oslo",\n          "Europe/Paris",\n          "Europe/Podgorica",\n          "Europe/Prague",\n          "Europe/Riga",\n          "Europe/Rome",\n          "Europe/Samara",\n          "Europe/San_Marino",\n          "Europe/Sarajevo",\n          "Europe/Simferopol",\n          "Europe/Skopje",\n          "Europe/Sofia",\n          "Europe/Stockholm",\n          "Europe/Tallinn",\n          "Europe/Tirane",\n          "Europe/Tiraspol",\n          "Europe/Uzhgorod",\n          "Europe/Vaduz",\n          "Europe/Vatican",\n          "Europe/Vienna",\n          "Europe/Vilnius",\n          "Europe/Volgograd",\n          "Europe/Warsaw",\n          "Europe/Zagreb",\n          "Europe/Zaporozhye",\n          "Europe/Zurich",\n          "GB",\n          "GB-Eire",\n          "GMT",\n          "GMT+0",\n          "GMT0",\n          "GMT-0",\n          "Greenwich",\n          "Hongkong",\n          "Iceland",\n          "Indian/Antananarivo",\n          "Indian/Chagos",\n          "Indian/Christmas",\n          "Indian/Cocos",\n          "Indian/Comoro",\n          "Indian/Kerguelen",\n          "Indian/Mahe",\n          "Indian/Maldives",\n          "Indian/Mauritius",\n          "Indian/Mayotte",\n          "Indian/Reunion",\n          "Iran",\n          "Israel",\n          "Jamaica",\n          "Japan",\n          "Kwajalein",\n          "Libya",\n          "Mexico/BajaNorte",\n          "Mexico/BajaSur",\n          "Mexico/General",\n          "Navajo",\n          "NZ",\n          "NZ-CHAT",\n          "Pacific/Apia",\n          "Pacific/Auckland",\n          "Pacific/Chatham",\n          "Pacific/Chuuk",\n          "Pacific/Easter",\n          "Pacific/Efate",\n          "Pacific/Enderbury",\n          "Pacific/Fakaofo",\n          "Pacific/Fiji",\n          "Pacific/Funafuti",\n          "Pacific/Galapagos",\n          "Pacific/Gambier",\n          "Pacific/Guadalcanal",\n          "Pacific/Guam",\n          "Pacific/Honolulu",\n          "Pacific/Johnston",\n          "Pacific/Kiritimati",\n          "Pacific/Kosrae",\n          "Pacific/Kwajalein",\n          "Pacific/Majuro",\n          "Pacific/Marquesas",\n          "Pacific/Midway",\n          "Pacific/Nauru",\n          "Pacific/Niue",\n          "Pacific/Norfolk",\n          "Pacific/Noumea",\n          "Pacific/Pago_Pago",\n          "Pacific/Palau",\n          "Pacific/Pitcairn",\n          "Pacific/Pohnpei",\n          "Pacific/Ponape",\n          "Pacific/Port_Moresby",\n          "Pacific/Rarotonga",\n          "Pacific/Saipan",\n          "Pacific/Samoa",\n          "Pacific/Tahiti",\n          "Pacific/Tarawa",\n          "Pacific/Tongatapu",\n          "Pacific/Truk",\n          "Pacific/Wake",\n          "Pacific/Wallis",\n          "Pacific/Yap",\n          "Poland",\n          "Portugal",\n          "PRC",\n          "ROC",\n          "ROK",\n          "Singapore",\n          "Turkey",\n          "UCT",\n          "Universal",\n          "US/Alaska",\n          "US/Aleutian",\n          "US/Arizona",\n          "US/Central",\n          "US/Eastern",\n          "US/East-Indiana",\n          "US/Hawaii",\n          "US/Indiana-Starke",\n          "US/Michigan",\n          "US/Mountain",\n          "US/Pacific",\n          "US/Samoa",\n          "UTC",\n          "W-SU",\n          "Zulu"\n        ]\n      },\n      "endTimeExpression": {\n        "title": "End time Expression",\n        "description": "Mapping of instance columns to the end timestamp.",\n        "type": "string"\n      },\n      "endTimeFormat": {\n        "title": "End time Format",\n        "description": "The format used to parse the effective end  timestamp.",\n        "type": "string"\n      },\n      "endTimezone": {\n        "title": "End Timezone",\n        "description": "Timezone of the effective end timestamp.",\n        "type": "array",\n        "enum": [\n          "Africa/Abidjan",\n          "Africa/Accra",\n          "Africa/Addis_Ababa",\n          "Africa/Algiers",\n          "Africa/Asmara",\n          "Africa/Asmera",\n          "Africa/Bamako",\n          "Africa/Bangui",\n          "Africa/Banjul",\n          "Africa/Bissau",\n          "Africa/Blantyre",\n          "Africa/Brazzaville",\n          "Africa/Bujumbura",\n          "Africa/Cairo",\n          "Africa/Casablanca",\n          "Africa/Ceuta",\n          "Africa/Conakry",\n          "Africa/Dakar",\n          "Africa/Dar_es_Salaam",\n          "Africa/Djibouti",\n          "Africa/Douala",\n          "Africa/El_Aaiun",\n          "Africa/Freetown",\n          "Africa/Gaborone",\n          "Africa/Harare",\n          "Africa/Johannesburg",\n          "Africa/Juba",\n          "Africa/Kampala",\n          "Africa/Khartoum",\n          "Africa/Kigali",\n          "Africa/Kinshasa",\n          "Africa/Lagos",\n          "Africa/Libreville",\n          "Africa/Lome",\n          "Africa/Luanda",\n          "Africa/Lubumbashi",\n          "Africa/Lusaka",\n          "Africa/Malabo",\n          "Africa/Maputo",\n          "Africa/Maseru",\n          "Africa/Mbabane",\n          "Africa/Mogadishu",\n          "Africa/Monrovia",\n          "Africa/Nairobi",\n          "Africa/Ndjamena",\n          "Africa/Niamey",\n          "Africa/Nouakchott",\n          "Africa/Ouagadougou",\n          "Africa/Porto-Novo",\n          "Africa/Sao_Tome",\n          "Africa/Timbuktu",\n          "Africa/Tripoli",\n          "Africa/Tunis",\n          "Africa/Windhoek",\n          "America/Adak",\n          "America/Anchorage",\n          "America/Anguilla",\n          "America/Antigua",\n          "America/Araguaina",\n          "America/Argentina/Buenos_Aires",\n          "America/Argentina/Catamarca",\n          "America/Argentina/ComodRivadavia",\n          "America/Argentina/Cordoba",\n          "America/Argentina/Jujuy",\n          "America/Argentina/La_Rioja",\n          "America/Argentina/Mendoza",\n          "America/Argentina/Rio_Gallegos",\n          "America/Argentina/Salta",\n          "America/Argentina/San_Juan",\n          "America/Argentina/San_Luis",\n          "America/Argentina/Tucuman",\n          "America/Argentina/Ushuaia",\n          "America/Aruba",\n          "America/Asuncion",\n          "America/Atikokan",\n          "America/Atka",\n          "America/Bahia",\n          "America/Bahia_Banderas",\n          "America/Barbados",\n          "America/Belem",\n          "America/Belize",\n          "America/Blanc-Sablon",\n          "America/Boa_Vista",\n          "America/Bogota",\n          "America/Boise",\n          "America/Buenos_Aires",\n          "America/Cambridge_Bay",\n          "America/Campo_Grande",\n          "America/Cancun",\n          "America/Caracas",\n          "America/Catamarca",\n          "America/Cayenne",\n          "America/Cayman",\n          "America/Chicago",\n          "America/Chihuahua",\n          "America/Coral_Harbour",\n          "America/Cordoba",\n          "America/Costa_Rica",\n          "America/Creston",\n          "America/Cuiaba",\n          "America/Curacao",\n          "America/Danmarkshavn",\n          "America/Dawson",\n          "America/Dawson_Creek",\n          "America/Denver",\n          "America/Detroit",\n          "America/Dominica",\n          "America/Edmonton",\n          "America/Eirunepe",\n          "America/El_Salvador",\n          "America/Ensenada",\n          "America/Fort_Wayne",\n          "America/Fortaleza",\n          "America/Glace_Bay",\n          "America/Godthab",\n          "America/Goose_Bay",\n          "America/Grand_Turk",\n          "America/Grenada",\n          "America/Guadeloupe",\n          "America/Guatemala",\n          "America/Guayaquil",\n          "America/Guyana",\n          "America/Halifax",\n          "America/Havana",\n          "America/Hermosillo",\n          "America/Indiana/Indianapolis",\n          "America/Indiana/Knox",\n          "America/Indiana/Marengo",\n          "America/Indiana/Petersburg",\n          "America/Indiana/Tell_City",\n          "America/Indiana/Valparaiso",\n          "America/Indiana/Vevay",\n          "America/Indiana/Vincennes",\n          "America/Indiana/Winamac",\n          "America/Indianapolis",\n          "America/Inuvik",\n          "America/Iqaluit",\n          "America/Jamaica",\n          "America/Jujuy",\n          "America/Juneau",\n          "America/Kentucky/Louisville",\n          "America/Kentucky/Monticello",\n          "America/Knox_IN",\n          "America/Kralendijk",\n          "America/La_Paz",\n          "America/Lima",\n          "America/Los_Angeles",\n          "America/Louisville",\n          "America/Lower_Princes",\n          "America/Maceio",\n          "America/Managua",\n          "America/Manaus",\n          "America/Marigot",\n          "America/Martinique",\n          "America/Matamoros",\n          "America/Mazatlan",\n          "America/Mendoza",\n          "America/Menominee",\n          "America/Merida",\n          "America/Metlakatla",\n          "America/Mexico_City",\n          "America/Miquelon",\n          "America/Moncton",\n          "America/Monterrey",\n          "America/Montevideo",\n          "America/Montreal",\n          "America/Montserrat",\n          "America/Nassau",\n          "America/New_York",\n          "America/Nipigon",\n          "America/Nome",\n          "America/Noronha",\n          "America/North_Dakota/Beulah",\n          "America/North_Dakota/Center",\n          "America/North_Dakota/New_Salem",\n          "America/Ojinaga",\n          "America/Panama",\n          "America/Pangnirtung",\n          "America/Paramaribo",\n          "America/Phoenix",\n          "America/Port_of_Spain",\n          "America/Port-au-Prince",\n          "America/Porto_Acre",\n          "America/Porto_Velho",\n          "America/Puerto_Rico",\n          "America/Rainy_River",\n          "America/Rankin_Inlet",\n          "America/Recife",\n          "America/Regina",\n          "America/Resolute",\n          "America/Rio_Branco",\n          "America/Rosario",\n          "America/Santa_Isabel",\n          "America/Santarem",\n          "America/Santiago",\n          "America/Santo_Domingo",\n          "America/Sao_Paulo",\n          "America/Scoresbysund",\n          "America/Shiprock",\n          "America/Sitka",\n          "America/St_Barthelemy",\n          "America/St_Johns",\n          "America/St_Kitts",\n          "America/St_Lucia",\n          "America/St_Thomas",\n          "America/St_Vincent",\n          "America/Swift_Current",\n          "America/Tegucigalpa",\n          "America/Thule",\n          "America/Thunder_Bay",\n          "America/Tijuana",\n          "America/Toronto",\n          "America/Tortola",\n          "America/Vancouver",\n          "America/Virgin",\n          "America/Whitehorse",\n          "America/Winnipeg",\n          "America/Yakutat",\n          "America/Yellowknife",\n          "Antarctica/Casey",\n          "Antarctica/Davis",\n          "Antarctica/DumontDUrville",\n          "Antarctica/Macquarie",\n          "Antarctica/Mawson",\n          "Antarctica/McMurdo",\n          "Antarctica/Palmer",\n          "Antarctica/Rothera",\n          "Antarctica/South_Pole",\n          "Antarctica/Syowa",\n          "Antarctica/Troll",\n          "Antarctica/Vostok",\n          "Arctic/Longyearbyen",\n          "Asia/Aden",\n          "Asia/Almaty",\n          "Asia/Amman",\n          "Asia/Anadyr",\n          "Asia/Aqtau",\n          "Asia/Aqtobe",\n          "Asia/Ashgabat",\n          "Asia/Ashkhabad",\n          "Asia/Baghdad",\n          "Asia/Bahrain",\n          "Asia/Baku",\n          "Asia/Bangkok",\n          "Asia/Beirut",\n          "Asia/Bishkek",\n          "Asia/Brunei",\n          "Asia/Calcutta",\n          "Asia/Choibalsan",\n          "Asia/Chongqing",\n          "Asia/Chungking",\n          "Asia/Colombo",\n          "Asia/Dacca",\n          "Asia/Damascus",\n          "Asia/Dhaka",\n          "Asia/Dili",\n          "Asia/Dubai",\n          "Asia/Dushanbe",\n          "Asia/Gaza",\n          "Asia/Harbin",\n          "Asia/Hebron",\n          "Asia/Ho_Chi_Minh",\n          "Asia/Hong_Kong",\n          "Asia/Hovd",\n          "Asia/Irkutsk",\n          "Asia/Istanbul",\n          "Asia/Jakarta",\n          "Asia/Jayapura",\n          "Asia/Jerusalem",\n          "Asia/Kabul",\n          "Asia/Kamchatka",\n          "Asia/Karachi",\n          "Asia/Kashgar",\n          "Asia/Kathmandu",\n          "Asia/Katmandu",\n          "Asia/Khandyga",\n          "Asia/Kolkata",\n          "Asia/Krasnoyarsk",\n          "Asia/Kuala_Lumpur",\n          "Asia/Kuching",\n          "Asia/Kuwait",\n          "Asia/Macao",\n          "Asia/Macau",\n          "Asia/Magadan",\n          "Asia/Makassar",\n          "Asia/Manila",\n          "Asia/Muscat",\n          "Asia/Nicosia",\n          "Asia/Novokuznetsk",\n          "Asia/Novosibirsk",\n          "Asia/Omsk",\n          "Asia/Oral",\n          "Asia/Phnom_Penh",\n          "Asia/Pontianak",\n          "Asia/Pyongyang",\n          "Asia/Qatar",\n          "Asia/Qyzylorda",\n          "Asia/Rangoon",\n          "Asia/Riyadh",\n          "Asia/Saigon",\n          "Asia/Sakhalin",\n          "Asia/Samarkand",\n          "Asia/Seoul",\n          "Asia/Shanghai",\n          "Asia/Singapore",\n          "Asia/Taipei",\n          "Asia/Tashkent",\n          "Asia/Tbilisi",\n          "Asia/Tehran",\n          "Asia/Tel_Aviv",\n          "Asia/Thimbu",\n          "Asia/Thimphu",\n          "Asia/Tokyo",\n          "Asia/Ujung_Pandang",\n          "Asia/Ulaanbaatar",\n          "Asia/Ulan_Bator",\n          "Asia/Urumqi",\n          "Asia/Ust-Nera",\n          "Asia/Vientiane",\n          "Asia/Vladivostok",\n          "Asia/Yakutsk",\n          "Asia/Yekaterinburg",\n          "Asia/Yerevan",\n          "Atlantic/Azores",\n          "Atlantic/Bermuda",\n          "Atlantic/Canary",\n          "Atlantic/Cape_Verde",\n          "Atlantic/Faeroe",\n          "Atlantic/Faroe",\n          "Atlantic/Jan_Mayen",\n          "Atlantic/Madeira",\n          "Atlantic/Reykjavik",\n          "Atlantic/South_Georgia",\n          "Atlantic/St_Helena",\n          "Atlantic/Stanley",\n          "Australia/ACT",\n          "Australia/Adelaide",\n          "Australia/Brisbane",\n          "Australia/Broken_Hill",\n          "Australia/Canberra",\n          "Australia/Currie",\n          "Australia/Darwin",\n          "Australia/Eucla",\n          "Australia/Hobart",\n          "Australia/LHI",\n          "Australia/Lindeman",\n          "Australia/Lord_Howe",\n          "Australia/Melbourne",\n          "Australia/North",\n          "Australia/NSW",\n          "Australia/Perth",\n          "Australia/Queensland",\n          "Australia/South",\n          "Australia/Sydney",\n          "Australia/Tasmania",\n          "Australia/Victoria",\n          "Australia/West",\n          "Australia/Yancowinna",\n          "Brazil/Acre",\n          "Brazil/DeNoronha",\n          "Brazil/East",\n          "Brazil/West",\n          "Canada/Atlantic",\n          "Canada/Central",\n          "Canada/Eastern",\n          "Canada/East-Saskatchewan",\n          "Canada/Mountain",\n          "Canada/Newfoundland",\n          "Canada/Pacific",\n          "Canada/Saskatchewan",\n          "Canada/Yukon",\n          "Chile/Continental",\n          "Chile/EasterIsland",\n          "Cuba",\n          "Egypt",\n          "Eire",\n          "Etc/GMT",\n          "Etc/GMT+0",\n          "Etc/UCT",\n          "Etc/Universal",\n          "Etc/UTC",\n          "Etc/Zulu",\n          "Europe/Amsterdam",\n          "Europe/Andorra",\n          "Europe/Athens",\n          "Europe/Belfast",\n          "Europe/Belgrade",\n          "Europe/Berlin",\n          "Europe/Bratislava",\n          "Europe/Brussels",\n          "Europe/Bucharest",\n          "Europe/Budapest",\n          "Europe/Busingen",\n          "Europe/Chisinau",\n          "Europe/Copenhagen",\n          "Europe/Dublin",\n          "Europe/Gibraltar",\n          "Europe/Guernsey",\n          "Europe/Helsinki",\n          "Europe/Isle_of_Man",\n          "Europe/Istanbul",\n          "Europe/Jersey",\n          "Europe/Kaliningrad",\n          "Europe/Kiev",\n          "Europe/Lisbon",\n          "Europe/Ljubljana",\n          "Europe/London",\n          "Europe/Luxembourg",\n          "Europe/Madrid",\n          "Europe/Malta",\n          "Europe/Mariehamn",\n          "Europe/Minsk",\n          "Europe/Monaco",\n          "Europe/Moscow",\n          "Europe/Nicosia",\n          "Europe/Oslo",\n          "Europe/Paris",\n          "Europe/Podgorica",\n          "Europe/Prague",\n          "Europe/Riga",\n          "Europe/Rome",\n          "Europe/Samara",\n          "Europe/San_Marino",\n          "Europe/Sarajevo",\n          "Europe/Simferopol",\n          "Europe/Skopje",\n          "Europe/Sofia",\n          "Europe/Stockholm",\n          "Europe/Tallinn",\n          "Europe/Tirane",\n          "Europe/Tiraspol",\n          "Europe/Uzhgorod",\n          "Europe/Vaduz",\n          "Europe/Vatican",\n          "Europe/Vienna",\n          "Europe/Vilnius",\n          "Europe/Volgograd",\n          "Europe/Warsaw",\n          "Europe/Zagreb",\n          "Europe/Zaporozhye",\n          "Europe/Zurich",\n          "GB",\n          "GB-Eire",\n          "GMT",\n          "GMT+0",\n          "GMT0",\n          "GMT-0",\n          "Greenwich",\n          "Hongkong",\n          "Iceland",\n          "Indian/Antananarivo",\n          "Indian/Chagos",\n          "Indian/Christmas",\n          "Indian/Cocos",\n          "Indian/Comoro",\n          "Indian/Kerguelen",\n          "Indian/Mahe",\n          "Indian/Maldives",\n          "Indian/Mauritius",\n          "Indian/Mayotte",\n          "Indian/Reunion",\n          "Iran",\n          "Israel",\n          "Jamaica",\n          "Japan",\n          "Kwajalein",\n          "Libya",\n          "Mexico/BajaNorte",\n          "Mexico/BajaSur",\n          "Mexico/General",\n          "Navajo",\n          "NZ",\n          "NZ-CHAT",\n          "Pacific/Apia",\n          "Pacific/Auckland",\n          "Pacific/Chatham",\n          "Pacific/Chuuk",\n          "Pacific/Easter",\n          "Pacific/Efate",\n          "Pacific/Enderbury",\n          "Pacific/Fakaofo",\n          "Pacific/Fiji",\n          "Pacific/Funafuti",\n          "Pacific/Galapagos",\n          "Pacific/Gambier",\n          "Pacific/Guadalcanal",\n          "Pacific/Guam",\n          "Pacific/Honolulu",\n          "Pacific/Johnston",\n          "Pacific/Kiritimati",\n          "Pacific/Kosrae",\n          "Pacific/Kwajalein",\n          "Pacific/Majuro",\n          "Pacific/Marquesas",\n          "Pacific/Midway",\n          "Pacific/Nauru",\n          "Pacific/Niue",\n          "Pacific/Norfolk",\n          "Pacific/Noumea",\n          "Pacific/Pago_Pago",\n          "Pacific/Palau",\n          "Pacific/Pitcairn",\n          "Pacific/Pohnpei",\n          "Pacific/Ponape",\n          "Pacific/Port_Moresby",\n          "Pacific/Rarotonga",\n          "Pacific/Saipan",\n          "Pacific/Samoa",\n          "Pacific/Tahiti",\n          "Pacific/Tarawa",\n          "Pacific/Tongatapu",\n          "Pacific/Truk",\n          "Pacific/Wake",\n          "Pacific/Wallis",\n          "Pacific/Yap",\n          "Poland",\n          "Portugal",\n          "PRC",\n          "ROC",\n          "ROK",\n          "Singapore",\n          "Turkey",\n          "UCT",\n          "Universal",\n          "US/Alaska",\n          "US/Aleutian",\n          "US/Arizona",\n          "US/Central",\n          "US/Eastern",\n          "US/East-Indiana",\n          "US/Hawaii",\n          "US/Indiana-Starke",\n          "US/Michigan",\n          "US/Mountain",\n          "US/Pacific",\n          "US/Samoa",\n          "UTC",\n          "W-SU",\n          "Zulu"\n        ]\n      },\n      "confidenceLevel": {\n        "title": "Confidence Level",\n        "description": "The confidence level of the mapping between customer IDs of these types.",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "filterExpression": {\n      "type": "textarea"\n    },\n    "customerIdType1": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "customerIdExpression1": {\n      "type": "textarea"\n    },\n    "customerIdType2": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "customerIdExpression2": {\n      "type": "textarea"\n    },\n    "startTimeExpression": {\n      "type": "textarea"\n    },\n    "endTimeExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-14 03:23:10.055	\N	2015-05-04 09:44:13.629	\N
32569	table-data-source	Schema for Table Data Source	{\n  "schema": {\n    "id": "$baseurl/form-schemas/table-data-source",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Table Data Source",\n    "description": "Schema for Table Data Source",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Data Source Name",\n        "type": "string"\n      },\n      "sourcingMethod": {\n        "title": "Sourcing Method",\n        "description": "Sourcing method",\n        "type": "string"\n      },\n      "hostname": {\n        "title": "Host Name",\n        "description": "Server hostname",\n        "type": "string"\n      },\n      "ipaddr": {\n        "title": "Host IP Address",\n        "description": "Server IP address",\n        "type": "string"\n      },\n      "port": {\n        "title": "Port",\n        "description": "Server port number",\n        "type": "string"\n      },\n      "firewallStatus": {\n        "title": "Firewall Status",\n        "description": "Firewall status",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Data source description",\n        "type": "string"\n      },\n      "network": {\n        "title": "Network",\n        "description": "Network",\n        "type": "string"\n      },\n      "databaseName": {\n        "title": "Database name",\n        "description": "Database name",\n        "type": "string"\n      },\n      "connectionUrl": {\n        "title": "Connection URL",\n        "description": "Connection URL",\n        "type": "string"\n      },\n      "catalogName": {\n        "title": "Catalog",\n        "description": "Catalog name",\n        "type": "string"\n      },\n      "schemaName": {\n        "title": "Schema",\n        "description": "Schema name",\n        "type": "string"\n      },\n      "tableName": {\n        "title": "Table",\n        "description": "Table name",\n        "type": "string"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-12 17:39:48.422	\N	2015-05-18 14:32:55.543	\N
10	file-column	Schema for File Column	{\n  "schema": {\n    "id": "$baseurl/form-schemas/file-column",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Column",\n    "description": "Schema for File Column",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Name",\n        "type": "string"\n      },\n      "eventPropertyTypes": {\n        "title": "Property Types",\n        "description": "Property Types generated from this column.",\n        "type": "array",\n        "items": {\n          "$ref": "event-property-type.json"\n        }\n      },\n      "fileDataset": {\n        "title": "Dataset",\n        "description": "The dataset which the column belongs to.",\n        "type": "array",\n        "items": {\n          "$ref": "file-dataset.json"\n        }\n      },\n      "dataType": {\n        "title": "Data Type",\n        "description": "The data type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "data-type.json"\n        }\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "columnIndex": {\n        "title": "Column Index",\n        "description": "Index (from 1) of the column in the dataset.",\n        "type": "integer"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Column description",\n        "type": "string"\n      },\n      "characterSet": {\n        "title": "Character Set",\n        "description": "The character set.",\n        "type": "string"\n      },\n      "collation": {\n        "title": "Collation",\n        "description": "The colation type.",\n        "type": "string"\n      },\n      "unique": {\n        "title": "Unique?",\n        "description": "Are column values unique?",\n        "type": "boolean"\n      },\n      "nullableType": {\n        "title": "Nullable Type",\n        "description": "The nullable type of the column.",\n        "enum": ["COLUMN_NO_NULLS", "COLUMN_NULLABLE", "COLUMN_NULLABLE_UNKNOWN"]\n      },\n      "length": {\n        "title": "Length",\n        "description": "Column length",\n        "type": "integer"\n      },\n      "defaultValue": {\n        "title": "Default Value",\n        "description": "The default value.",\n        "type": "string"\n      },\n      "autoinc": {\n        "title": "Auto-increment?",\n        "description": "Does the column have an auto-incrementing value?",\n        "type": "boolean"\n      },\n      "dimension": {\n        "title": "Dimension?",\n        "description": "Is the column a dimension?",\n        "type": "boolean"\n      },\n      "precision": {\n        "title": "Precision",\n        "description": "Number of significant digits of the numeric value.",\n        "type": "integer"\n      },\n      "scale": {\n        "title": "Scale",\n        "description": "Number of decimal places of the numeric value.",\n        "type": "integer"\n      },\n      "featureParamCandidate": {\n        "title": "Feature Parameter?",\n        "description": "Is the column a potential feature parameter?",\n        "type": "boolean"\n      },\n      "ignore": {\n        "title": "Ignore?",\n        "description": "Do not ingest this column?",\n        "type": "boolean"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "eventPropertyTypes": {\n      "label": "name",\n      "source": "$ds1url/event-property-types",\n      "type": "multiselect"\n    },\n    "fileDataset": {\n      "label": "name",\n      "source": "$ds1url/file-datasets"\n    },\n    "dataType": {\n      "label": "name",\n      "source": "$ds1url/data-types"\n    },\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:24:54.409	\N	2015-05-08 16:55:16.966	\N
18663	event-wizard-customer-id	Schema for the Event Wizard Customer ID Type form	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-wizard-customer-id",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for the Event Wizard Customer ID Type form",\n    "type": "object",\n    "properties": {\n      "customerIdType1": {\n        "title": "Customer ID Type",\n        "description": "First Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "column1": {\n        "title": "Select a Column",\n        "description": "The column with the first type of customer ID.",\n        "type": "array",\n        "items": {\n          "$ref": "file-column.json"\n        }\n      },\n      "customerIdExpression1": {\n        "title": "Or enter a Customer ID Expression",\n        "description": "Maps one or more source columns to the customer ID using Spring Expression Language.",\n        "type": "string"\n      },\n      "customerIdType2": {\n        "title": "Customer ID Type (2)",\n        "description": "Second Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "column2": {\n        "title": "Select a Column (2)",\n        "description": "The column with the second type of customer ID.",\n        "type": "array",\n        "items": {\n          "$ref": "file-column.json"\n        }\n      },\n      "customerIdExpression2": {\n        "title": "Or enter a Customer ID Expression (2)",\n        "description": "Maps one or more source columns to the customer ID using Spring Expression Language.",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "customerIdType1": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "column1": {\n      "label": "name",\n      "source": "$ds1url/file-columns"\n    },\n    "customerIdExpression1": {\n      "type": "textarea",\n      "className": "advanced hidden"\n    },\n    "customerIdType2": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types",\n      "className": "advanced hidden"\n    },\n    "column2": {\n      "label": "name",\n      "source": "$ds1url/file-columns",\n      "className": "advanced hidden"\n    },\n    "customerIdExpression2": {\n      "type": "textarea",\n      "className": "advanced hidden"\n    }\n  }\n}	\N	2015-05-11 09:02:15.721	\N	2015-05-11 09:02:15.721	\N
18664	event-wizard-dataset	Schema for the Event Wizard Dataset form	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-wizard-dataset",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for the Event Wizard Dataset form",\n    "type": "object",\n    "properties": {\n      "deleteExistingEvents": {\n        "title": "Remove existing events?",\n        "description": "Remove existing events",\n        "type": "boolean"\n      },\n      "name": {\n        "title": "Name",\n        "description": "Name of the event",\n        "type": "string"\n      },\n      "dataset": {\n        "title": "Dataset",\n        "description": "The record dataset.",\n        "type": "array",\n        "items": {\n          "$ref": "file-dataset.json"\n        }\n      },\n      "namespace": {\n        "title": "Namespace",\n        "description": "Namespace",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Event Type description",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "dataset": {\n      "label": "name",\n      "source": "$ds1url/file-datasets"\n    },\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-11 09:02:48.308	\N	2015-05-11 09:02:48.308	\N
18665	event-wizard-filename-pattern	Schema for the Event Wizard Filename Pattern	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-wizard-filename-pattern",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for the Event Wizard Filename Pattern",\n    "type": "object",\n    "properties": {\n      "filenamePattern": {\n        "title": "Filename Pattern",\n        "description": "Filename pattern of file to ingest",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n  }\n}	\N	2015-05-11 09:03:07.402	\N	2015-05-11 09:03:07.402	\N
18666	event-wizard-filter	Schema for the Event Wizard Filter Expression	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-wizard-filter",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for the Event Wizard Filter Expression",\n    "type": "object",\n    "properties": {\n      "filterExpression": {\n        "title": "Filter Expression",\n        "description": "Condition on which row should be included using Spring Expression Language. If null, then include.",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "filterExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-11 09:03:26.84	\N	2015-05-11 09:03:26.84	\N
18667	event-wizard-timestamp	Schema for the Event Wizard Timestamp form	{\n  "schema": {\n    "id": "$baseurl/form-schemas/event-wizard-timestamp",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for the Event Wizard Timestamp form",\n    "type": "object",\n    "properties": {\n      "column": {\n        "title": "Select a Column",\n        "description": "The column with the timestamp.",\n        "type": "array",\n        "items": {\n          "$ref": "file-column.json"\n        }\n      },\n      "tsExpression": {\n        "title": "Or enter a Timestamp Expression",\n        "description": "Maps one or more source columns to the event timestamp using Spring Expression Language.",\n        "type": "string"\n      },\n      "datetimeFormat": {\n        "title": "Timestamp Format",\n        "description": "The format used to parse the timestamp.",\n        "type": "array",\n        "enum": [\n          "yyyy-MM-dd'T'HH:mm:ss.SSSZ",\n          "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",\n          "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",\n          "yyyy-MM-dd HH:mm:ss.SSSZ",\n          "yyyy-MM-dd HH:mm:ss.SSSXXX",\n          "yyyy-MM-dd HH:mm:ss.SSSSSS",\n          "yyyyMMdd HH:mm:ss",\n          "EEE, MMM d, ''yy",\n          "EEE, MMM d, yyyy",\n          "yyyy.MM.dd",\n          "yyyy-MM-dd",\n          "yyyy/MM/dd",\n          "dd.MM.yyyy",\n          "dd-MM-yyyy",\n          "dd/MM/yyyy",\n          "MM.dd.yyyy",\n          "MM-dd-yyyy",\n          "MM/dd/yyyy",\n          "dd.MM.yy",\n          "dd-MM-yy",\n          "dd/MM/yy",\n          "MM.dd.yy",\n          "MM-dd-yy",\n          "MM/dd/yy",\n          "dd/MMM/yy",\n          "yyyy-MM-dd",\n          "yyyy-MM-dd'T'HH",\n          "yyyy-MM-dd HH",\n          "yyyy-MM-dd'T'HH:mm",\n          "yyyy-MM-dd HH:mm",\n          "yyyy-MM-dd'T'HH:mm:ss",\n          "yyyy-MM-dd HH:mm:ss",\n          "yyyy-MM-dd'T'HH:mm:ss.SSS",\n          "yyyy-MM-dd HH:mm:ss.SSS",\n          "yyyy-MM-dd'T'HH:mm:ss Z",\n          "yyyy-MM-dd HH:mm:ss Z"\n        ]\n      },\n      "newDatetimeFormat": {\n        "title": "New Timestamp Format",\n        "description": "The format used to parse the timestamp.",\n        "type": "string"\n      },\n      "timezone": {\n        "title": "Timezone",\n        "description": "Timezone of the timestamp value.",\n        "type": "array",\n        "enum": [\n          "Africa/Abidjan",\n          "Africa/Accra",\n          "Africa/Addis_Ababa",\n          "Africa/Algiers",\n          "Africa/Asmara",\n          "Africa/Asmera",\n          "Africa/Bamako",\n          "Africa/Bangui",\n          "Africa/Banjul",\n          "Africa/Bissau",\n          "Africa/Blantyre",\n          "Africa/Brazzaville",\n          "Africa/Bujumbura",\n          "Africa/Cairo",\n          "Africa/Casablanca",\n          "Africa/Ceuta",\n          "Africa/Conakry",\n          "Africa/Dakar",\n          "Africa/Dar_es_Salaam",\n          "Africa/Djibouti",\n          "Africa/Douala",\n          "Africa/El_Aaiun",\n          "Africa/Freetown",\n          "Africa/Gaborone",\n          "Africa/Harare",\n          "Africa/Johannesburg",\n          "Africa/Juba",\n          "Africa/Kampala",\n          "Africa/Khartoum",\n          "Africa/Kigali",\n          "Africa/Kinshasa",\n          "Africa/Lagos",\n          "Africa/Libreville",\n          "Africa/Lome",\n          "Africa/Luanda",\n          "Africa/Lubumbashi",\n          "Africa/Lusaka",\n          "Africa/Malabo",\n          "Africa/Maputo",\n          "Africa/Maseru",\n          "Africa/Mbabane",\n          "Africa/Mogadishu",\n          "Africa/Monrovia",\n          "Africa/Nairobi",\n          "Africa/Ndjamena",\n          "Africa/Niamey",\n          "Africa/Nouakchott",\n          "Africa/Ouagadougou",\n          "Africa/Porto-Novo",\n          "Africa/Sao_Tome",\n          "Africa/Timbuktu",\n          "Africa/Tripoli",\n          "Africa/Tunis",\n          "Africa/Windhoek",\n          "America/Adak",\n          "America/Anchorage",\n          "America/Anguilla",\n          "America/Antigua",\n          "America/Araguaina",\n          "America/Argentina/Buenos_Aires",\n          "America/Argentina/Catamarca",\n          "America/Argentina/ComodRivadavia",\n          "America/Argentina/Cordoba",\n          "America/Argentina/Jujuy",\n          "America/Argentina/La_Rioja",\n          "America/Argentina/Mendoza",\n          "America/Argentina/Rio_Gallegos",\n          "America/Argentina/Salta",\n          "America/Argentina/San_Juan",\n          "America/Argentina/San_Luis",\n          "America/Argentina/Tucuman",\n          "America/Argentina/Ushuaia",\n          "America/Aruba",\n          "America/Asuncion",\n          "America/Atikokan",\n          "America/Atka",\n          "America/Bahia",\n          "America/Bahia_Banderas",\n          "America/Barbados",\n          "America/Belem",\n          "America/Belize",\n          "America/Blanc-Sablon",\n          "America/Boa_Vista",\n          "America/Bogota",\n          "America/Boise",\n          "America/Buenos_Aires",\n          "America/Cambridge_Bay",\n          "America/Campo_Grande",\n          "America/Cancun",\n          "America/Caracas",\n          "America/Catamarca",\n          "America/Cayenne",\n          "America/Cayman",\n          "America/Chicago",\n          "America/Chihuahua",\n          "America/Coral_Harbour",\n          "America/Cordoba",\n          "America/Costa_Rica",\n          "America/Creston",\n          "America/Cuiaba",\n          "America/Curacao",\n          "America/Danmarkshavn",\n          "America/Dawson",\n          "America/Dawson_Creek",\n          "America/Denver",\n          "America/Detroit",\n          "America/Dominica",\n          "America/Edmonton",\n          "America/Eirunepe",\n          "America/El_Salvador",\n          "America/Ensenada",\n          "America/Fort_Wayne",\n          "America/Fortaleza",\n          "America/Glace_Bay",\n          "America/Godthab",\n          "America/Goose_Bay",\n          "America/Grand_Turk",\n          "America/Grenada",\n          "America/Guadeloupe",\n          "America/Guatemala",\n          "America/Guayaquil",\n          "America/Guyana",\n          "America/Halifax",\n          "America/Havana",\n          "America/Hermosillo",\n          "America/Indiana/Indianapolis",\n          "America/Indiana/Knox",\n          "America/Indiana/Marengo",\n          "America/Indiana/Petersburg",\n          "America/Indiana/Tell_City",\n          "America/Indiana/Valparaiso",\n          "America/Indiana/Vevay",\n          "America/Indiana/Vincennes",\n          "America/Indiana/Winamac",\n          "America/Indianapolis",\n          "America/Inuvik",\n          "America/Iqaluit",\n          "America/Jamaica",\n          "America/Jujuy",\n          "America/Juneau",\n          "America/Kentucky/Louisville",\n          "America/Kentucky/Monticello",\n          "America/Knox_IN",\n          "America/Kralendijk",\n          "America/La_Paz",\n          "America/Lima",\n          "America/Los_Angeles",\n          "America/Louisville",\n          "America/Lower_Princes",\n          "America/Maceio",\n          "America/Managua",\n          "America/Manaus",\n          "America/Marigot",\n          "America/Martinique",\n          "America/Matamoros",\n          "America/Mazatlan",\n          "America/Mendoza",\n          "America/Menominee",\n          "America/Merida",\n          "America/Metlakatla",\n          "America/Mexico_City",\n          "America/Miquelon",\n          "America/Moncton",\n          "America/Monterrey",\n          "America/Montevideo",\n          "America/Montreal",\n          "America/Montserrat",\n          "America/Nassau",\n          "America/New_York",\n          "America/Nipigon",\n          "America/Nome",\n          "America/Noronha",\n          "America/North_Dakota/Beulah",\n          "America/North_Dakota/Center",\n          "America/North_Dakota/New_Salem",\n          "America/Ojinaga",\n          "America/Panama",\n          "America/Pangnirtung",\n          "America/Paramaribo",\n          "America/Phoenix",\n          "America/Port_of_Spain",\n          "America/Port-au-Prince",\n          "America/Porto_Acre",\n          "America/Porto_Velho",\n          "America/Puerto_Rico",\n          "America/Rainy_River",\n          "America/Rankin_Inlet",\n          "America/Recife",\n          "America/Regina",\n          "America/Resolute",\n          "America/Rio_Branco",\n          "America/Rosario",\n          "America/Santa_Isabel",\n          "America/Santarem",\n          "America/Santiago",\n          "America/Santo_Domingo",\n          "America/Sao_Paulo",\n          "America/Scoresbysund",\n          "America/Shiprock",\n          "America/Sitka",\n          "America/St_Barthelemy",\n          "America/St_Johns",\n          "America/St_Kitts",\n          "America/St_Lucia",\n          "America/St_Thomas",\n          "America/St_Vincent",\n          "America/Swift_Current",\n          "America/Tegucigalpa",\n          "America/Thule",\n          "America/Thunder_Bay",\n          "America/Tijuana",\n          "America/Toronto",\n          "America/Tortola",\n          "America/Vancouver",\n          "America/Virgin",\n          "America/Whitehorse",\n          "America/Winnipeg",\n          "America/Yakutat",\n          "America/Yellowknife",\n          "Antarctica/Casey",\n          "Antarctica/Davis",\n          "Antarctica/DumontDUrville",\n          "Antarctica/Macquarie",\n          "Antarctica/Mawson",\n          "Antarctica/McMurdo",\n          "Antarctica/Palmer",\n          "Antarctica/Rothera",\n          "Antarctica/South_Pole",\n          "Antarctica/Syowa",\n          "Antarctica/Troll",\n          "Antarctica/Vostok",\n          "Arctic/Longyearbyen",\n          "Asia/Aden",\n          "Asia/Almaty",\n          "Asia/Amman",\n          "Asia/Anadyr",\n          "Asia/Aqtau",\n          "Asia/Aqtobe",\n          "Asia/Ashgabat",\n          "Asia/Ashkhabad",\n          "Asia/Baghdad",\n          "Asia/Bahrain",\n          "Asia/Baku",\n          "Asia/Bangkok",\n          "Asia/Beirut",\n          "Asia/Bishkek",\n          "Asia/Brunei",\n          "Asia/Calcutta",\n          "Asia/Choibalsan",\n          "Asia/Chongqing",\n          "Asia/Chungking",\n          "Asia/Colombo",\n          "Asia/Dacca",\n          "Asia/Damascus",\n          "Asia/Dhaka",\n          "Asia/Dili",\n          "Asia/Dubai",\n          "Asia/Dushanbe",\n          "Asia/Gaza",\n          "Asia/Harbin",\n          "Asia/Hebron",\n          "Asia/Ho_Chi_Minh",\n          "Asia/Hong_Kong",\n          "Asia/Hovd",\n          "Asia/Irkutsk",\n          "Asia/Istanbul",\n          "Asia/Jakarta",\n          "Asia/Jayapura",\n          "Asia/Jerusalem",\n          "Asia/Kabul",\n          "Asia/Kamchatka",\n          "Asia/Karachi",\n          "Asia/Kashgar",\n          "Asia/Kathmandu",\n          "Asia/Katmandu",\n          "Asia/Khandyga",\n          "Asia/Kolkata",\n          "Asia/Krasnoyarsk",\n          "Asia/Kuala_Lumpur",\n          "Asia/Kuching",\n          "Asia/Kuwait",\n          "Asia/Macao",\n          "Asia/Macau",\n          "Asia/Magadan",\n          "Asia/Makassar",\n          "Asia/Manila",\n          "Asia/Muscat",\n          "Asia/Nicosia",\n          "Asia/Novokuznetsk",\n          "Asia/Novosibirsk",\n          "Asia/Omsk",\n          "Asia/Oral",\n          "Asia/Phnom_Penh",\n          "Asia/Pontianak",\n          "Asia/Pyongyang",\n          "Asia/Qatar",\n          "Asia/Qyzylorda",\n          "Asia/Rangoon",\n          "Asia/Riyadh",\n          "Asia/Saigon",\n          "Asia/Sakhalin",\n          "Asia/Samarkand",\n          "Asia/Seoul",\n          "Asia/Shanghai",\n          "Asia/Singapore",\n          "Asia/Taipei",\n          "Asia/Tashkent",\n          "Asia/Tbilisi",\n          "Asia/Tehran",\n          "Asia/Tel_Aviv",\n          "Asia/Thimbu",\n          "Asia/Thimphu",\n          "Asia/Tokyo",\n          "Asia/Ujung_Pandang",\n          "Asia/Ulaanbaatar",\n          "Asia/Ulan_Bator",\n          "Asia/Urumqi",\n          "Asia/Ust-Nera",\n          "Asia/Vientiane",\n          "Asia/Vladivostok",\n          "Asia/Yakutsk",\n          "Asia/Yekaterinburg",\n          "Asia/Yerevan",\n          "Atlantic/Azores",\n          "Atlantic/Bermuda",\n          "Atlantic/Canary",\n          "Atlantic/Cape_Verde",\n          "Atlantic/Faeroe",\n          "Atlantic/Faroe",\n          "Atlantic/Jan_Mayen",\n          "Atlantic/Madeira",\n          "Atlantic/Reykjavik",\n          "Atlantic/South_Georgia",\n          "Atlantic/St_Helena",\n          "Atlantic/Stanley",\n          "Australia/ACT",\n          "Australia/Adelaide",\n          "Australia/Brisbane",\n          "Australia/Broken_Hill",\n          "Australia/Canberra",\n          "Australia/Currie",\n          "Australia/Darwin",\n          "Australia/Eucla",\n          "Australia/Hobart",\n          "Australia/LHI",\n          "Australia/Lindeman",\n          "Australia/Lord_Howe",\n          "Australia/Melbourne",\n          "Australia/North",\n          "Australia/NSW",\n          "Australia/Perth",\n          "Australia/Queensland",\n          "Australia/South",\n          "Australia/Sydney",\n          "Australia/Tasmania",\n          "Australia/Victoria",\n          "Australia/West",\n          "Australia/Yancowinna",\n          "Brazil/Acre",\n          "Brazil/DeNoronha",\n          "Brazil/East",\n          "Brazil/West",\n          "Canada/Atlantic",\n          "Canada/Central",\n          "Canada/Eastern",\n          "Canada/East-Saskatchewan",\n          "Canada/Mountain",\n          "Canada/Newfoundland",\n          "Canada/Pacific",\n          "Canada/Saskatchewan",\n          "Canada/Yukon",\n          "Chile/Continental",\n          "Chile/EasterIsland",\n          "Cuba",\n          "Egypt",\n          "Eire",\n          "Etc/GMT",\n          "Etc/GMT+0",\n          "Etc/UCT",\n          "Etc/Universal",\n          "Etc/UTC",\n          "Etc/Zulu",\n          "Europe/Amsterdam",\n          "Europe/Andorra",\n          "Europe/Athens",\n          "Europe/Belfast",\n          "Europe/Belgrade",\n          "Europe/Berlin",\n          "Europe/Bratislava",\n          "Europe/Brussels",\n          "Europe/Bucharest",\n          "Europe/Budapest",\n          "Europe/Busingen",\n          "Europe/Chisinau",\n          "Europe/Copenhagen",\n          "Europe/Dublin",\n          "Europe/Gibraltar",\n          "Europe/Guernsey",\n          "Europe/Helsinki",\n          "Europe/Isle_of_Man",\n          "Europe/Istanbul",\n          "Europe/Jersey",\n          "Europe/Kaliningrad",\n          "Europe/Kiev",\n          "Europe/Lisbon",\n          "Europe/Ljubljana",\n          "Europe/London",\n          "Europe/Luxembourg",\n          "Europe/Madrid",\n          "Europe/Malta",\n          "Europe/Mariehamn",\n          "Europe/Minsk",\n          "Europe/Monaco",\n          "Europe/Moscow",\n          "Europe/Nicosia",\n          "Europe/Oslo",\n          "Europe/Paris",\n          "Europe/Podgorica",\n          "Europe/Prague",\n          "Europe/Riga",\n          "Europe/Rome",\n          "Europe/Samara",\n          "Europe/San_Marino",\n          "Europe/Sarajevo",\n          "Europe/Simferopol",\n          "Europe/Skopje",\n          "Europe/Sofia",\n          "Europe/Stockholm",\n          "Europe/Tallinn",\n          "Europe/Tirane",\n          "Europe/Tiraspol",\n          "Europe/Uzhgorod",\n          "Europe/Vaduz",\n          "Europe/Vatican",\n          "Europe/Vienna",\n          "Europe/Vilnius",\n          "Europe/Volgograd",\n          "Europe/Warsaw",\n          "Europe/Zagreb",\n          "Europe/Zaporozhye",\n          "Europe/Zurich",\n          "GB",\n          "GB-Eire",\n          "GMT",\n          "GMT+0",\n          "GMT0",\n          "GMT-0",\n          "Greenwich",\n          "Hongkong",\n          "Iceland",\n          "Indian/Antananarivo",\n          "Indian/Chagos",\n          "Indian/Christmas",\n          "Indian/Cocos",\n          "Indian/Comoro",\n          "Indian/Kerguelen",\n          "Indian/Mahe",\n          "Indian/Maldives",\n          "Indian/Mauritius",\n          "Indian/Mayotte",\n          "Indian/Reunion",\n          "Iran",\n          "Israel",\n          "Jamaica",\n          "Japan",\n          "Kwajalein",\n          "Libya",\n          "Mexico/BajaNorte",\n          "Mexico/BajaSur",\n          "Mexico/General",\n          "Navajo",\n          "NZ",\n          "NZ-CHAT",\n          "Pacific/Apia",\n          "Pacific/Auckland",\n          "Pacific/Chatham",\n          "Pacific/Chuuk",\n          "Pacific/Easter",\n          "Pacific/Efate",\n          "Pacific/Enderbury",\n          "Pacific/Fakaofo",\n          "Pacific/Fiji",\n          "Pacific/Funafuti",\n          "Pacific/Galapagos",\n          "Pacific/Gambier",\n          "Pacific/Guadalcanal",\n          "Pacific/Guam",\n          "Pacific/Honolulu",\n          "Pacific/Johnston",\n          "Pacific/Kiritimati",\n          "Pacific/Kosrae",\n          "Pacific/Kwajalein",\n          "Pacific/Majuro",\n          "Pacific/Marquesas",\n          "Pacific/Midway",\n          "Pacific/Nauru",\n          "Pacific/Niue",\n          "Pacific/Norfolk",\n          "Pacific/Noumea",\n          "Pacific/Pago_Pago",\n          "Pacific/Palau",\n          "Pacific/Pitcairn",\n          "Pacific/Pohnpei",\n          "Pacific/Ponape",\n          "Pacific/Port_Moresby",\n          "Pacific/Rarotonga",\n          "Pacific/Saipan",\n          "Pacific/Samoa",\n          "Pacific/Tahiti",\n          "Pacific/Tarawa",\n          "Pacific/Tongatapu",\n          "Pacific/Truk",\n          "Pacific/Wake",\n          "Pacific/Wallis",\n          "Pacific/Yap",\n          "Poland",\n          "Portugal",\n          "PRC",\n          "ROC",\n          "ROK",\n          "Singapore",\n          "Turkey",\n          "UCT",\n          "Universal",\n          "US/Alaska",\n          "US/Aleutian",\n          "US/Arizona",\n          "US/Central",\n          "US/Eastern",\n          "US/East-Indiana",\n          "US/Hawaii",\n          "US/Indiana-Starke",\n          "US/Michigan",\n          "US/Mountain",\n          "US/Pacific",\n          "US/Samoa",\n          "UTC",\n          "W-SU",\n          "Zulu"\n        ]\n      }\n    }\n  },\n  "form": {\n    "column": {\n      "label": "name",\n      "source": "$ds1url/file-columns"\n    },\n    "tsExpression": {\n      "type": "textarea",\n      "className": "advanced hidden"\n    },\n    "datetimeFormat": {\n      "className": "advanced hidden"\n    },\n    "newDatetimeFormat": {\n      "className": "advanced hidden"\n    },\n    "timezone": {\n      "className": "advanced hidden"\n    }\n  }\n}	\N	2015-05-11 09:03:46.937	\N	2015-05-11 09:03:46.937	\N
32729	table-dataset	Schema for Table Dataset	{\n  "schema": {\n    "id": "$baseurl/form-schemas/table-dataset",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Table Dataset",\n    "description": "Schema for Table Dataset",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Dataset Name",\n        "type": "string"\n      },\n      "tableDataSource": {\n        "title": "Data Source",\n        "description": "Source of the dataset",\n        "type": "array",\n        "items": {\n          "$ref": "table-data-source.json"\n        }\n      },\n      "securityClassification": {\n        "title": "Security Classification",\n        "description": "Security classification of the dataset",\n        "type": "array",\n        "items": {\n          "$ref": "security-classification.json"\n        }\n      },\n      "namespace": {\n        "title": "Namespace",\n        "description": "Dataset namespace",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Dataset description",\n        "type": "string"\n      },\n      "comments": {\n        "title": "Comments",\n        "description": "Comments",\n        "type": "string"\n      },\n      "architectureDomain": {\n        "title": "Architecture Domain",\n        "description": "Architecture domain of dataset",\n        "type": "string"\n      },\n      "contactPerson": {\n        "title": "Contact Person",\n        "description": "Contact person",\n        "type": "string"\n      },\n      "customerData": {\n        "title": "Customer Data?",\n        "description": "Does the dataset contain customer data?",\n        "type": "boolean"\n      },\n      "financialBankingData": {\n        "title": "Financial and Banking Data?",\n        "description": "Does the dataset contain financial or banking data?",\n        "type": "boolean"\n      },\n      "idAndServiceHistory": {\n        "title": "ID and Service History?",\n        "description": "Does the dataset contain personal identifers or service history?",\n        "type": "boolean"\n      },\n      "creditCardData": {\n        "title": "Credit Card Data?",\n        "description": "Does the dataset contain credit card data?",\n        "type": "boolean"\n      },\n      "financialReportingData": {\n        "title": "Financial Reporting Data?",\n        "description": "Does the dataset contain financial reporting data?",\n        "type": "boolean"\n      },\n      "privacyData": {\n        "title": "Privacy Data?",\n        "description": "Does the dataset contain any data with privacy restrictions?",\n        "type": "boolean"\n      },\n      "regulatoryData": {\n        "title": "Regulatory Data?",\n        "description": "Does the dataset contain any regulatory data?",\n        "type": "boolean"\n      },\n      "nbnConfidentialData": {\n        "title": "NBN Confidential Data?",\n        "description": "Does the dataset contain any data with NBN confidentiality restrictions?",\n        "type": "boolean"\n      },\n      "nbnCompliant": {\n        "title": "NBN Compliant?",\n        "description": "Does the dataset contain any data that has NBN compliance requirements?",\n        "type": "boolean"\n      },\n      "ssuReady": {\n        "title": "SSU Ready",\n        "description": "SSU Ready",\n        "enum": ["RETAIL", "WHOLESALE", "CORP", "TRANS"]\n      },\n      "ssuRemediationMethod": {\n        "title": "SSU Remediation Method",\n        "description": "SSU remediation method",\n        "type": "string"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "tableDataSource": {\n      "label": "name",\n      "source": "$ds1url/table-data-sources"\n    },\n    "securityClassification": {\n      "label": "name",\n      "source": "$ds1url/security-classifications"\n    },\n    "description": {\n      "type": "textarea"\n    },\n    "comments": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-18 14:33:16.538	\N	2015-05-18 14:33:16.538	\N
32730	table-column	Schema for Table Column	{\n  "schema": {\n    "id": "$baseurl/form-schemas/table-column",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Table Column",\n    "description": "Schema for Table Column",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Name",\n        "type": "string"\n      },\n      "dataset": {\n        "title": "Dataset",\n        "description": "The dataset which the column belongs to.",\n        "type": "array",\n        "items": {\n          "$ref": "table-dataset.json"\n        }\n      },\n      "dataType": {\n        "title": "Data Type",\n        "description": "The data type of the column.",\n        "type": "array",\n        "items": {\n          "$ref": "data-type.json"\n        }\n      },\n      "columnIndex": {\n        "title": "Column Index",\n        "description": "Index (from 1) of the column in the dataset.",\n        "type": "integer"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Column description",\n        "type": "string"\n      },\n      "characterSet": {\n        "title": "Character Set",\n        "description": "The character set.",\n        "type": "string"\n      },\n      "collation": {\n        "title": "Collation",\n        "description": "The colation type.",\n        "type": "string"\n      },\n      "unique": {\n        "title": "Unique?",\n        "description": "Are column values unique?",\n        "type": "boolean"\n      },\n      "nullableType": {\n        "title": "Nullable Type",\n        "description": "The nullable type of the column.",\n        "enum": ["COLUMN_NO_NULLS", "COLUMN_NULLABLE", "COLUMN_NULLABLE_UNKNOWN"]\n      },\n      "length": {\n        "title": "Length",\n        "description": "Column length",\n        "type": "integer"\n      },\n      "defaultValue": {\n        "title": "Default Value",\n        "description": "The default value.",\n        "type": "string"\n      },\n      "autoinc": {\n        "title": "Auto-increment?",\n        "description": "Does the column have an auto-incrementing value?",\n        "type": "boolean"\n      },\n      "dimension": {\n        "title": "Dimension?",\n        "description": "Is the column a dimension?",\n        "type": "boolean"\n      },\n      "precision": {\n        "title": "Precision",\n        "description": "Number of significant digits of the numeric value.",\n        "type": "integer"\n      },\n      "scale": {\n        "title": "Scale",\n        "description": "Number of decimal places of the numeric value.",\n        "type": "integer"\n      },\n      "featureParamCandidate": {\n        "title": "Feature Parameter?",\n        "description": "Is the column a potential feature parameter?",\n        "type": "boolean"\n      },\n      "ignore": {\n        "title": "Ignore?",\n        "description": "Do not ingest this column?",\n        "type": "boolean"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "dataset": {\n      "label": "name",\n      "source": "$ds1url/table-datasets"\n    },\n    "dataType": {\n      "label": "name",\n      "source": "$ds1url/data-types"\n    },\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-18 14:33:38.847	\N	2015-05-18 14:33:38.847	\N
35774	xd-job	Schema for a Spring XD Job	{\n  "schema": {\n    "id": "$baseurl/form-schemas/xd-job",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Security Classification",\n    "description": "Schema for a Spring XD Job",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Job name",\n        "type": "string"\n      },\n      "jarLocation": {\n        "title": "JAR Location",\n        "description": "JAR location of custom module. Must be accessible from the Spring XD service.",\n        "type": "string"\n      },\n      "makeUnique": {\n        "title": "Make Unique?",\n        "description": "Must be set to false in production",\n        "type": "boolean"\n      }\n    }\n  },\n  "form": {\n  }\n}	\N	2015-05-25 20:02:43.094	\N	2015-05-25 20:02:43.094	\N
35775	stream	Schema for a Spring XD Stream Definition	{\n  "schema": {\n    "id": "$baseurl/form-schemas/stream",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Security Classification",\n    "description": "Schema for a Spring XD Stream Definition",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Stream name",\n        "type": "string"\n      },\n      "namespace": {\n        "title": "Namespace",\n        "description": "Namespace",\n        "type": "string"\n      },\n      "pollingDirectory": {\n        "title": "Polling Directory",\n        "description": "Directory to poll. Use Unix-style slashes '/'.",\n        "type": "string"\n      },\n      "filenamePattern": {\n        "title": "Filename pattern",\n        "description": "Filename pattern",\n        "type": "string"\n      },\n      "preventDuplicates": {\n        "title": "Prevent Duplicates?",\n        "description": "Do not ingest the same file",\n        "type": "boolean"\n      },\n      "job": {\n        "title": "Job",\n        "description": "Spring Batch Job to run",\n        "type": "string"\n      },\n      "definition": {\n        "title": "Or provide a definition",\n        "description": "Stream definition",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "definition": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-05-25 20:03:02.193	\N	2015-05-25 20:03:02.193	\N
41066	transformation	Schema for Transformation	{\n  "schema": {\n    "id": "$baseurl/form-schemas/transformation",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Transformation",\n    "description": "Schema for Transformation",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Transformation Name",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Transformation description",\n        "type": "string"\n      },\n      "inputDatasets": {\n        "title": "Input Datasets",\n        "description": "Datasets to be transformed.",\n        "type": "array",\n        "items": {\n          "$ref": "dataset.json"\n        }\n      },\n      "outputDataset": {\n        "title": "Output",\n        "description": "Dataset produced from the transformation",\n        "type": "array",\n        "items": {\n          "$ref": "dataset.json"\n        }\n      },\n      "language": {\n        "title": "Language",\n        "description": "Script language",\n        "enum": ["SQL", "PL/SQL", "R", "SAS", "Java", "Pig", "Spark", "ETL"]\n      },\n      "routine": {\n        "title": "Script",\n        "description": "Transformation script",\n        "type": "string"\n      },\n      "reference": {\n        "title": "Reference",\n        "description": "Reference to transformation code",\n        "type": "string"\n      },\n      "leadCommitter": {\n        "title": "Lead Committer",\n        "description": "Name of lead developer/analyst",\n        "type": "string"\n      },\n      "contactEmail": {\n        "title": "Contact Email",\n        "description": "Contact email of lead developer/analyst",\n        "type": "string"\n      },\n      "repo": {\n        "title": "Code Repository",\n        "description": "e.g. Git repository name",\n        "type": "string"\n      },\n      "commitHash": {\n        "title": "Commit Hash",\n        "description": "Commit Hash of current code release",\n        "type": "string"\n      },\n      "version": {\n        "title": "Version",\n        "description": "Version number",\n        "type": "integer"\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    },\n    "inputDatasets": {\n      "label": "name",\n      "source": "$ds1url/datasets",\n      "type": "multiselect"\n    },\n    "outputDataset": {\n      "label": "name",\n      "source": "$ds1url/datasets"\n    },\n    "routine": {\n      "type": "textarea",\n      "rows": 12\n    }\n  }\n}	\N	2015-06-09 09:00:40.731	\N	2015-06-09 09:00:40.731	\N
41870	Tag	Schema for a Tag	{\n  "schema": {\n    "id": "$baseurl/form-schemas/tag",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Tag",\n    "description": "Schema for a Tag",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Tag name",\n        "type": "string"\n      }\n    }\n  }\n}	\N	2015-07-26 19:11:24.34	\N	2015-07-26 19:11:24.34	\N
5	feature-type	Schema for a Feature Type	{\n  "schema": {\n    "id": "$baseurl/form-schemas/feature-type",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Type",\n    "description": "Schema for a Feature Type",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Feature Type name",\n        "type": "string"\n      },\n      "attributeType": {\n        "title": "Attribute Type",\n        "description": "Attribute Type",\n        "enum": ["BASE", "DERIVED", "SCORE"]\n      },\n      "status": {\n        "title": "Status",\n        "description": "Status",\n        "enum": ["DEV", "LAB", "FACTORY"]\n      },\n      "securityClassification": {\n        "title": "Security Classification",\n        "description": "Security classification of the feature.",\n        "type": "array",\n        "items": {\n          "$ref": "security-classification.json"\n        }\n      },\n      "customerIdType": {\n        "title": "Customer ID Type",\n        "description": "Customer ID Type.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-type.json"\n        }\n      },\n      "valueType": {\n        "title": "Value Type",\n        "description": "The value type of the feature.",\n        "type": "array",\n        "items": {\n          "$ref": "value-type.json"\n        }\n      },\n      "dataType": {\n        "title": "Data Type",\n        "description": "The data type of the feature.",\n        "type": "array",\n        "items": {\n          "$ref": "data-type.json"\n        }\n      },\n      "columnName": {\n        "title": "Column Name",\n        "description": "Column name in feature vector.",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Feature Type description",\n        "type": "string"\n      },\n      "referenceType": {\n        "title": "Reference Type",\n        "description": "Reference Type",\n        "enum": ["GIT"]\n      },\n      "reference": {\n        "title": "Reference",\n        "description": "Feature Type reference",\n        "type": "string"\n      },\n      "authorName": {\n        "title": "Author name",\n        "description": "Name of author",\n        "type": "string"\n      },\n      "authorEmail": {\n        "title": "Author email",\n        "description": "Author's email",\n        "type": "string"\n      },\n      "dbname": {\n        "title": "Database/Schema",\n        "description": "Database or Schema name",\n        "type": "string"\n      },\n      "language": {\n        "title": "Language",\n        "description": "Feature gen language",\n        "enum": ["JAVA", "PYTHON", "R", "SCALA", "SQL"]\n      },\n      "expression": {\n        "title": "Expression",\n        "description": "Feature gen code",\n        "type": "string"\n      },\n      "featureFamilies": {\n        "title": "Families",\n        "description": "Feature Families",\n        "type": "array",\n        "items": {\n          "$ref": "feature-family.json"\n        }\n      },\n      "tags": {\n        "title": "Tags",\n        "description": "Tags",\n        "type": "array",\n        "items": {\n          "$ref": "tag.json"\n        }\n      },\n      "dependencies": {\n        "title": "Dependencies",\n        "description": "Dependent features.",\n        "type": "array",\n        "items": {\n          "$ref": "feature-type.json"\n        }\n      }\n    }\n  },\n  "form": {\n    "securityClassification": {\n      "label": "name",\n      "source": "$ds1url/security-classifications"\n    },\n    "customerIdType": {\n      "label": "name",\n      "source": "$ds1url/customer-id-types"\n    },\n    "valueType": {\n      "label": "name",\n      "source": "$ds1url/value-types"\n    },\n    "dataType": {\n      "label": "name",\n      "source": "$ds1url/data-types"\n    },\n    "description": {\n      "type": "textarea"\n    },\n    "expression": {\n      "type": "textarea",\n      "rows": 12\n    },\n    "featureFamilies": {\n      "label": "name",\n      "source": "$ds1url/feature-families",\n      "type": "multiselect"\n    },\n    "tags": {\n      "label": "name",\n      "source": "$ds1url/tags",\n      "type": "multiselect"\n    },\n    "dependencies": {\n      "label": "name",\n      "source": "$ds1url/feature-types",\n      "type": "multiselect"\n    },\n    "tabbedLayout": [\n      {\n        "id": "basic",\n        "title": "Basic",\n        "fields": ["name", "featureFamilies", "attributeType", "customerIdType", "valueType", "dataType", "columnName", "dbname", "language", "expression"]\n      },\n      {\n        "id": "business",\n        "title": "Business",\n        "fields": ["securityClassification", "description", "referenceType", "reference", "authorName", "authorEmail", "tags"]\n      },\n      {\n        "id": "process",\n        "title": "Process",\n        "fields": ["status", "dependencies"]\n      },\n      {\n        "id": "test",\n        "title": "Test Cases",\n        "fields": []\n      }\n    ]\n  }\n}	\N	2015-04-03 21:24:36.148	\N	2015-07-27 22:51:47.319	\N
41869	feature-family	Schema for a Feature Family	{\n  "schema": {\n    "id": "$baseurl/form-schemas/feature-family",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Family",\n    "description": "Schema for a Feature Family",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Feature Family name",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Feature Type description",\n        "type": "string"\n      },\n      "wideTableName": {\n        "title": "Wide Table Name",\n        "description": "Wide Table Name",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-07-26 19:11:07.693	\N	2015-07-28 00:22:21.928	\N
41876	model	Schema for an Analytical Model	{\n  "schema": {\n    "id": "$baseurl/form-schemas/model",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Family",\n    "description": "Schema for an Analytical Model",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Model name",\n        "type": "string"\n      },\n      "version": {\n        "title": "Version",\n        "description": "Model version",\n        "type": "string"\n      },\n      "ensemble": {\n        "title": "Ensemble?",\n        "description": "Is the model an ensemble model?",\n        "type": "boolean"\n      },\n      "committer": {\n        "title": "Committer",\n        "description": "Model committer",\n        "type": "string"\n      },\n      "contactPerson": {\n        "title": "Contact",\n        "description": "Contact person name",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Model description",\n        "type": "string"\n      },\n      "packages": {\n        "title": "Packages",\n        "description": "Dependent packages",\n        "type": "array",\n        "items": {\n          "$ref": "model-package.json"\n        }\n      },\n      "relatedModels": {\n        "title": "Related Models",\n        "description": "Related models",\n        "type": "array",\n        "items": {\n          "$ref": "model.json"\n        }\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    },\n    "packages": {\n      "label": "name",\n      "source": "$ds1url/model-packages",\n      "type": "multiselect"\n    },\n    "relatedModels": {\n      "label": "name",\n      "source": "$ds1url/models",\n      "type": "multiselect"\n    }\n  }\n}	\N	2015-08-01 11:46:34.998	\N	2015-08-01 11:52:20.39	\N
41872	feature-test	Schema for a Feature Test	{\n  "schema": {\n    "id": "$baseurl/form-schemas/feature-test",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Family",\n    "description": "Schema for a Feature Test",\n    "type": "object",\n    "properties": {\n      "featureType": {\n        "title": "Feature Type",\n        "description": "Feature Type",\n        "type": "array",\n        "items": {\n          "$ref": "feature-type.json"\n        }\n      },\n      "description": {\n        "title": "Description",\n        "description": "Description of feature test case",\n        "type": "string"\n      },\n      "status": {\n        "title": "Status",\n        "description": "Test case status",\n        "enum": ["DEV", "LAB", "FACTORY"]\n      },\n      "dbname": {\n        "title": "Database/Schema",\n        "description": "Database or Schema name",\n        "type": "string"\n      },\n      "evalExpression": {\n        "title": "Eval expression",\n        "description": "Code / expression to test an assertion",\n        "type": "string"\n      },\n      "whereExpression": {\n        "title": "WHERE clause",\n        "description": "Code / expression to specify the constraints of the assertion.",\n        "type": "string"\n      },\n      "authorName": {\n        "title": "Author name",\n        "description": "Name of author",\n        "type": "string"\n      },\n      "authorEmail": {\n        "title": "Author email",\n        "description": "Author's email",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "featureType": {\n      "label": "name",\n      "source": "$ds1url/feature-types"\n    },\n    "evalExpression": {\n      "type": "textarea"\n    },\n    "whereExpression": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-07-28 00:11:52.231	\N	2015-07-28 00:20:19.911	\N
11	file-dataset	Schema for File Dataset	{\n  "schema": {\n    "id": "$baseurl/form-schemas/file-dataset",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "File Dataset",\n    "description": "Schema for File Dataset",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Dataset Name",\n        "type": "string"\n      },\n      "fileType": {\n        "title": "Type of file",\n        "description": "Type of file",\n        "enum": ["DELIMITED", "JSON", "FIXED", "MULTIRECORD"]\n      },\n      "eventTypes": {\n        "title": "Event Types",\n        "description": "Event Types generated from this dataset.",\n        "type": "array",\n        "items": {\n          "$ref": "event-type.json"\n        }\n      },\n      "customerIdMappingRules": {\n        "title": "Customer ID Mapping Rules",\n        "description": "Customer ID mappings generated from this dataset.",\n        "type": "array",\n        "items": {\n          "$ref": "customer-id-mapping-rule.json"\n        }\n      },\n      "fileDataSource": {\n        "title": "Data Source",\n        "description": "Source of the dataset",\n        "type": "array",\n        "items": {\n          "$ref": "file-data-source.json"\n        }\n      },\n      "naturalKeyColumns": {\n        "title": "Natural Key",\n        "description": "The columns that make up the natural key",\n        "type": "array",\n        "items": {\n          "$ref": "file-column.json"\n        }\n      },\n      "securityClassification": {\n        "title": "Security Classification",\n        "description": "Security classification of the dataset",\n        "type": "array",\n        "items": {\n          "$ref": "security-classification.json"\n        }\n      },\n      "namespace": {\n        "title": "Namespace",\n        "description": "Dataset namespace",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Dataset description",\n        "type": "string"\n      },\n      "comments": {\n        "title": "Comments",\n        "description": "Comments",\n        "type": "string"\n      },\n      "architectureDomain": {\n        "title": "Architecture Domain",\n        "description": "Architecture domain of dataset",\n        "type": "string"\n      },\n      "contactPerson": {\n        "title": "Contact Person",\n        "description": "Contact person",\n        "type": "string"\n      },\n      "customerData": {\n        "title": "Customer Data?",\n        "description": "Does the dataset contain customer data?",\n        "type": "boolean"\n      },\n      "financialBankingData": {\n        "title": "Financial and Banking Data?",\n        "description": "Does the dataset contain financial or banking data?",\n        "type": "boolean"\n      },\n      "idAndServiceHistory": {\n        "title": "ID and Service History?",\n        "description": "Does the dataset contain personal identifers or service history?",\n        "type": "boolean"\n      },\n      "creditCardData": {\n        "title": "Credit Card Data?",\n        "description": "Does the dataset contain credit card data?",\n        "type": "boolean"\n      },\n      "financialReportingData": {\n        "title": "Financial Reporting Data?",\n        "description": "Does the dataset contain financial reporting data?",\n        "type": "boolean"\n      },\n      "privacyData": {\n        "title": "Privacy Data?",\n        "description": "Does the dataset contain any data with privacy restrictions?",\n        "type": "boolean"\n      },\n      "regulatoryData": {\n        "title": "Regulatory Data?",\n        "description": "Does the dataset contain any regulatory data?",\n        "type": "boolean"\n      },\n      "nbnConfidentialData": {\n        "title": "NBN Confidential Data?",\n        "description": "Does the dataset contain any data with NBN confidentiality restrictions?",\n        "type": "boolean"\n      },\n      "nbnCompliant": {\n        "title": "NBN Compliant?",\n        "description": "Does the dataset contain any data that has NBN compliance requirements?",\n        "type": "boolean"\n      },\n      "ssuReady": {\n        "title": "SSU Ready",\n        "description": "SSU Ready",\n        "enum": ["RETAIL", "WHOLESALE", "CORP", "TRANS"]\n      },\n      "ssuRemediationMethod": {\n        "title": "SSU Remediation Method",\n        "description": "SSU remediation method",\n        "type": "string"\n      },\n      "availableHistoryUnitOfTime": {\n        "title": "Historical data available (Unit of time)",\n        "description": "Unit of time for historical data if available.",\n        "enum": ["HOUR", "DAY", "WEEK", "MONTH", "YEAR"]\n      },\n      "availableHistoryUnits": {\n        "title": "Historical data available (number of units)",\n        "description": "Number of units of time of historical data if available.",\n        "type": "integer"\n      },\n      "historyDataSizeGb": {\n        "title": "Historical data size (Gb)",\n        "description": "Size of historical data in Gb.",\n        "type": "integer"\n      },\n      "refreshDataSizeGb": {\n        "title": "Data refresh size (Gb)",\n        "description": "Data refresh size in Gb.",\n        "type": "integer"\n      },\n      "batch": {\n        "title": "Batch?",\n        "description": "Is data received in batch?",\n        "type": "boolean"\n      },\n      "refreshFrequencyUnitOfTime": {\n        "title": "Data refresh frequency (Unit of time)",\n        "description": "Unit of time for data refresh cycles.",\n        "enum": ["HOUR", "DAY", "WEEK", "MONTH", "YEAR"]\n      },\n      "refreshFrequencyUnits": {\n        "title": "Data refresh frequency (number of units)",\n        "description": "Number of units of time between data refresh cycles.",\n        "type": "integer"\n      },\n      "timeOfDayDataAvailable": {\n        "title": "New data available (Time of day)",\n        "description": "Time of day when new data will be available.",\n        "type": "time"\n      },\n      "dataAvailableDaysOfWeek": {\n        "title": "New data available (Days of week - comma separated, Sun = 0)",\n        "description": "Days of week when new data will be available.",\n        "type": "time"\n      },\n      "dataLatencyUnitOfTime": {\n        "title": "Data latency (Unit of time)",\n        "description": "Unit of time for data latency.",\n        "enum": ["HOUR", "DAY", "WEEK", "MONTH", "YEAR"]\n      },\n      "dataLatencyUnits": {\n        "title": "Data latency (number of units)",\n        "description": "Number of units of time for data latency.",\n        "type": "integer"\n      },\n      "columnDelimiter": {\n        "title": "Column Delimiter (default is ',')",\n        "description": "Column delimiter",\n        "type": "string"\n      },\n      "headerRow": {\n        "title": "Header Row?",\n        "description": "Does the dataset have a header row?",\n        "type": "boolean"\n      },\n      "footerRow": {\n        "title": "Footer Row?",\n        "description": "Does the dataset have a footer row?",\n        "type": "boolean"\n      },\n      "rowDelimiter": {\n        "title": "Row Delimiter (default is newline character)",\n        "description": "Row delimiter",\n        "type": "string"\n      },\n      "textQualifier": {\n        "title": "Text Qualifier (default is double quotes)",\n        "description": "Text qualifier",\n        "type": "string"\n      },\n      "compressionType": {\n        "title": "Compression Type",\n        "description": "Type of file compression used.",\n        "enum": ["NONE", "ZIP", "GZ", "TAR", "TAR_GZ", "SEVEN_ZIP"]\n      }\n    },\n    "required": ["name"]\n  },\n  "form": {\n    "eventTypes": {\n      "label": "name",\n      "source": "$ds1url/event-types",\n      "type": "multiselect"\n    },\n    "naturalKeyColumns": {\n      "label": "name",\n      "source": "$ds1url/file-columns",\n      "type": "multiselect"\n    },\n    "customerIdMappingRules": {\n      "label": "name",\n      "source": "$ds1url/customer-id-mapping-rules",\n      "type": "multiselect"\n    },\n    "fileDataSource": {\n      "label": "name",\n      "source": "$ds1url/file-data-sources"\n    },\n    "securityClassification": {\n      "label": "name",\n      "source": "$ds1url/security-classifications"\n    },\n    "description": {\n      "type": "textarea"\n    },\n    "comments": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-04-03 21:25:35.233	\N	2015-07-30 10:49:24.524	\N
41877	model-package	Schema for a Model Package	{\n  "schema": {\n    "id": "$baseurl/form-schemas/model-package",\n    "$schema": "http://json-schema.org/schema#",\n    "name": "Feature Family",\n    "description": "Schema for a Model Package",\n    "type": "object",\n    "properties": {\n      "name": {\n        "title": "Name",\n        "description": "Package name",\n        "type": "string"\n      },\n      "version": {\n        "title": "Version",\n        "description": "Package version",\n        "type": "string"\n      },\n      "description": {\n        "title": "Description",\n        "description": "Package description",\n        "type": "string"\n      }\n    }\n  },\n  "form": {\n    "description": {\n      "type": "textarea"\n    }\n  }\n}	\N	2015-08-01 11:46:51.785	\N	2015-08-01 11:46:51.785	\N
\.


--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('form_schemas_form_schema_id_seq', 41877, true);


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('hibernate_sequence', 41939, true);


--
-- Data for Name: id_mapping_rules_datasets; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY id_mapping_rules_datasets (id, customer_id_mapping_rule_id, dataset_id, created_ts) FROM stdin;
\.


--
-- Name: id_mapping_rules_datasets_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('id_mapping_rules_datasets_id_seq', 1, true);


--
-- Data for Name: key_values; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY key_values (key, value, value_type, created_ts) FROM stdin;
numberDatasets	0	\N	2015-07-13 09:14:32.206191
start	1970-01-01T00:00:00.000	\N	2015-07-13 09:14:32.263572
totalEventsByType	{}	\N	2015-07-13 09:14:32.266261
totalEvents	0	\N	2015-07-13 09:14:32.273473
totalRecordsProcessed	0	\N	2015-07-13 09:14:32.27676
end	2015-07-12T23:59:59.000	\N	2015-07-13 09:14:32.278902
flow	{"nodes":[],"links":[]}	\N	2015-05-19 09:19:46.924438
totalEventsByDay	{}	\N	2015-07-13 09:14:32.268697
totalEventsByMonth	{}	\N	2015-07-13 09:14:32.271147
\.


--
-- Data for Name: metric_values; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY metric_values (analysis_type_id, metric_id, column_id, numeric_value, string_value, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY metrics (metric_id, metric_name, description) FROM stdin;
41892	75th percentile	\N
41893	Row count	\N
41894	Lowest value	\N
41895	Variance	\N
41896	Highest value	\N
41897	Skewness	\N
41898	Sum	\N
41899	Median	\N
41900	Standard deviation	\N
41901	Kurtosis	\N
41902	25th percentile	\N
41903	Geometric mean	\N
41904	Second moment	\N
41905	Null count	\N
41906	Mean	\N
41907	Sum of squares	\N
41908	Highest date	\N
41909	Lowest date	\N
41910	Lowest time	\N
41911	Highest time	\N
41912	Total char count	\N
41913	Word count	\N
41914	Min chars	\N
41915	Uppercase chars	\N
41916	Entirely uppercase count	\N
41917	Entirely lowercase count	\N
41918	Min words	\N
41919	Diacritic chars	\N
41920	Max words	\N
41921	Non-letter chars	\N
41922	Blank count	\N
41923	Max chars	\N
41924	Digit chars	\N
41925	Min white spaces	\N
41926	Lowercase chars	\N
41927	Uppercase chars (excl. first letters)	\N
41928	Avg white spaces	\N
41929	Max white spaces	\N
41930	Avg chars	\N
41931	Top 5	\N
41932	False count	\N
41933	True count	\N
41934	matchCount	\N
41935	sample	\N
41936	Completeness	\N
41937	Distinct values	\N
41938	Distinct values count	\N
41939	Uniqueness	\N
\.


--
-- Name: metrics_metric_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('metrics_metric_id_seq', 1, false);


--
-- Data for Name: model_packages_link; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY model_packages_link (model_id, package_id) FROM stdin;
41891	41878
\.


--
-- Data for Name: natural_key; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY natural_key (dataset_id, column_id) FROM stdin;
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY queries (query_id, columns, created_ts, primary_table, query, tables, username) FROM stdin;
3816	\N	2015-05-04 09:49:17.15	\N	SELECT t.event_type, count(*)\nFROM cxp.events e\nJOIN cxp.event_types t ON t.event_type_id = e.event_type_id\nGROUP BY t.event_type\nORDER BY t.event_type;	\N	mark
4931	\N	2015-05-04 10:35:38.768	\N	SELECT job_id, count(*)\nFROM meta.err_events\nGROUP BY job_id;	\N	mark
29866	\N	2015-05-11 16:42:27.538	\N	select * from cxp.events where job_id = (select job_id from cxp.jobs order by job_id desc limit 1) limit 500	\N	Oliver
29867	\N	2015-05-11 16:44:32.023	\N	select count(*) from cxp.events where job_id = (select job_id from cxp.jobs order by job_id desc limit 1) limit 500	\N	Oliver
32441	\N	2015-05-12 15:42:08.401	\N	select * meta.err_events where job_id = 32440	\N	Oliver
32442	\N	2015-05-12 15:42:17.099	\N	select * from meta.err_events where job_id = 32440	\N	Oliver
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY records (record_id, dataset_id, record_name, prefix, description, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: records_record_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('records_record_id_seq', 1, true);


--
-- Data for Name: related_analytical_models; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY related_analytical_models (model_id_1, model_id_2) FROM stdin;
\.


--
-- Data for Name: security_classifications; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY security_classifications (security_classification_id, security_classification_name, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
4	Restricted	\N	2015-04-03 21:27:30.142	\N	2015-04-03 21:27:30.142	\N
3	Protected	\N	2015-04-03 21:27:21.591	\N	2015-04-03 21:27:21.591	\N
2	Confidential	\N	2015-04-03 21:27:15.887	\N	2015-04-03 21:27:15.887	\N
1	Unclassified	\N	2015-04-03 21:27:04.812	\N	2015-04-03 21:27:04.812	\N
5	Public	\N	2015-04-03 21:27:38.568	\N	2015-04-03 21:27:38.568	\N
\.


--
-- Name: security_classifications_security_classification_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('security_classifications_security_classification_id_seq', 5, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY settings (name, created_ts, created_by, modified_ts, modified_by, process_name, value, description) FROM stdin;
scripts-dir	2015-06-01 11:07:15.372	\N	2015-06-01 11:07:15.372	\N	\N	/home/users/mark/scripts/	\N
sftp-host	2015-06-10 09:18:50.014	\N	2015-06-10 09:18:50.014	\N	\N	10.47.124.151	\N
date-formats	2015-05-04 11:51:55.102	\N	2015-07-01 10:49:22.206	\N	\N	yyyy-MM-dd'T'HH:mm:ss.SSSZ\nyyyy-MM-dd'T'HH:mm:ss.SSSXXX\nyyyy-MM-dd'T'HH:mm:ss.SSSSSS\nyyyy-MM-dd HH:mm:ss.SSSZ\nyyyy-MM-dd HH:mm:ss.SSSXXX\nyyyy-MM-dd HH:mm:ss.SSSSSS\nyyyyMMdd HH:mm:ss\nEEE, MMM d, ''yy\nEEE, MMM d, yyyy\nyyyy.MM.dd\nyyyy-MM-dd\nyyyy/MM/dd\ndd.MM.yyyy\ndd-MM-yyyy\ndd/MM/yyyy\nMM.dd.yyyy\nMM-dd-yyyy\nMM/dd/yyyy\ndd.MM.yy\ndd-MM-yy\ndd/MM/yy\nMM.dd.yy\nMM-dd-yy\nMM/dd/yy\ndd/MMM/yy\nyyyy-MM-dd\nyyyy-MM-dd'T'HH\nyyyy-MM-dd HH\nyyyy-MM-dd'T'HH:mm\nyyyy-MM-dd HH:mm\nyyyy-MM-dd'T'HH:mm:ss\nyyyy-MM-dd HH:mm:ss\nyyyy-MM-dd'T'HH:mm:ss.SSS\nyyyy-MM-dd HH:mm:ss.SSS\nyyyy-MM-dd'T'HH:mm:ss Z\nyyyy-MM-dd HH:mm:ss Z\nyyyyMMdd:HH:mm:ss\ndd-MMM-yy\nyyyy-MM-dd HH:mm:ss zzz\n|yyyy-MM-dd\ndd/MM/yyyy HH:mm:ss\ndd/MM/yyyy HH:mm:ss.SSSSSS\nddMMMyyyy	\N
spring-xd-api	2015-05-25 19:52:13.657	\N	2015-07-20 22:50:32.019	\N	\N	http://localhost:9393/	\N
local-landing-dir	2015-06-10 09:21:56.277	\N	2015-07-20 22:51:06.74	\N	\N	/Users/postgres/data/cxp/in	\N
\.


--
-- Data for Name: streams; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY streams (stream_id, stream_name, namespace, polling_directory, filename_pattern, prevent_duplicates, job, definition, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: streams_stream_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('streams_stream_id_seq', 41830, true);


--
-- Data for Name: tags; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY tags (tag_id, tag_name) FROM stdin;
300	My Tag
\.


--
-- Name: tags_tag_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('tags_tag_id_seq', 10, true);


--
-- Data for Name: transformations; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY transformations (transformation_id, transformation_name, output_dataset_id, routine, reference, language, lead_committer, contact_email, repo, commit_hash, version, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: transformations_transformation_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('transformations_transformation_id_seq', 1, true);


--
-- Data for Name: transformed_sets; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY transformed_sets (transformation_id, dataset_id) FROM stdin;
\.


--
-- Data for Name: value_types; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY value_types (value_type_id, value_type_name, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
3	NUMERIC	\N	2015-04-06 16:43:04.409	\N	2015-04-06 16:43:04.409	\N
7	BIT	\N	2015-04-06 16:43:25.606	\N	2015-04-06 16:43:25.606	\N
4	STRING	\N	2015-04-06 16:43:09.776	\N	2015-04-06 16:43:09.776	\N
8	TEXT	\N	2015-04-06 16:43:30.195	\N	2015-04-06 16:43:30.195	\N
2	INTEGER	\N	2015-04-06 16:42:56.235	\N	2015-04-06 16:42:56.235	\N
6	BOOLEAN	\N	2015-04-06 16:43:20.677	\N	2015-04-06 16:43:20.677	\N
1	NONE	\N	2015-04-06 16:42:51.051	\N	2015-04-06 16:42:51.051	\N
5	DATE	\N	2015-04-06 16:43:14.637	\N	2015-04-06 16:43:14.637	\N
18668	OBJECT	\N	2015-05-11 09:05:04.047	\N	2015-05-11 09:05:04.047	\N
18669	ARRAY	\N	2015-05-11 09:05:08.901	\N	2015-05-11 09:05:08.901	\N
\.


--
-- Name: value_types_value_type_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('value_types_value_type_id_seq', 18669, true);


--
-- Data for Name: xdjobs; Type: TABLE DATA; Schema: meta; Owner: postgres
--

COPY xdjobs (job_id, job_name, jar_location, make_unique, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: xdjobs_job_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: postgres
--

SELECT pg_catalog.setval('xdjobs_job_id_seq', 1, true);


SET search_path = metaform, pg_catalog;

--
-- Data for Name: form_schemas; Type: TABLE DATA; Schema: metaform; Owner: postgres
--

COPY form_schemas (form_schema_id, form_schema_name, description, json_schema, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
50	param-group	Schema for a Param Group	99981	\N	2015-08-29 18:12:55.724	\N	2015-08-29 18:12:55.724	\N
\.


--
-- Name: form_schemas_form_schema_id_seq; Type: SEQUENCE SET; Schema: metaform; Owner: postgres
--

SELECT pg_catalog.setval('form_schemas_form_schema_id_seq', 50, true);


SET search_path = profiler, pg_catalog;

--
-- Data for Name: data_sources; Type: TABLE DATA; Schema: profiler; Owner: postgres
--

COPY data_sources (data_source_id, data_source_type, data_source_name, sourcing_method, hostname, ipaddr, port, network, file_path, filename_pattern, database_name, connection_url, catalog_name, schema_name, table_name, view_name, query, api_url, firewall_status, description, process_name, created_ts, created_by, modified_ts, modified_by) FROM stdin;
\.


--
-- Name: data_sources_data_source_id_seq; Type: SEQUENCE SET; Schema: profiler; Owner: postgres
--

SELECT pg_catalog.setval('data_sources_data_source_id_seq', 1, true);


--
-- Data for Name: BLOBS; Type: BLOBS; Schema: -; Owner:
--

SET search_path = pg_catalog;

BEGIN;

SELECT pg_catalog.lo_open('99981', 131072);
SELECT pg_catalog.lowrite(0, '\x7b202022736368656d61223a207b20202020226964223a2022246261736575726c2f666f726d2d736368656d61732f706172616d2d67726f7570222c202020202224736368656d61223a2022687474703a2f2f6a736f6e2d736368656d612e6f72672f736368656d6123222c20202020226e616d65223a2022506172616d2047726f7570222c20202020226465736372697074696f6e223a2022536368656d6120666f72206120506172616d2047726f7570222c202020202274797065223a20226f626a656374222c202020202270726f70657274696573223a207b202020202020226e616d65223a207b2020202020202020227469746c65223a20224e616d65222c2020202020202020226465736372697074696f6e223a2022506172616d2047726f7570204e616d65222c20202020202020202274797065223a2022737472696e67222020202020207d2c202020202020226465736372697074696f6e223a207b2020202020202020227469746c65223a20224465736372697074696f6e222c2020202020202020226465736372697074696f6e223a2022506172616d2047726f7570204465736372697074696f6e222c20202020202020202274797065223a2022737472696e67222020202020207d202020207d20207d2c202022666f726d223a207b20202020226465736372697074696f6e223a207b2020202020202274797065223a2022746578746172656122202020207d20207d7d');
SELECT pg_catalog.lo_close(0);

COMMIT;

SET search_path = cxp, pg_catalog;

--
-- Name: customer_id_mapping_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_mapping_pk PRIMARY KEY (id);


--
-- Name: customer_id_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT customer_id_types_pk PRIMARY KEY (customer_id_type_id);


--
-- Name: event_properties_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_properties
    ADD CONSTRAINT event_properties_pk PRIMARY KEY (customer_id_type_id, customer_id, event_type_id, ts, event_version, property_type_id, version);


--
-- Name: event_property_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT event_property_types_pk PRIMARY KEY (property_type_id);


--
-- Name: event_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT event_types_pk PRIMARY KEY (event_type_id);


--
-- Name: jobs_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pk PRIMARY KEY (job_id);


--
-- Name: jobs_test_pk; Type: CONSTRAINT; Schema: cxp; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY jobs_test
    ADD CONSTRAINT jobs_test_pk PRIMARY KEY (job_id);


SET search_path = gcfr_meta, pg_catalog;

--
-- Name: bkey_key_sets_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY bkey_key_sets
    ADD CONSTRAINT bkey_key_sets_pk PRIMARY KEY (key_set_id);


--
-- Name: character_sets_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY character_sets
    ADD CONSTRAINT character_sets_pk PRIMARY KEY (character_set_id);


--
-- Name: columns_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY columns
    ADD CONSTRAINT columns_pk PRIMARY KEY (column_id);


--
-- Name: param_groups_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY param_groups
    ADD CONSTRAINT param_groups_pk PRIMARY KEY (param_group_id);


--
-- Name: params_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY params
    ADD CONSTRAINT params_pk PRIMARY KEY (param_id);


--
-- Name: process_types_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY process_types
    ADD CONSTRAINT process_types_pk PRIMARY KEY (process_type_id);


--
-- Name: settings_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (name);


--
-- Name: source_column_mapping_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY source_column_mapping
    ADD CONSTRAINT source_column_mapping_pk PRIMARY KEY (transform_mapping_id, column_id);


--
-- Name: source_systems_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY source_systems
    ADD CONSTRAINT source_systems_pk PRIMARY KEY (source_system_id);


--
-- Name: streams_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY streams
    ADD CONSTRAINT streams_pk PRIMARY KEY (stream_id);


--
-- Name: subject_areas_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY subject_areas
    ADD CONSTRAINT subject_areas_pk PRIMARY KEY (subject_area_id);


--
-- Name: tables_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY tables
    ADD CONSTRAINT tables_pk PRIMARY KEY (table_id);


--
-- Name: transform_mapping_pk; Type: CONSTRAINT; Schema: gcfr_meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY transform_mapping
    ADD CONSTRAINT transform_mapping_pk PRIMARY KEY (transform_mapping_id);


SET search_path = meta, pg_catalog;

--
-- Name: analysis_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY analysis_types
    ADD CONSTRAINT analysis_types_pk PRIMARY KEY (analysis_type_id);


--
-- Name: analytical_model_packages_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY analytical_model_packages
    ADD CONSTRAINT analytical_model_packages_pk PRIMARY KEY (package_id);


--
-- Name: analytical_models_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY analytical_models
    ADD CONSTRAINT analytical_models_pk PRIMARY KEY (model_id);


--
-- Name: column_profile_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY column_profile
    ADD CONSTRAINT column_profile_pk PRIMARY KEY (column_id, profile_ts);


--
-- Name: column_tags_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY column_tags
    ADD CONSTRAINT column_tags_pk PRIMARY KEY (column_id, tag_id);


--
-- Name: comments_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pk PRIMARY KEY (comment_id);


--
-- Name: cust_property_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT cust_property_types_columns_pk PRIMARY KEY (id);


--
-- Name: customer_id_mapping_rules_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_mapping_rules_pk PRIMARY KEY (customer_id_mapping_rule_id);


--
-- Name: customer_ids_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customer_ids_pk PRIMARY KEY (customer_surrogate_key, customer_id_type_id);


--
-- Name: customer_properties_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customer_properties_pk PRIMARY KEY (customer_surrogate_key, property_type_id);


--
-- Name: customer_property_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT customer_property_types_pk PRIMARY KEY (property_type_id);


--
-- Name: customers_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (customer_surrogate_key);


--
-- Name: data_column_comments_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY data_column_comments
    ADD CONSTRAINT data_column_comments_pk PRIMARY KEY (column_id, comment_id);


--
-- Name: data_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT data_columns_pk PRIMARY KEY (column_id);


--
-- Name: data_sources_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY data_sources
    ADD CONSTRAINT data_sources_pk PRIMARY KEY (data_source_id);


--
-- Name: data_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY data_types
    ADD CONSTRAINT data_types_pk PRIMARY KEY (data_type_id);


--
-- Name: datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pk PRIMARY KEY (dataset_id);


--
-- Name: event_property_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT event_property_types_columns_pk PRIMARY KEY (id);


--
-- Name: event_type_relationship_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_type_relationship_pk PRIMARY KEY (source_event_type_id, target_event_type_id, event_type_reln_type_id);


--
-- Name: event_type_reln_type_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_type_reln_type
    ADD CONSTRAINT event_type_reln_type_pk PRIMARY KEY (event_type_reln_type_id);


--
-- Name: event_types_columns_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT event_types_columns_pk PRIMARY KEY (id);


--
-- Name: event_types_cust_id_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT event_types_cust_id_types_pk PRIMARY KEY (event_type_id, customer_id_type_id);


--
-- Name: event_types_datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT event_types_datasets_pk PRIMARY KEY (id);


--
-- Name: event_types_records_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT event_types_records_pk PRIMARY KEY (id);


--
-- Name: feature_families_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_families
    ADD CONSTRAINT feature_families_pk PRIMARY KEY (feature_family_id);


--
-- Name: feature_family_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_family_types
    ADD CONSTRAINT feature_family_types_pk PRIMARY KEY (feature_family_id, feature_type_id);


--
-- Name: feature_test_results_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_test_results
    ADD CONSTRAINT feature_test_results_pk PRIMARY KEY (feature_test_id, run_ts);


--
-- Name: feature_tests_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_tests
    ADD CONSTRAINT feature_tests_pk PRIMARY KEY (feature_test_id);


--
-- Name: feature_type_dependencies_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_type_dependencies
    ADD CONSTRAINT feature_type_dependencies_pk PRIMARY KEY (dependent_feature_type_id, independent_feature_type_id);


--
-- Name: feature_type_tags_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_type_tags
    ADD CONSTRAINT feature_type_tags_pk PRIMARY KEY (feature_type_id, tag_id);


--
-- Name: feature_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT feature_types_pk PRIMARY KEY (feature_type_id);


--
-- Name: form_schemas_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY form_schemas
    ADD CONSTRAINT form_schemas_pk PRIMARY KEY (form_schema_id);


--
-- Name: id_mapping_rules_datasets_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT id_mapping_rules_datasets_pk PRIMARY KEY (id);


--
-- Name: key_values_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY key_values
    ADD CONSTRAINT key_values_pk PRIMARY KEY (key);


--
-- Name: metric_values_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY metric_values
    ADD CONSTRAINT metric_values_pk PRIMARY KEY (analysis_type_id, metric_id, column_id);


--
-- Name: metrics_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY metrics
    ADD CONSTRAINT metrics_pk PRIMARY KEY (metric_id);


--
-- Name: model_packages_link_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY model_packages_link
    ADD CONSTRAINT model_packages_link_pk PRIMARY KEY (model_id, package_id);


--
-- Name: natural_key_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY natural_key
    ADD CONSTRAINT natural_key_pk PRIMARY KEY (dataset_id, column_id);


--
-- Name: queries_pkey; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (query_id);


--
-- Name: records_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY records
    ADD CONSTRAINT records_pk PRIMARY KEY (record_id);


--
-- Name: related_analytical_models_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY related_analytical_models
    ADD CONSTRAINT related_analytical_models_pk PRIMARY KEY (model_id_1, model_id_2);


--
-- Name: security_classifications_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY security_classifications
    ADD CONSTRAINT security_classifications_pk PRIMARY KEY (security_classification_id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (name);


--
-- Name: streams_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY streams
    ADD CONSTRAINT streams_pk PRIMARY KEY (stream_id);


--
-- Name: tags_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pk PRIMARY KEY (tag_id);


--
-- Name: transformations_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY transformations
    ADD CONSTRAINT transformations_pk PRIMARY KEY (transformation_id);


--
-- Name: transformed_sets_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY transformed_sets
    ADD CONSTRAINT transformed_sets_pk PRIMARY KEY (transformation_id, dataset_id);


--
-- Name: value_types_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY value_types
    ADD CONSTRAINT value_types_pk PRIMARY KEY (value_type_id);


--
-- Name: xdjobs_pk; Type: CONSTRAINT; Schema: meta; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY xdjobs
    ADD CONSTRAINT xdjobs_pk PRIMARY KEY (job_id);


SET search_path = metaform, pg_catalog;

--
-- Name: form_schemas_pk; Type: CONSTRAINT; Schema: metaform; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY form_schemas
    ADD CONSTRAINT form_schemas_pk PRIMARY KEY (form_schema_id);


SET search_path = profiler, pg_catalog;

--
-- Name: data_sources_pk; Type: CONSTRAINT; Schema: profiler; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY data_sources
    ADD CONSTRAINT data_sources_pk PRIMARY KEY (data_source_id);


SET search_path = cxp, pg_catalog;

--
-- Name: customer_id_types_customer_id_mapping_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_types_customer_id_mapping_fk FOREIGN KEY (customer_id_type_id_1) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_mapping_fk1; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_types_customer_id_mapping_fk1 FOREIGN KEY (customer_id_type_id_2) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT customer_id_types_customer_id_types_fk FOREIGN KEY (parent_id) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_event_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT customer_id_types_event_types_fk FOREIGN KEY (customer_id_type_id1) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_event_types_fk1; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT customer_id_types_event_types_fk1 FOREIGN KEY (customer_id_type_id2) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY events
    ADD CONSTRAINT customer_id_types_events_fk FOREIGN KEY (customer_id_type_id) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: data_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT data_types_customer_id_types_fk FOREIGN KEY (data_type_id) REFERENCES meta.data_types(data_type_id);


--
-- Name: datasets_jobs_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT datasets_jobs_fk FOREIGN KEY (dataset_id) REFERENCES meta.datasets(dataset_id);


--
-- Name: dictionary_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY events
    ADD CONSTRAINT dictionary_events_fk FOREIGN KEY (event_type_id) REFERENCES event_types(event_type_id);


--
-- Name: jobs_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY events
    ADD CONSTRAINT jobs_events_fk FOREIGN KEY (job_id) REFERENCES jobs(job_id);


--
-- Name: property_types_event_properties_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_properties
    ADD CONSTRAINT property_types_event_properties_fk FOREIGN KEY (property_type_id) REFERENCES event_property_types(property_type_id);


--
-- Name: security_classification_event_property_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT security_classification_event_property_types_fk FOREIGN KEY (security_classification_id) REFERENCES meta.security_classifications(security_classification_id);


--
-- Name: value_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT value_types_customer_id_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


--
-- Name: value_types_event_property_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT value_types_event_property_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


--
-- Name: value_types_event_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: postgres
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT value_types_event_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


SET search_path = gcfr_meta, pg_catalog;

--
-- Name: param_groups_params_fk; Type: FK CONSTRAINT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY params
    ADD CONSTRAINT param_groups_params_fk FOREIGN KEY (param_group_id) REFERENCES param_groups(param_group_id);


--
-- Name: process_types_params_fk; Type: FK CONSTRAINT; Schema: gcfr_meta; Owner: postgres
--

ALTER TABLE ONLY params
    ADD CONSTRAINT process_types_params_fk FOREIGN KEY (process_type_id) REFERENCES process_types(process_type_id);


SET search_path = meta, pg_catalog;

--
-- Name: columns_column_profile_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY column_profile
    ADD CONSTRAINT columns_column_profile_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_cust_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT columns_cust_property_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_event_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT columns_event_property_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: columns_event_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT columns_event_types_columns_fk FOREIGN KEY (column_id) REFERENCES data_columns(column_id);


--
-- Name: customer_id_types_customer_id_mapping_rules_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk FOREIGN KEY (customer_id_type_id_1) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_mapping_rules_fk1; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_id_mapping_rules
    ADD CONSTRAINT customer_id_types_customer_id_mapping_rules_fk1 FOREIGN KEY (customer_id_type_id_2) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_ids_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customer_id_types_customer_ids_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customers_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customer_id_types_customers_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_data_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT customer_id_types_data_columns_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_events_types_cust_id_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT customer_id_types_events_types_cust_id_types_fk FOREIGN KEY (customer_id_type_id) REFERENCES cxp.customer_id_types(customer_id_type_id);


--
-- Name: customer_property_types_cust_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY cust_property_types_columns
    ADD CONSTRAINT customer_property_types_cust_property_types_columns_fk FOREIGN KEY (property_type_id) REFERENCES customer_property_types(property_type_id);


--
-- Name: customer_property_types_customer_properties_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customer_property_types_customer_properties_fk FOREIGN KEY (property_type_id) REFERENCES customer_property_types(property_type_id);


--
-- Name: customers_customer_ids_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_ids
    ADD CONSTRAINT customers_customer_ids_fk FOREIGN KEY (customer_surrogate_key) REFERENCES customers(customer_surrogate_key);


--
-- Name: customers_customer_properties_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_properties
    ADD CONSTRAINT customers_customer_properties_fk FOREIGN KEY (customer_surrogate_key) REFERENCES customers(customer_surrogate_key);


--
-- Name: data_source_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT data_source_datasets_fk FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id);


--
-- Name: data_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT data_types_columns_fk FOREIGN KEY (data_type_id) REFERENCES data_types(data_type_id);


--
-- Name: datasets_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT datasets_columns_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_event_types_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT datasets_event_types_datasets_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_event_types_records_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT datasets_event_types_records_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: datasets_record_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY records
    ADD CONSTRAINT datasets_record_fk FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: event_property_types_event_property_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_property_types_columns
    ADD CONSTRAINT event_property_types_event_property_types_columns_fk FOREIGN KEY (property_type_id) REFERENCES cxp.event_property_types(property_type_id);


--
-- Name: event_type_reln_type_event_type_relationship_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_type_reln_type_event_type_relationship_fk FOREIGN KEY (event_type_reln_type_id) REFERENCES event_type_reln_type(event_type_reln_type_id);


--
-- Name: event_types_event_type_relationship_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_types_event_type_relationship_fk FOREIGN KEY (source_event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_type_relationship_fk1; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_type_relationship
    ADD CONSTRAINT event_types_event_type_relationship_fk1 FOREIGN KEY (target_event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_columns
    ADD CONSTRAINT event_types_event_types_columns_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_datasets
    ADD CONSTRAINT event_types_event_types_datasets_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_event_types_records_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT event_types_event_types_records_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: event_types_events_types_cust_id_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_cust_id_types
    ADD CONSTRAINT event_types_events_types_cust_id_types_fk FOREIGN KEY (event_type_id) REFERENCES cxp.event_types(event_type_id);


--
-- Name: fk_2qfky6vn731w1rnue87wi7y9a; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT fk_2qfky6vn731w1rnue87wi7y9a FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id);


--
-- Name: fk_2rfnqh233dbj06iihuk2x73pq; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY event_types_records
    ADD CONSTRAINT fk_2rfnqh233dbj06iihuk2x73pq FOREIGN KEY (record_id) REFERENCES records(record_id);


--
-- Name: fk_dhmesj1d60poxvx4tptgh5wtm; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY id_mapping_rules_datasets
    ADD CONSTRAINT fk_dhmesj1d60poxvx4tptgh5wtm FOREIGN KEY (customer_id_mapping_rule_id) REFERENCES customer_id_mapping_rules(customer_id_mapping_rule_id);


--
-- Name: record_data_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT record_data_columns_fk FOREIGN KEY (record_id) REFERENCES records(record_id);


--
-- Name: security_classification_customer_property_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT security_classification_customer_property_types_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: security_classification_datasets_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT security_classification_datasets_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: security_classification_feature_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT security_classification_feature_types_fk FOREIGN KEY (security_classification_id) REFERENCES security_classifications(security_classification_id);


--
-- Name: value_types_columns_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY data_columns
    ADD CONSTRAINT value_types_columns_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: value_types_customer_property_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY customer_property_types
    ADD CONSTRAINT value_types_customer_property_types_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: value_types_feature_types_fk; Type: FK CONSTRAINT; Schema: meta; Owner: postgres
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT value_types_feature_types_fk FOREIGN KEY (value_type_id) REFERENCES value_types(value_type_id);


--
-- Name: cxp; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA cxp FROM PUBLIC;
REVOKE ALL ON SCHEMA cxp FROM postgres;
GRANT ALL ON SCHEMA cxp TO postgres;


--
-- Name: meta; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA meta FROM PUBLIC;
REVOKE ALL ON SCHEMA meta FROM postgres;
GRANT ALL ON SCHEMA meta TO postgres;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


SET search_path = cxp, pg_catalog;

--
-- Name: events; Type: ACL; Schema: cxp; Owner: postgres
--

REVOKE ALL ON TABLE events FROM PUBLIC;
REVOKE ALL ON TABLE events FROM postgres;
GRANT ALL ON TABLE events TO postgres;


--
-- Name: jobs_test; Type: ACL; Schema: cxp; Owner: postgres
--

REVOKE ALL ON TABLE jobs_test FROM PUBLIC;
REVOKE ALL ON TABLE jobs_test FROM postgres;
GRANT ALL ON TABLE jobs_test TO postgres;


SET search_path = meta, pg_catalog;

--
-- Name: err_events; Type: ACL; Schema: meta; Owner: postgres
--

REVOKE ALL ON TABLE err_events FROM PUBLIC;
REVOKE ALL ON TABLE err_events FROM postgres;
GRANT ALL ON TABLE err_events TO postgres;


--
-- Name: key_values; Type: ACL; Schema: meta; Owner: postgres
--

REVOKE ALL ON TABLE key_values FROM PUBLIC;
REVOKE ALL ON TABLE key_values FROM postgres;
GRANT ALL ON TABLE key_values TO postgres;
GRANT ALL ON TABLE key_values TO postgres;


--
-- Name: natural_key; Type: ACL; Schema: meta; Owner: postgres
--

REVOKE ALL ON TABLE natural_key FROM PUBLIC;
REVOKE ALL ON TABLE natural_key FROM postgres;
GRANT ALL ON TABLE natural_key TO postgres;
GRANT ALL ON TABLE natural_key TO postgres;


--
-- Name: streams; Type: ACL; Schema: meta; Owner: postgres
--

REVOKE ALL ON TABLE streams FROM PUBLIC;
REVOKE ALL ON TABLE streams FROM postgres;
GRANT ALL ON TABLE streams TO postgres;


--
-- Name: xdjobs; Type: ACL; Schema: meta; Owner: postgres
--

REVOKE ALL ON TABLE xdjobs FROM PUBLIC;
REVOKE ALL ON TABLE xdjobs FROM postgres;
GRANT ALL ON TABLE xdjobs TO postgres;


--
-- PostgreSQL database dump complete
--
