create or replace function housedb_timeseries.error_bad_tsname() returns text as $$ begin return 'ZX081'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_bad_data() returns text as $$ begin return 'ZX082'; end; $$ language plpgsql;
create or replace function housedb_timeseries.duplicate_timeseries() returns text as $$ begin return 'ZX083'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_no_timeseries() returns text as $$ begin return 'ZX084'; end; $$ language plpgsql;
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
	raise notice 'Checking interval with offset %',p_offset;
	select into l_interval time_interval from intervals where id=p_interval;	
	if l_interval != '00:00:00' then
		-- regular data, data should match offset
		select extract(epoch from p_date_time) into l_dt_epoch;
		select extract(epoch from l_interval) into l_interval_epoch;
		select extract(epoch from p_offset) into l_offset_epoch;
		l_mod := l_dt_epoch % l_interval_epoch;
		if l_mod != l_offset_epoch then
			raise exception 'Offset (% seconds) of date_time (%) doesn''t match expected offset (%)(%s seconds)', l_mod,p_date_time,p_offset,l_offset_epoch USING ERRCODE='ZX082';
		end if;
	else
		-- irregular interval data
	end if;

end;
$$ language plpgsql;

create or replace function housedb_timeseries.get_interval_offset( p_date_time timestamp with time zone, p_interval_id int)
returns interval
as $$
declare
	l_interval interval;
	l_dt_epoch bigint;
	l_interval_epoch int;
	l_offset_epoch int;
	l_mod int;
begin
	SET search_path TO housedb_timeseries,housedb,public;    	

	select time_interval into l_interval from intervals where id=p_interval_id;
	if l_interval != '00:00:00' then
		select extract(epoch from p_date_time) into l_dt_epoch;
		select extract(epoch from l_interval) into l_interval_epoch;		
		l_mod := l_dt_epoch % l_interval_epoch;
		return l_mod::interval;
	else
		return '0s'::interval;
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
	return housedb_timeseries.create_timeseries(ts_name,interval_offset,false);
end; $$ language plpgsql;

DROP FUNCTION IF EXISTS housedb_timeseries.create_timeseries(character varying,interval,boolean);
CREATE OR REPLACE FUNCTION housedb_timeseries.create_timeseries(ts_name character varying, p_interval_offset interval, expect_new boolean) RETURNS bigint
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
		VALUES (location_id,param_id,data_type_id,interval_id,duration_id,version,p_interval_offset) RETURNING id INTO ts_id;		
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
        INSERT INTO housedb.internal_timeseries_values(timeseries_id,date_time,value,quality) VALUES (ts_id,tuple.date_time,tuple.value,tuple.quality);
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
		raise exception 'TimeSeries, %, not found', ts_name USING ERRCODE = 'ZX084';
	end if;
	for thedata in select date_time,value,quality from housedb.internal_timeseries_values where timeseries_id = ts_id and date_time between start_time and end_time
	loop
		return next thedata;
	end loop;
END;
$$ LANGUAGE plpgsql;



create or replace function housedb_timeseries.insert_tsv()
returns trigger
as $$
declare	
	ts_info housedb.timeseries%rowtype;
	l_ts_id bigint;
	ts_name text;
begin 
	set search_path to housedb_timeseries,housedb,public;
	if TG_OP = 'DELETE' then		
		raise notice 'deleting %', OLD;
		return OLD;
	else
		raise notice 'Inserting or updating value %', NEW;
		if NEW.ts_id is not null and NEW.name is not null THEN
			raise exception 'Specify only timeseries_id or name, not both' using ERRCODE = 'ZX082';
		elsif NEW.ts_id is not null then
			select * from timeseries into ts_info where id=NEW.timeseries_id;
			if ts_info is null THEN
				raise exception 'Insertion by ts_id but time series does not exist' USING ERRCODE = 'ZX084';
			end if;
			select timeseries_name into ts_name from catalog where NEW.ts_id;
		elsif NEW.name is not null THEN
			raise notice 'getting info for %', NEW.name;
			select into l_ts_id id from housedb.catalog where upper(timeseries_name)=upper(NEW.name);
			raise notice 'found id %',l_ts_id;
			select * from timeseries into ts_info where id=(select id from housedb.catalog where timeseries_name=NEW.name);
			if ts_info is null THEN
				raise notice 'creating ts info';
				l_ts_id := housedb_timeseries.create_timeseries(NEW.name::character varying); -- TODO: update to handle the interval offset setting with the first value
				select * from timeseries into ts_info where id=l_ts_id;
				NEW.ts_id = l_ts_id;
				raise notice 'got ts info';
			end if;
			raise notice 'have ts info';
			ts_name := NEW.name;
		end if;	
		raise notice 'Working with ts %', ts_info;
		-- consider moving to before trigger
		if TG_OP = 'UPDATE' then
			raise notice 'check can update';
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''UPDATE'',''timeseries'',ts_name)';
			raise notice 'check can update down';
		else 
			raise notice 'check can store';
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''STORE'',''timeseries'',ts_name)';
			raise notice 'check can store';
		end if ;
		raise notice 'security checks passed';
		perform housedb_timeseries.check_interval(NEW.date_time,ts_info.interval_id,ts_info.interval_offset);
		
		raise notice 'Inserting, all checks passed';
		insert into 
			housedb.internal_timeseries_values(timeseries_id,date_time,value,quality)
		values (ts_info.id,NEW.date_time,NEW.value,NEW.quality)
		on conflict (timeseries_id,date_time) 
		  do update set value = NEW.value, quality=NEW.quality;
		
	end if;
	
	return new;
end;
$$ language plpgsql;

drop trigger if exists insert_tsv_trigger on housedb.timeseries_values;
create trigger insert_tsv_trigger instead of insert or update or delete on housedb.timeseries_values 
    for each row execute procedure housedb_timeseries.insert_tsv();

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