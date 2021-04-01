create or replace function housedb_timeseries.error_bad_tsname() returns text as $$ begin return 'ZX081'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_bad_data() returns text as $$ begin return 'ZX082'; end; $$ language plpgsql;
create or replace function housedb_timeseries.duplicate_timeseries() returns text as $$ begin return 'ZX083'; end; $$ language plpgsql;

/**
* Used to make sure data going into the system has a consistent offset from some point
* 
*/
create or replace function housedb_timeseries.check_interval( p_date_time timestamp with time zone, p_interval int, p_offset interval)
returns void
as $$
declare
	l_interval interval;
	l_dt_epoch bigint;
	l_interval_epoch int;
	l_offset_epoch int;
	l_mod int;
begin
	SET search_path TO housedb_timeseries,housedb,public;    	

	select time_interval into l_interval from intervals where id=p_interval;
	if l_interval != '00:00:00' then		
		-- regular data, data should match offset
		select extract(epoch from p_date_time) into l_dt_epoch;
		select extract(epoch from l_interval) into l_interval_epoch;
		select extract(epoch from p_offset) into l_offset_epoch;
		l_mod := l_dt_epoch % l_interval_epoch;
		if l_mod != l_offset_epoch then
			raise exception 'Offset (% seconds) of date_time (%) doesn''t match expected offset (%)(%s seconds)', l_mod,p_date_time,l_interval,l_offset_epoch USING ERRCODE='ZX082';
		end if;
	else
		-- irregular interval data
	end if;

end;
$$ language plpgsql;
--
-- Name: create_timeseries(character varying); Type: FUNCTION; Schema: public; Owner: -
--
create or replace function housedb_timeseries.create_timeseries(ts_name character varying) returns bigint
as $$ begin
	return housedb_timeseries.create_timeseries(ts_name, '00:00:00', false);
end; $$ language plpgsql;

create or replace function housedb_timeseries.create_timeseries(ts_name character varying, interval_offset interval) returns bigint
as $$ begin
	return housedb_timeseries.create_timeseries(ts_name,interval_offset);
end; $$ language plpgsql;

CREATE OR REPLACE FUNCTION housedb_timeseries.create_timeseries(ts_name character varying, interval_offset interval, expect_new boolean) RETURNS bigint
AS  $$
DECLARE    
	ts_id integer;
	ts_parts text[];
	zone text;	
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
	SET search_path TO housedb_timeseries,housedb,public;    	
	perform housedb_security.can_perform(housedb_security.get_session_user(),'CREATE','timeseries',ts_name);
	SELECT id INTO ts_id FROM catalog WHERE UPPER(ts_name)=UPPER(timeseries_name);
	
    IF FOUND and expect_new = false THEN
		RETURN ts_id;
	elseif FOUND and expect_new = true then
		raise exception 'timeseries (%s) already exists', ts_name USING ERRCODE = 'ZX083';
	else
		--perform housedb_security.can_perform(housedb_security.get_session_user(),'CREATE','timeseries',ts_name);
			
        select regexp_split_to_array(ts_name,'\.') into ts_parts;	
		if array_length(ts_parts,1) > 6 then
			raise exception 'TS Name (%) has more than 7 parts',ts_name USING ERRCODE = 'ZX081';
		elsif array_length(ts_parts,1) < 6 then
			raise exception 'TS Name (%) has less than 7 parts',ts_name USING ERRCODE = 'ZX081';
		end if;
		location := ts_parts[1];
		param := ts_parts[2];
		data_type := ts_parts[3];
		_interval := ts_parts[4];
		duration := ts_parts[5];
		version := ts_parts[6];		
		
		location_id = housedb_locations.create_location(location);

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

		INSERT INTO timeseries(location_id,parameter_id,type_id,interval_id,duration_id,version,interval_offset)
		VALUES (location_id,param_id,data_type_id,interval_id,duration_id,version,interval_offset) RETURNING id INTO ts_id;		
		RETURN ts_id;

	END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION housedb_timeseries.store_timeseries_data(ts_name character varying, data housedb.data_triple[], overwrite boolean DEFAULT false) RETURNS bigint    
    AS $$
DECLARE
    ts_id bigint;
    tuple housedb.data_triple;
	l_offset interval;
	l_interval_id int;
BEGIN
	set search_path to housedb_timeseries,housedb,public;
	perform 'housedb_security.can_perform(housedb_security.get_session_user(),''STORE'',''timeseries'',ts_name)';

    SELECT create_timeseries($1) INTO ts_id;
	select 
		into l_offset,l_interval_id 
			 interval_offset, interval_id
	  from 
	  	timeseries
	  where 
	  	id = ts_id;
    

    FOREACH tuple IN array $2 LOOP
		perform housedb_timeseries.check_interval(tuple.date_time,l_interval_id,l_offset);
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



CREATE OR REPLACE FUNCTION housedb_timeseries.retrieve_timeseries_data(ts_name text, start_time timestamp with time zone, end_time timestamp with time zone, timezone text DEFAULT 'UTC', exclude_missing boolean DEFAULT false )
RETURNS SETOF housedb.data_triple
AS $$
DECLARE
	ts_id bigint;
	thedata data_triple;
BEGIN
	select id into ts_id from catalog where UPPER(timeseries_name)=UPPER(ts_name);
	if not found then
		raise exception 'TimeSeries, %, not found', ts_name;
	end if;
	for thedata in select date_time,value,quality from housedb.timeseries_values where timeseries_id = ts_id and date_time between start_time and end_time
	loop
		return next thedata;
	end loop;
END;
$$ LANGUAGE plpgsql;

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