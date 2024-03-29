-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md


CREATE OR REPLACE FUNCTION housedb_locations.expand_location_name( location_id bigint ) RETURNS TEXT AS $$
DECLARE    
    location text = '';
    cur_loc text = '';
    cur_parent_id bigint = NULL;
    depth integer = 1;
BEGIN
    set search_path to housedb,public;
    select name, parent_id into location,cur_parent_id from locations where id = location_id;        
    while cur_parent_id is not NULL AND depth < 10 LOOP
        select name,parent_id into cur_loc, cur_parent_id from locations where id = cur_parent_id;
        --raise notice 'current name: %', location;
        location = cur_loc || '-' || location;
        depth = depth + 1;        
    end loop;        
    RETURN location;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION housedb_locations.create_location( location text, expect_new boolean default false ) RETURNS BIGINT AS $$
DECLARE    
    parts text[];
    the_parent_id bigint = NULL;
    found_parent_id bigint = NULL;
    the_id bigint = NULL;
    length integer = NULL;
    cur_level text;
BEGIN    
    set search_path to housedb,public;
    perform housedb_security.can_perform(housedb_security.get_session_user(),'CREATE','locations',location);
    
    --raise notice 'passed security check';
    --raise notice 'test';
    select id into the_id from view_locations where lower(name) = lower(location);
    --raise notice 'got existing id... maybe';
    if expect_new = true and the_id is not null then
        raise exception 'Location %s already exists and you indicated a new location id is expected', location USING ERRCODE = 'unique_violation';
    elsif expect_new = false and the_id is not null then
        --raise notice 'found existing location';
        return the_id;
    end if;
    --raise notice 'making new location';
    select regexp_split_to_array($1,'-') into parts;				
    select array_length(parts,1) into length;
    if length > 10 THEN
        raise exception 'Location names can only nest 10 levels deep' USING ERRCODE = 'PX091';
    end if;    
    foreach cur_level in ARRAY parts
    loop        
        -- search for existing object at this level
        raise info 'Search for (%,%)', cur_level,the_parent_id;
        select  
            into the_id,found_parent_id id,parent_id 
        from locations 
        where 
            lower(name)=lower(cur_level)
        and (
            (parent_id = the_parent_id) 
          or
            (parent_id is null and the_parent_id is null)
        );
        if the_id is NULL THEN
            raise notice 'insert new value';    
            --raise notice '%',found_parent_id    ;
            insert into locations(name,parent_id) values (cur_level,the_parent_id) returning id into the_id;
            the_parent_id = the_id;
        else
            --raise notice 'this level exists, carrying on';
            the_parent_id = the_id; -- skip over this one, it already exists, but track it for the next run
        end if;

    end loop;    
    RETURN the_id;
END;
$$ LANGUAGE plpgsql;


create or replace function housedb_timeseries.insert_location()
returns trigger
as $$
declare	
	loc_info housedb.timeseries%rowtype;
	l_loc_id bigint;
    l_parent_id bigint;
	loc_name text;	
begin 
	set search_path to housedb_locations,housedb_units,housedb,public;
	if TG_OP = 'DELETE' then		
		raise notice 'deleting %', OLD;
		return OLD;
	else
		--raise notice 'Inserting or updating value %', NEW;
		if NEW.id is not null and NEW.name is not null THEN
			raise exception 'Specify only timeseries_id or name, not both' using ERRCODE = 'ZX082';		
		end if;			
		
		if TG_OP = 'UPDATE' then            		
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''UPDATE'',''timeseries'',ts_name)';
            raise exception 'Update not supported at this time';			
		else -- INSERT 
			perform 'housedb_security.can_perform(housedb_security.get_session_user(),''CREATE'',''timeseries'',ts_name)';
			select housedb_locations.create_location(NEW.name) into l_loc_id;
            select into l_parent_id parent_id from housedb.view_locations where lower(name) = lower(NEW.name);
            NEW.id = l_loc_id;
            NEW.parent_id = l_parent_id;
            update locations
                set latitude = NEW.latitude,
                    longitude = NEW.longitude,
                    horizontal_datum = NEW.horizontal_datum,
                    elevation = NEW.elevation,
                    vertical_datum = NEW.vertical_datum
                where id = NEW.id;
		end if ;
				
		
	end if;
	
	return new;
end;
$$ language plpgsql;


