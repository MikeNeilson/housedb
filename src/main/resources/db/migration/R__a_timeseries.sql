--
-- Name: create_timeseries(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE OR REPLACE FUNCTION create_timeseries(ts_name character varying) RETURNS bigint
AS  $$
DECLARE    
	ts_id integer;
	ts_parts text[];
	zone text;
	zone_id integer;
	location text;
	location_id integer;
	param text;
	param_id integer;
	data_type text;
	data_type_id integer;
	_interval text;
	interval_id integer;	
	duration text;
	duration_id integer;
	version text;
BEGIN
	SET search_path TO housedb,public;    

	SELECT id INTO ts_id FROM catalog WHERE UPPER(ts_name)=UPPER(timeseries_name);
	
    IF FOUND THEN
		RETURN ts_id;
	ELSE
        select regexp_split_to_array(ts_name,'\.') into ts_parts;				    
		location := ts_parts[1];
		param := ts_parts[2];
		data_type := ts_parts[3];
		_interval := ts_parts[4];
		duration := ts_parts[5];
		version := ts_parts[6];		
		
		location_id = create_location(location);

		SELECT id INTO param_id FROM parameters WHERE UPPER(name)=UPPER(param);
		IF NOT FOUND THEN
			INSERT INTO parameters(name,units) values (param,'raw') RETURNING ID into param_id;
		END IF;
		
		SELECT id INTO data_type_id FROM types where UPPER(name)=UPPER(data_type);
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Type % not defined in this system', data_type;
		END IF;

		SELECT id INTO interval_id FROM intervals where UPPER(name)=UPPER(_interval);
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Interval % not defined in this system', _interval;
		END IF;

		SELECT id INTO duration_id FROM intervals where UPPER(name)=UPPER(duration);
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Duration % not defined in this system', duration;
		END IF;

		INSERT INTO timeseries(zone_id,location_id,parameter_id,type_id,interval_id,duration_id,version)
		VALUES (zone_id,location_id,param_id,data_type_id,interval_id,duration_id,version) RETURNING id INTO ts_id;		
		RETURN ts_id;

	END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION store_timeseries_data(ts_name character varying, data data_triple[], overwrite boolean DEFAULT false) RETURNS bigint    
    AS $$
DECLARE
    ts_id bigint;
    tuple housedb.data_triple;
BEGIN
	set search_path to housedb,public;
    SELECT create_timeseries($1) INTO ts_id;
    
    FOREACH tuple IN array $2 LOOP
        INSERT INTO housedb.timeseries_values(timeseries_id,date_time,value,quality) VALUES (ts_id,tuple.date_time,tuple.value,tuple.quality);
    END LOOP;

    RETURN ts_id;
    /*
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
*/
END;
$$
LANGUAGE 'plpgsql';



/*


--
-- Name: retreive_timeseries_data(character varying, timestamp with time zone, timestamp with time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION retreive_timeseries_data(ts_name character varying, start_time timestamp with time zone, end_time timestamp with time zone, excludenulls boolean DEFAULT false) RETURNS SETOF data_triple
    LANGUAGE plpythonu
    AS $$
DECLARE
	ts_id integer;
	data_triple thedata;
BEGIN
	select id into ts_id from catalog where UPPER(timeseries_name)=UPPER($1);
	IF NOT FOUND THEN
		RAISE EXCEPTIOn 'TimeSeries, %s, not found', $1;
	END IF;
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
$$;


--
-- Name: store_timeseries_data(character varying, data_triple[], boolean); Type: FUNCTION; Schema: public; Owner: -
--




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
*/