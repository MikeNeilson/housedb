
CREATE OR REPLACE FUNCTION housedb.expand_location_name( location_id bigint ) RETURNS TEXT AS $$
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
        raise notice 'current name: %', location;
        location = cur_loc || '-' || location;
        depth = depth + 1;        
    end loop;        
    RETURN location;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION housedb.create_location( location text ) RETURNS BIGINT AS $$
DECLARE
    parts text[];
    the_parent_id bigint = NULL;
    found_parent_id bigint = NULL;
    the_id bigint = NULL;
    length integer = NULL;
    cur_level text;
BEGIN
    set search_path to housedb,public;
    select regexp_split_to_array($1,'-') into parts;				
    select array_length(parts,1) into length;
    if length > 10 THEN
        raise exception 'Location names can only nest 10 levels deep';
    end if;    
    foreach cur_level in ARRAY parts
    loop        
        -- search for existing object at this level
        raise info 'Search for (%,%)', cur_level,the_parent_id;
        select id,parent_id into the_id,found_parent_id from locations where name=cur_level and (parent_id = the_parent_id or parent_id is null);
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