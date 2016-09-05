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
-- Name: cxp; Type: SCHEMA; Schema: -; Owner: cxp
--

CREATE SCHEMA cxp;


ALTER SCHEMA cxp OWNER TO cxp;

SET search_path = cxp, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customer_id_mapping; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_id_mapping (
    id bigint NOT NULL,
    customer_id_type_id_1 integer NOT NULL,
    customer_id_1 character varying NOT NULL,
    customer_id_type_id_2 integer NOT NULL,
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


ALTER TABLE customer_id_mapping OWNER TO cxp;

--
-- Name: customer_id_mapping_id_seq; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE customer_id_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_mapping_id_seq OWNER TO cxp;

--
-- Name: customer_id_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE customer_id_mapping_id_seq OWNED BY customer_id_mapping.id;


--
-- Name: customer_id_types; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE customer_id_types (
    customer_id_type_id integer NOT NULL,
    customer_id_type_name character varying(50) NOT NULL,
    description character varying,
    composite boolean,
    composition_rule text,
    parent_id integer,
    data_type_id integer,
    value_type_id integer,
    created_ts timestamp without time zone,
    created_by character varying(50),
    modified_ts timestamp without time zone,
    modified_by character varying(50),
    process_name character varying(255),
    marked_for_deletion boolean
);


ALTER TABLE customer_id_types OWNER TO cxp;

--
-- Name: customer_id_types_cust_id_type_id_seq_1_2_2_1; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE customer_id_types_cust_id_type_id_seq_1_2_2_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_types_cust_id_type_id_seq_1_2_2_1 OWNER TO cxp;

--
-- Name: customer_id_types_cust_id_type_id_seq_1_2_2_1; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE customer_id_types_cust_id_type_id_seq_1_2_2_1 OWNED BY customer_id_types.customer_id_type_id;


--
-- Name: event_properties; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE event_properties (
    customer_id_type_id integer NOT NULL,
    customer_id character varying(100) NOT NULL,
    event_type_id integer NOT NULL,
    ts timestamp without time zone NOT NULL,
    event_version integer NOT NULL,
    property_type_id integer NOT NULL,
    version integer NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE event_properties OWNER TO cxp;

--
-- Name: COLUMN event_properties.customer_id; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN event_properties.customer_id IS 'Natural customer id in dataset.';


--
-- Name: COLUMN event_properties.ts; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN event_properties.ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';


--
-- Name: event_property_types; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
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
    modified_by character varying(50)
);


ALTER TABLE event_property_types OWNER TO cxp;

--
-- Name: event_property_types_property_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE event_property_types_property_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_property_types_property_type_id_seq OWNER TO cxp;

--
-- Name: event_property_types_property_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE event_property_types_property_type_id_seq OWNED BY event_property_types.property_type_id;


--
-- Name: event_types; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE event_types (
    event_type_id integer NOT NULL,
    namespace character varying,
    event_type character varying NOT NULL,
    event_subtype character varying,
    description character varying,
    value_type_id integer,
    customer_id_type_id1 integer,
    customer_id_expression1 text,
    customer_id_type_id2 integer,
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
    marked_for_deletion boolean
);


ALTER TABLE event_types OWNER TO cxp;

--
-- Name: COLUMN event_types.event_type; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN event_types.event_type IS 'Should be intuitive to a human.';


--
-- Name: COLUMN event_types.event_value_desc; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN event_types.event_value_desc IS 'To support Dimitri''s work. Describes what the event value (comment) represents.';


--
-- Name: event_types_event_type_id_seq; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE event_types_event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_types_event_type_id_seq OWNER TO cxp;

--
-- Name: event_types_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE event_types_event_type_id_seq OWNED BY event_types.event_type_id;


--
-- Name: events; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE events (
    customer_id_type_id integer NOT NULL,
    customer_id character varying(100) NOT NULL,
    event_type_id integer NOT NULL,
    event_ts timestamp without time zone NOT NULL,
    event_version integer NOT NULL,
    value text,
    job_id bigint,
    process_name character varying(100),
    created_ts timestamp without time zone,
    event_property text,
    source_key text
);


ALTER TABLE events OWNER TO cxp;

--
-- Name: COLUMN events.customer_id; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN events.customer_id IS 'Natural customer id in dataset.';


--
-- Name: COLUMN events.event_ts; Type: COMMENT; Schema: cxp; Owner: cxp
--

COMMENT ON COLUMN events.event_ts IS 'with time zone

See http://www.postgresql.org/docs/9.4/static/datatype-datetime.html';


--
-- Name: events_test; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
--

CREATE TABLE events_test (
    customer_id_type_id integer,
    customer_id character varying(100),
    event_type_id integer,
    ts timestamp without time zone,
    event_version integer,
    value text,
    job_id bigint,
    process_name character varying(100),
    created_ts timestamp without time zone
);


ALTER TABLE events_test OWNER TO cxp;

--
-- Name: jobs; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
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


ALTER TABLE jobs OWNER TO cxp;

--
-- Name: jobs_job_id_seq_1_1; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE jobs_job_id_seq_1_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_job_id_seq_1_1 OWNER TO cxp;

--
-- Name: jobs_job_id_seq_1_1; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE jobs_job_id_seq_1_1 OWNED BY jobs.job_id;


--
-- Name: jobs_test; Type: TABLE; Schema: cxp; Owner: cxp; Tablespace: 
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
    errors_logged bigint,
    modified_ts timestamp without time zone
);


ALTER TABLE jobs_test OWNER TO cxp;

