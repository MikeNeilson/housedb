create or replace function housedb_timeseries.error_bad_tsname() returns text as $$ begin return 'ZX081'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_bad_data() returns text as $$ begin return 'ZX082'; end; $$ language plpgsql;
create or replace function housedb_timeseries.duplicate_timeseries() returns text as $$ begin return 'ZX083'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_no_timeseries() returns text as $$ begin return 'ZX084'; end; $$ language plpgsql;
create or replace function housedb_timeseries.no_units_provided() returns text as $$ begin return 'ZX085'; end; $$ language plpgsql;
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
	--raise notice 'Checking interval with offset %',p_offset;
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

create or replace function housedb_timeseries.get_interval_offset( p_date_time timestamp with time zone, p_interval_id bigint)
returns interval
as $$
declare
	l_interval interval;
	l_dt_epoch bigint;
	l_interval_epoch int;
	l_offset_epoch int;
	l_mod int;
	l_interval_offset interval;
begin
	SET search_path TO housedb_timeseries,housedb,public;    	

	select time_interval into l_interval from intervals where id=p_interval_id;
	if l_interval != '00:00:00' then
		select extract(epoch from p_date_time) into l_dt_epoch;
		select extract(epoch from l_interval) into l_interval_epoch;		
		l_mod := l_dt_epoch % l_interval_epoch;
		l_interval_offset := make_interval(secs=>l_mod);
		--raise notice 'calculated offset %', l_interval_offset;
		return l_interval_offset;
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

-- TODO: make a check valid ts name function
create or replace function housedb_timeseries.extract_interval_id_from_name( p_timeseries_name text )
returns bigint	
as $$
declare
	l_interval text;
	l_interval_id bigint;
	ts_parts text[];
begin
	select regexp_split_to_array(p_timeseries_name,'\.') into ts_parts;	
	if array_length(ts_parts,1) > 6 then
		raise exception 'TS Name (%) has more than 7 parts',ts_name USING ERRCODE = 'ZX081';
	elsif array_length(ts_parts,1) < 6 then
		raise exception 'TS Name (%) has less than 7 parts',ts_name USING ERRCODE = 'ZX081';
	end if;
	l_interval = ts_parts[4];
	select into l_interval_id id from housedb.intervals where lower(l_interval) = lower(name);
	if l_interval_id is not null THEN
		return l_interval_id;
	else 
		raise exception 'Unable to extract interval from (%s) likely not defined yet', p_timeseries_name;
	end if;
end;
$$ language plpgsql;

create or replace function housedb_timeseries.extract_parameter_id_from_name( p_timeseries_name text )
returns bigint	
as $$
declare
	l_parameter text;
	l_parameter_id bigint;
	ts_parts text[];
begin
	select regexp_split_to_array(p_timeseries_name,'\.') into ts_parts;	
	if array_length(ts_parts,1) > 6 then
		raise exception 'TS Name (%) has more than 7 parts',ts_name USING ERRCODE = 'ZX081';
	elsif array_length(ts_parts,1) < 6 then
		raise exception 'TS Name (%) has less than 7 parts',ts_name USING ERRCODE = 'ZX081';
	end if;
	l_parameter = ts_parts[2];
	select into l_parameter_id id from housedb.parameters where lower(l_parameter) = lower(name);
	if l_parameter_id is not null THEN
		return l_parameter_id;
	else 
		raise exception 'Unable to extract Parameter from (%s) likely not defined yet', p_timeseries_name;
	end if;
end;
$$ language plpgsql;

create or replace function housedb_timeseries.insert_tsv()
returns trigger
as $$
declare	
	ts_info housedb.timeseries%rowtype;
	l_ts_id bigint;
	ts_name text;
	l_new_interval_id bigint;
	l_calculated_offset interval;
	l_storage_unit text;
	l_value double precision;
begin 
	set search_path to housedb_timeseries,housedb_units,housedb,public;
	if TG_OP = 'DELETE' then		
		raise notice 'deleting %', OLD;
		return OLD;
	else
		--raise notice 'Inserting or updating value %', NEW;
		if NEW.ts_id is not null and NEW.name is not null THEN
			raise exception 'Specify only timeseries_id or name, not both' using ERRCODE = 'ZX082';
		elsif NEW.ts_id is not null then
			select * from timeseries into ts_info where id=NEW.timeseries_id;
			if ts_info is null THEN
				raise exception 'Insertion by ts_id but time series does not exist' USING ERRCODE = 'ZX084';
			end if;
			select timeseries_name into ts_name from catalog where NEW.ts_id;
		elsif NEW.name is not null THEN			
			select into l_ts_id id from housedb.catalog where upper(timeseries_name)=upper(NEW.name);			
			select * from timeseries into ts_info where id=(select id from housedb.catalog where timeseries_name=NEW.name);
			if ts_info is null THEN				
				l_new_interval_id = housedb_timeseries.extract_interval_id_from_name(NEW.name);				
				l_calculated_offset = housedb_timeseries.get_interval_offset(NEW.date_time, l_new_interval_id);
				l_ts_id := housedb_timeseries.create_timeseries(NEW.name::character varying, l_calculated_offset ); --,l_calculated_offset); -- TODO: update to handle the interval offset setting with the first value
				select * from timeseries into ts_info where id=l_ts_id;
				NEW.ts_id = l_ts_id;				
			end if;			
			ts_name := NEW.name;
		end if;			
		-- consider moving to before trigger
		if TG_OP = 'UPDATE' then
			--raise notice 'check can update';
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''UPDATE'',''timeseries'',ts_name)';
			--raise notice 'check can update down';
		else 
			--raise notice 'check can store';
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''STORE'',''timeseries'',ts_name)';
			--raise notice 'check can store';
		end if ;
		
		--raise notice 'security checks passed';
		perform housedb_timeseries.check_interval(NEW.date_time,ts_info.interval_id,ts_info.interval_offset);
		if NEW.units is null THEN
			raise exception 'You must provide units with the provided data' USING ERRCODE = 'ZX085';
		end if;
		--raise notice 'Inserting, all checks passed';
		select into l_storage_unit units from parameters where id = extract_parameter_id_from_name(NEW.name);
		l_value := convert_units(NEW.value,NEW.units::text,l_storage_unit::text);
		insert into 
			housedb.internal_timeseries_values(timeseries_id,date_time,value,quality)
		values (ts_info.id,NEW.date_time,l_value,NEW.quality)
		on conflict (timeseries_id,date_time) 
		  do update set value = l_value, quality=NEW.quality;
		
	end if;
	
	return new;
end;
$$ language plpgsql;

drop trigger if exists insert_tsv_trigger on housedb.timeseries_values;
create trigger insert_tsv_trigger instead of insert or update or delete on housedb.timeseries_values 
    for each row execute procedure housedb_timeseries.insert_tsv();
