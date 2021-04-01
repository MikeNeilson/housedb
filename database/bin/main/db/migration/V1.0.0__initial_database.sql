--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;



SET search_path = public, pg_catalog;

--
--CREATE role housedb_owner;
--CREATE DATABASE housedb OWNER housedb_owner;
--SET SESSION AUTHORIZATION housedb_owner;

--
-- Name: data_triple; Type: TYPE; Schema: housedb; Owner: -
--
CREATE TYPE housedb.data_triple AS (
	date_time timestamp with time zone,
	value double precision,
	quality integer
);

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: intervals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.intervals (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.locations (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.parameters (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL,
    units character varying NOT NULL
);

--
-- Name: types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.types (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);


--
-- Name: zones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.zones (
    id bigserial NOT NULL PRIMARY KEY,
    name character varying NOT NULL,
    description text
);
--
-- Name: timeseries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE housedb.timeseries (
    id bigserial NOT NULL PRIMARY KEY,
    zone_id integer references housedb.zones(id),
    location_id integer references housedb.locations(id),
    parameter_id integer references housedb.parameters(id),
    type_id integer references housedb.types(id),
    interval_id integer references housedb.intervals(id),
    duration_id integer references housedb.intervals(id),
    version character varying,	

	UNIQUE (zone_id, location_id, parameter_id, type_id, interval_id, duration_id, version)
);


--
-- Name: catalog_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW housedb.catalog_view AS
    SELECT ts.id, 
			(SELECT zones.name FROM housedb.zones zones WHERE (zones.id = ts.zone_id)) AS zone, 
			(SELECT locations.name FROM housedb.locations locations WHERE (locations.id = ts.location_id)) AS location, 
			(SELECT parameters.name FROM housedb.parameters parameters WHERE (parameters.id = ts.parameter_id)) AS parameter, 
			(SELECT types.name FROM housedb.types types WHERE (types.id = ts.type_id)) AS type, 
			(SELECT intervals.name FROM housedb.intervals intervals WHERE (intervals.id = ts.interval_id)) AS "interval",
			(SELECT intervals.name FROM housedb.intervals intervals WHERE (intervals.id = ts.duration_id)) AS duration,
			ts.version 
	FROM 
		housedb.timeseries ts			
	;


--
-- Name: catalog; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW housedb.catalog AS
    SELECT catalog_view.id, (((((((((((((catalog_view.zone)::text || '.'::text) || (catalog_view.location)::text) || '.'::text) || (catalog_view.parameter)::text) || '.'::text) || (catalog_view.type)::text) || '.'::text) || (catalog_view."interval")::text) || '.'::text) || (catalog_view.duration)::text) || '.'::text) || (catalog_view.version)::text) AS timeseries_name, catalog_view.zone, catalog_view.location, catalog_view.parameter, catalog_view.type, catalog_view."interval", catalog_view.duration, catalog_view.version FROM housedb.catalog_view;


CREATE TABLE housedb.timeseries_values (
	timeseries_id bigint references housedb.timeseries(id) not null,
    date_time timestamp with time zone not null,    
    value double precision,
    quality integer,

	PRIMARY KEY ( timeseries_id,date_time )
);

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA housedb TO housedb_user;

-- Initial Data

insert into housedb.types (name) values 
('Inst'),
('Ave'),
('Min'),
('Max'),
('Total'),
('Accum');

insert into housedb.intervals(name) VALUES
('0'),
('15Minutes'),
('1Hour'),
('1Day');

insert into housedb.parameters(name,units) values 
('Moisture','%'),
('Precip','in'),
('temp-Air','degC'),
('Temp-Soil','degC');