--
-- Name: jobs_test_job_id_seq_1_1; Type: SEQUENCE; Schema: cxp; Owner: cxp
--

CREATE SEQUENCE jobs_test_job_id_seq_1_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_test_job_id_seq_1_1 OWNER TO cxp;

--
-- Name: jobs_test_job_id_seq_1_1; Type: SEQUENCE OWNED BY; Schema: cxp; Owner: cxp
--

ALTER SEQUENCE jobs_test_job_id_seq_1_1 OWNED BY jobs_test.job_id;


--
-- Name: id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping ALTER COLUMN id SET DEFAULT nextval('customer_id_mapping_id_seq'::regclass);


--
-- Name: customer_id_type_id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_types ALTER COLUMN customer_id_type_id SET DEFAULT nextval('customer_id_types_cust_id_type_id_seq_1_2_2_1'::regclass);


--
-- Name: property_type_id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_property_types ALTER COLUMN property_type_id SET DEFAULT nextval('event_property_types_property_type_id_seq'::regclass);


--
-- Name: event_type_id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_types ALTER COLUMN event_type_id SET DEFAULT nextval('event_types_event_type_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY jobs ALTER COLUMN job_id SET DEFAULT nextval('jobs_job_id_seq_1_1'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY jobs_test ALTER COLUMN job_id SET DEFAULT nextval('jobs_test_job_id_seq_1_1'::regclass);


--
-- Name: customer_id_mapping_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_mapping_pk PRIMARY KEY (id);


--
-- Name: customer_id_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT customer_id_types_pk PRIMARY KEY (customer_id_type_id);


--
-- Name: event_properties_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_properties
    ADD CONSTRAINT event_properties_pk PRIMARY KEY (customer_id_type_id, customer_id, event_type_id, ts, event_version, property_type_id, version);


--
-- Name: event_property_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT event_property_types_pk PRIMARY KEY (property_type_id);


--
-- Name: event_types_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT event_types_pk PRIMARY KEY (event_type_id);


--
-- Name: jobs_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pk PRIMARY KEY (job_id);


--
-- Name: jobs_test_pk; Type: CONSTRAINT; Schema: cxp; Owner: cxp; Tablespace: 
--

ALTER TABLE ONLY jobs_test
    ADD CONSTRAINT jobs_test_pk PRIMARY KEY (job_id);


--
-- Name: customer_id_types_customer_id_mapping_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_types_customer_id_mapping_fk FOREIGN KEY (customer_id_type_id_1) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_mapping_fk1; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_mapping
    ADD CONSTRAINT customer_id_types_customer_id_mapping_fk1 FOREIGN KEY (customer_id_type_id_2) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT customer_id_types_customer_id_types_fk FOREIGN KEY (parent_id) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_event_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT customer_id_types_event_types_fk FOREIGN KEY (customer_id_type_id1) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_event_types_fk1; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT customer_id_types_event_types_fk1 FOREIGN KEY (customer_id_type_id2) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: customer_id_types_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY events
    ADD CONSTRAINT customer_id_types_events_fk FOREIGN KEY (customer_id_type_id) REFERENCES customer_id_types(customer_id_type_id);


--
-- Name: data_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT data_types_customer_id_types_fk FOREIGN KEY (data_type_id) REFERENCES meta.data_types(data_type_id);


--
-- Name: datasets_jobs_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT datasets_jobs_fk FOREIGN KEY (dataset_id) REFERENCES meta.datasets(dataset_id);


--
-- Name: dictionary_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY events
    ADD CONSTRAINT dictionary_events_fk FOREIGN KEY (event_type_id) REFERENCES event_types(event_type_id);


--
-- Name: jobs_events_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY events
    ADD CONSTRAINT jobs_events_fk FOREIGN KEY (job_id) REFERENCES jobs(job_id);


--
-- Name: property_types_event_properties_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_properties
    ADD CONSTRAINT property_types_event_properties_fk FOREIGN KEY (property_type_id) REFERENCES event_property_types(property_type_id);


--
-- Name: security_classification_event_property_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT security_classification_event_property_types_fk FOREIGN KEY (security_classification_id) REFERENCES meta.security_classifications(security_classification_id);


--
-- Name: value_types_customer_id_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY customer_id_types
    ADD CONSTRAINT value_types_customer_id_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


--
-- Name: value_types_event_property_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_property_types
    ADD CONSTRAINT value_types_event_property_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


--
-- Name: value_types_event_types_fk; Type: FK CONSTRAINT; Schema: cxp; Owner: cxp
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT value_types_event_types_fk FOREIGN KEY (value_type_id) REFERENCES meta.value_types(value_type_id);


--
-- Name: cxp; Type: ACL; Schema: -; Owner: cxp
--

REVOKE ALL ON SCHEMA cxp FROM PUBLIC;
REVOKE ALL ON SCHEMA cxp FROM cxp;
GRANT ALL ON SCHEMA cxp TO cxp;


--
-- Name: events; Type: ACL; Schema: cxp; Owner: cxp
--

REVOKE ALL ON TABLE events FROM PUBLIC;
REVOKE ALL ON TABLE events FROM cxp;
GRANT ALL ON TABLE events TO cxp;


--
-- Name: jobs_test; Type: ACL; Schema: cxp; Owner: cxp
--

REVOKE ALL ON TABLE jobs_test FROM PUBLIC;
REVOKE ALL ON TABLE jobs_test FROM cxp;
GRANT ALL ON TABLE jobs_test TO cxp;


--
-- PostgreSQL database dump complete
--

