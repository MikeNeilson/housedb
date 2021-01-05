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


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: plpythonu; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpythonu;


SET search_path = public, pg_catalog;

--
-- Name: data_triple; Type: TYPE; Schema: public; Owner: -
--
CREATE role housedb_owner;
CREATE DATABASE housedb OWNER housedb_owner;
\c housedb
GRANT CREATE TABLE,TYPE,PROCEDURE to housedb_owner;
SET SESSION AUTHORIZATION housedb_owner;


CREATE TYPE data_triple AS (
	date_time timestamp with time zone,
	value double precision,
	quality integer
);


--
-- Name: create_timeseries(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION create_timeseries(ts_name character varying) RETURNS bigint
    LANGUAGE plpythonu
    AS $_$
if 'check_catalog' in SD:
	check_catalog = SD["check_catalog"]
	add_ts = SD["add_ts"]
else:
	check_catalog = plpy.prepare( "select id from catalog where upper($1)=upper(timeseries_name)", ["varchar",] )
	add_ts = plpy.prepare( "insert into timeseries(zone,location,parameter,type,interval,duration,version) values($1,$2,$3,$4,$5,$6,$7)", ["int", "int", "int", "int", "int", "int", "varchar"])
	SD["check_catalog"] = check_catalog
	SD["add_ts"] = add_ts


result = plpy.execute(check_catalog, [ts_name,] )
if result.nrows() > 0:
	return result[0]["id"]
else:
	plpy.log("creating new time series: " + ts_name );
	# now we build a new one
	zone,location,parameter,type,interval,duration,version = ts_name.split('.')
	
	# check for the zone
	plpy.log("Checking for zone '%s'" % zone )
	result = plpy.execute( "select id from zones where upper(name)=upper(%s)" % plpy.quote_literal(zone) )
	plpy.log("Number of Rows: " + str(result.nrows() ) )	
	if result.nrows() == 1:
		plpy.debug( "Using existing zone" )
		zone_id = result[0]["id"]
	else:
		plpy.log( "Creating new zone: " + zone )
		result = plpy.execute("insert into zones(name) values( %s )" % plpy.quote_literal( zone ) )
		# now get the id we just created
		result = plpy.execute( "select id from zones where upper(name)=upper(%s)" % plpy.quote_literal(zone) )
		zone_id = result[0]["id"]
		plpy.log("new zone id: " + str(zone_id) )

	plpy.log("Checking for Location '%s'" % location )
	result = plpy.execute( "select id from locations where upper(name)=upper(%s)" % plpy.quote_literal(location) )
	if result.nrows() == 1:
		plpy.debug( "Using existing zone" )
		location_id = result[0]["id"]
	else:
		plpy.log( "Creating new location: " + location )
		result = plpy.execute("insert into locations(name) values( %s )" % plpy.quote_literal( location ) )
		result = plpy.execute("select id from locations where upper(name)=upper(%s)" % plpy.quote_literal(location) )
		location_id = result[0]["id"]
		plpy.log("new location id: " + str(location_id ) )


	plpy.log("Checking for Parameter '%s'" % parameter )
	result = plpy.execute( "select id from parameters where upper(name)=upper(%s)" % plpy.quote_literal(parameter) )
	if result.nrows() == 1:
		plpy.log("Parameter exists, using")
		parameter_id = result[0]["id"]
	else:
		plpy.log("creating new parameter with 'raw' units")
		result = plpy.execute( "insert into parameters(name,units) values( %s, 'raw')"% plpy.quote_literal(parameter) )
		result = plpy.execute( "select id from parameters where upper(name)=upper(%s)" % plpy.quote_literal(parameter) )
		parameter_id = result[0]["id"]

	plpy.log("Checking for type '%s'" % type )
	result = plpy.execute( "select id from types where upper(name)=upper(%s)" % plpy.quote_literal(type) )
	if result.nrows() == 1:
		plpy.log("Type available, using")
		type_id = result[0]["id"]
	else:
		plpy.fatal( 'Type not defined in this system' )


	plpy.log("Checking interval '%s'" % interval )
	result = plpy.execute( "select id from intervals where upper(name)=upper(%s)" % plpy.quote_literal(interval) )
	if result.nrows() == 1:
		plpy.log("Interval Allowed" )
		interval_id = result[0]["id"]
	else:
		plpy.fatal('Interval not defined')
	
	plpy.log("Checking duration '%s'" % duration )
	result = plpy.execute( "select id from intervals where upper(name)=upper(%s)" % plpy.quote_literal(duration) )
	if result.nrows() == 1:
		plpy.log("Duration Allowed" )
		duration_id = result[0]["id"]
	else:
		plpy.fatal('Duration not defined' )

	plpy.log( "Creating new time series with the following values \n %s => %d.%d.%d.%d.%d.%d.%s" % (ts_name,zone_id,location_id,parameter_id,type_id,interval_id,duration_id,version) )
	result = plpy.execute(add_ts, [zone_id,location_id,parameter_id,type_id,interval_id,duration_id,version] )
	#result = plpy.execute("select id from timeseries where zone=%d and location=%d and parameter=%d and type=%d and interval=%d and duration=%d and version=%s" % (zone_id,location_id,parameter_id,type_id,interval_id,duration_id,plpy.quote_literal(version) ) )
	result = plpy.execute(check_catalog, [ts_name,] )
	return result[0]["id"]
	#return -1


$_$;


--
-- Name: get_interval(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_interval(ts_name character varying) RETURNS integer
    LANGUAGE plpythonu
    AS $_$
if SD.has_key('get_interval'):
	get_interval = SD['get_interval']
else:
	get_interval = plpy.prepare("select id from intervals where upper(name) = upper($1)", ["varchar",] )
	SD['get_interval'] = get_interval
plpy.log( ts_name )
zone,location,parameter,_type,interval,duration,version = ts_name.split(".")
	
plpy.log('getting id/time for interval named' + interval )
results = plpy.execute( get_interval, [interval] )
return results[0]["id"]


$_$;


--
-- Name: retreive_timeseries_data(character varying, timestamp with time zone, timestamp with time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION retreive_timeseries_data(ts_name character varying, start_time timestamp with time zone, end_time timestamp with time zone, excludenulls boolean DEFAULT false) RETURNS SETOF data_triple
    LANGUAGE plpythonu
    AS $_$
	import time
	import datetime
	from dateutil.rrule import *
	from dateutil.parser import *
	if SD.has_key( 'get_tsid' ):
		get_tsid = SD['get_tsid']
		get_data = SD['get_data']
	else:
		get_tsid = plpy.prepare( 'select id from catalog where upper(timeseries_name)=upper($1)', ['varchar',] )
		get_data = plpy.prepare( 'select date_time,value,quality from timeseries_values where timeseries_id=$1 and date_time between $2 and $3 order by date_time asc', ["int","timestamptz","timestamptz"] )
		SD['get_tsid'] = get_tsid
		SD['get_data'] = get_data
	result = plpy.execute( get_tsid, [ts_name,] )
	tsid = result[0]["id"]
	plpy.log('Time Series found in database, proceding to get data');
	
	results = plpy.execute(get_data, [tsid,start_time, end_time] )
	
	times = []
	vals = []
	qualities = []
	# or interval = 0
	parts = ts_name.split(".")

	interval_name = parts[4]
	plpy.log( 'interval: ' + interval_name )
	result = plpy.execute("select id from intervals where upper(name)=upper(%s)" % plpy.quote_literal(interval_name) )
	interval_int =result[0]["id"]

	if excludenulls or interval_int == 0:
		for result in results:
			yield {'date_time': result["date_time"], 'value': result["value"], 'quality': result["quality"] }
	
	else:
		# get the interval in seconds
		# need to adjust this and check for the timezones and such
		dts = rrule( SECONDLY, dtstart=parse( start_time ), interval=interval_int, until=parse( end_time ) )
		#plpy.log( repr( list( dts ) ) )
		plpy.log ( repr( start_time ) )
		for t in list(dts):
			t_str = t.strftime( '%Y-%m-%d %H:%M:%S%z' )[:-2]
			have_val = False
			times.append( t_str )
			for res in results:
				#plpy.log( "ts value time: " + res["date_time"] )
				#plpy.log( "created time: " + t_str )
				if res["date_time"] == t_str:
					plpy.log("found an actual value" )
					vals.append(res["value"] )
					qualities.append( res["quality"] )
					have_val = True
					break
			if not have_val:
				vals.append( None )
				qualities.append( None )


		for i in range( 0, len(times) ):
			yield (times[i], vals[i], qualities[i] )
		# create list of times go through times
		



	#return [ times, vals, qualities ]
$_$;


--
-- Name: store_timeseries_data(character varying, data_triple[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION store_timeseries_data(ts_name character varying, data data_triple[], overwrite boolean DEFAULT false) RETURNS bigint
    LANGUAGE plpythonu
    AS $_$
if SD.has_key('add_ts'):
	add_ts = SD['add_ts']
	insert_value = SD['insert_value']
	delete_value = SD['delete_value']
else:
	add_ts = plpy.prepare( "select create_timeseries($1)", ["varchar"] )
	insert_value = plpy.prepare( "insert into timeseries_values(timeseries_id,date_time,value,quality) values($1,$2,$3,$4)", ["bigint", "timestamp with time zone","double precision","int"] )
	delete_value = plpy.prepare( "delete from timeseries_values where timeseries_id=$1 and date_time=$2", ["bigint","timestamp with time zone"] )
	SD['add_ts'] = add_ts
	SD['insert_value'] = insert_value
	SD['delete_value'] = delete_value

# just run create_timeseries, if it exits it will just return the name
result = plpy.execute( add_ts, [ts_name] )
plpy.log(repr(result[0].keys() ) )
ts_id = result[0]["create_timeseries"]
plpy.log("Storing data as time series id %d" % ts_id )
		
with plpy.subtransaction():
	for i in range(0, len(data) ):
		try:
			plpy.log( repr(data[i] ) )
			_data = data[i].replace("(","").replace(")","").split(",")
			result = plpy.execute( insert_value, [ts_id, _data[0], float(_data[1]), int(_data[2]) ] )
		except Exception,err:
			plpy.log( repr(err) + " : " + str(err) )
			if overwrite == True:
				plpy.log( "deleting previous value" );
				# delete the value first
				result = plpy.execute( delete_value, [ts_id, _data[0] ] )
				result = plpy.execute( insert_value, [ts_id, _data[0], float(_data[1]), int(_data[2]) ] )
return ts_id

$_$;


--
-- Name: store_timeseries_data(character varying, timestamp with time zone[], double precision[], integer[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION store_timeseries_data(ts_name character varying, times timestamp with time zone[], vals double precision[], qualities integer[], overwrite boolean DEFAULT false, OUT id bigint) RETURNS bigint
    LANGUAGE plpythonu
    AS $_$
if SD.has_key('add_ts'):
	add_ts = SD['add_ts']
	insert_value = SD['insert_value']
	delete_value = SD['delete_value']
else:
	add_ts = plpy.prepare( "select create_timeseries($1)", ["varchar"] )
	insert_value = plpy.prepare( "insert into timeseries_values(timeseries_id,date_time,value,quality) values($1,$2,$3,$4)", ["bigint", "timestamp with time zone","double precision","int"] )
	delete_value = plpy.prepare( "delete from timeseries_values where timeseries_id=$1 and date_time=$2", ["bigint","timestamp with time zone"] )
	SD['add_ts'] = add_ts
	SD['insert_value'] = insert_value
	SD['delete_value'] = delete_value

# just run create_timeseries, if it exits it will just return the name
result = plpy.execute( add_ts, [ts_name] )
plpy.log(repr(result[0].keys() ) )
ts_id = result[0]["create_timeseries"]
plpy.log("Storing data as time series id %d" % ts_id )
		
with plpy.subtransaction():
	for i in range(0, len(times) ):
		try:
			result = plpy.execute( insert_value, [ts_id, times[i], vals[i], qualities[i] ] )
		except:
			if overwrite == True:
				# delete the value first
				result = plpy.execute( delete_value, [ts_id,times[i] ] )
				result = plpy.execute( insert_value, [ts_id, times[i], vals[i], qualities[i] ] )
return ts_id
$_$;


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


--
-- Name: create_timeseries(character varying); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION create_timeseries(ts_name character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION create_timeseries(ts_name character varying) FROM housedbadm;
GRANT ALL ON FUNCTION create_timeseries(ts_name character varying) TO housedbadm;
GRANT ALL ON FUNCTION create_timeseries(ts_name character varying) TO housedbuser;


--
-- Name: timeseries_values; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE timeseries_values FROM PUBLIC;
REVOKE ALL ON TABLE timeseries_values FROM housedbadm;
GRANT ALL ON TABLE timeseries_values TO housedbadm;
GRANT ALL ON TABLE timeseries_values TO housedbuser;
GRANT SELECT,INSERT,REFERENCES ON TABLE timeseries_values TO PUBLIC;


--
-- PostgreSQL database dump complete
--

