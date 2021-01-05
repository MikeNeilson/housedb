--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;



SET search_path = public, pg_catalog;

--
-- Name: data_triple; Type: TYPE; Schema: public; Owner: -
--
CREATE role housedb_owner;
CREATE role housedb_user;
CREATE DATABASE housedb OWNER housedb_owner;
SET SESSION AUTHORIZATION housedb_owner;
\c housedb

CREATE TYPE data_triple AS (
	date_time timestamp with time zone,
	value double precision,
	quality integer
);

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: intervals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE intervals (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE parameters (
    id integer NOT NULL,
    name character varying NOT NULL,
    units character varying NOT NULL
);


--
-- Name: timeseries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timeseries (
    id bigint NOT NULL,
    zone integer,
    location integer,
    parameter integer,
    type integer,
    "interval" integer,
    duration integer,
    version character varying
);


--
-- Name: types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE types (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: zones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE zones (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text
);


--
-- Name: catalog_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW catalog_view AS
    SELECT ts.id, (SELECT zones.name FROM zones WHERE (zones.id = ts.zone)) AS zone, (SELECT locations.name FROM locations WHERE (locations.id = ts.location)) AS location, (SELECT parameters.name FROM parameters WHERE (parameters.id = ts.parameter)) AS parameter, (SELECT types.name FROM types WHERE (types.id = ts.type)) AS type, (SELECT intervals.name FROM intervals WHERE (intervals.id = ts."interval")) AS "interval", (SELECT intervals.name FROM intervals WHERE (intervals.id = ts.duration)) AS duration, ts.version FROM timeseries ts;


--
-- Name: catalog; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW catalog AS
    SELECT catalog_view.id, (((((((((((((catalog_view.zone)::text || '.'::text) || (catalog_view.location)::text) || '.'::text) || (catalog_view.parameter)::text) || '.'::text) || (catalog_view.type)::text) || '.'::text) || (catalog_view."interval")::text) || '.'::text) || (catalog_view.duration)::text) || '.'::text) || (catalog_view.version)::text) AS timeseries_name, catalog_view.zone, catalog_view.location, catalog_view.parameter, catalog_view.type, catalog_view."interval", catalog_view.duration, catalog_view.version FROM catalog_view;


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE parameters_id_seq OWNED BY parameters.id;


--
-- Name: timeseries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timeseries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timeseries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timeseries_id_seq OWNED BY timeseries.id;


--
-- Name: timeseries_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timeseries_values (
    date_time timestamp with time zone,
    timeseries_id bigint,
    value double precision,
    quality integer
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE types_id_seq OWNED BY types.id;


--
-- Name: zones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zones_id_seq OWNED BY zones.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY parameters ALTER COLUMN id SET DEFAULT nextval('parameters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries ALTER COLUMN id SET DEFAULT nextval('timeseries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY types ALTER COLUMN id SET DEFAULT nextval('types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zones ALTER COLUMN id SET DEFAULT nextval('zones_id_seq'::regclass);


--
-- Name: interval_unique_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY intervals
    ADD CONSTRAINT interval_unique_name UNIQUE (name);


--
-- Name: intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY intervals
    ADD CONSTRAINT intervals_pkey PRIMARY KEY (id);


--
-- Name: location_unique_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT location_unique_name UNIQUE (name);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: parameters_unique_name_units; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY parameters
    ADD CONSTRAINT parameters_unique_name_units UNIQUE (name, units);


--
-- Name: timeseries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_pkey PRIMARY KEY (id);


--
-- Name: timeseries_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_unique UNIQUE (zone, location, parameter, type, "interval", duration, version);


--
-- Name: tsv_date_time_code_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timeseries_values
    ADD CONSTRAINT tsv_date_time_code_unique UNIQUE (date_time, timeseries_id);


--
-- Name: types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: types_unique_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY types
    ADD CONSTRAINT types_unique_name UNIQUE (name);


--
-- Name: zones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (id);


--
-- Name: zones_unique_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT zones_unique_name UNIQUE (name);


--
-- Name: tsid_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tsid_time ON timeseries_values USING btree (timeseries_id, date_time);


--
-- Name: timeseries_duration_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_duration_fkey FOREIGN KEY (duration) REFERENCES intervals(id);


--
-- Name: timeseries_interval_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_interval_fkey FOREIGN KEY ("interval") REFERENCES intervals(id);


--
-- Name: timeseries_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_location_fkey FOREIGN KEY (location) REFERENCES locations(id);


--
-- Name: timeseries_parameter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_parameter_fkey FOREIGN KEY (parameter) REFERENCES parameters(id);


--
-- Name: timeseries_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_type_fkey FOREIGN KEY (type) REFERENCES types(id);


--
-- Name: timeseries_values_timeseries_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries_values
    ADD CONSTRAINT timeseries_values_timeseries_id_fkey FOREIGN KEY (timeseries_id) REFERENCES timeseries(id);


--
-- Name: timeseries_zone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_zone_fkey FOREIGN KEY (zone) REFERENCES zones(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;




