
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
    
    raise notice 'passed security check';
    raise notice 'test';
    select id into the_id from view_locations where lower(name) = lower(location);
    raise notice 'got existing id... maybe';
    if expect_new = true and the_id is not null then
        raise exception 'Location %s already exists and you indicated a new location id is expected', location USING ERRCODE = 'unique_violation';
    elsif expect_new = false and the_id is not null then
        --raise notice 'found existing location';
        return the_id;
    end if;
    raise notice 'making new location';
    select regexp_split_to_array($1,'-') into parts;				
    select array_length(parts,1) into length;
    if length > 10 THEN
        raise exception 'Location names can only nest 10 levels deep' USING ERRCODE = 'PX091';
    end if;    
    foreach cur_level in ARRAY parts
    loop        
        -- search for existing object at this level
        raise info 'Search for (%,%)', cur_level,the_parent_id;
        select  into the_id,found_parent_id id,parent_id from locations where name=cur_level and (parent_id = the_parent_id); -- or parent_id is null);
        if the_id is NULL THEN
            raise notice 'insert new value';    
            raise notice '%',found_parent_id    ;
            insert into locations(name,parent_id) values (cur_level,the_parent_id) returning id into the_id;
            the_parent_id = the_id;
        else
            raise notice 'this level exists, carrying on';
            the_parent_id = the_id; -- skip over this one, it already exists, but track it for the next run
        end if;

    end loop;    
    RETURN the_id;
END;
$$ LANGUAGE plpgsql;