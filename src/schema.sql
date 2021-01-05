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
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE parameters (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL,
    units character varying NOT NULL
);

--
-- Name: types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE types (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: zones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE zones (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL,
    description text
);
--
-- Name: timeseries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timeseries (
    id bigserial NOT NULL PRIMARY KEY,
    zone_id integer references zones(id),
    location_id integer references locations(id),
    parameter_id integer references parameters(id),
    type_id integer references types(id),
    interval_id integer references intervals(id),
    duration_id integer references intervals(id),
    version character varying,	

	UNIQUE (zone_id, location_id, parameter_id, type_id, interval_id, duration_id, version)
);


--
-- Name: catalog_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW catalog_view AS
    SELECT ts.id, 
			(SELECT zones.name FROM zones WHERE (zones.id = ts.zone_id)) AS zone, 
			(SELECT locations.name FROM locations WHERE (locations.id = ts.location_id)) AS location, 
			(SELECT parameters.name FROM parameters WHERE (parameters.id = ts.parameter_id)) AS parameter, 
			(SELECT types.name FROM types WHERE (types.id = ts.type_id)) AS type, 
			(SELECT intervals.name FROM intervals WHERE (intervals.id = ts.interval_id)) AS "interval",
			(SELECT intervals.name FROM intervals WHERE (intervals.id = ts.duration_id)) AS duration,
			ts.version 
	FROM 
		timeseries ts			
	;


--
-- Name: catalog; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW catalog AS
    SELECT catalog_view.id, (((((((((((((catalog_view.zone)::text || '.'::text) || (catalog_view.location)::text) || '.'::text) || (catalog_view.parameter)::text) || '.'::text) || (catalog_view.type)::text) || '.'::text) || (catalog_view."interval")::text) || '.'::text) || (catalog_view.duration)::text) || '.'::text) || (catalog_view.version)::text) AS timeseries_name, catalog_view.zone, catalog_view.location, catalog_view.parameter, catalog_view.type, catalog_view."interval", catalog_view.duration, catalog_view.version FROM catalog_view;


CREATE TABLE timeseries_values (
	timeseries_id bigint references timeseries(id) not null,
    date_time timestamp with time zone not null,    
    value double precision,
    quality integer,

	PRIMARY KEY ( timeseries_id,date_time )
);

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;




