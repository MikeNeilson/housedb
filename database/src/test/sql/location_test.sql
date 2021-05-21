CREATE OR REPLACE FUNCTION housedb_tests.test_create_location()
RETURNS SETOF TEXT AS $$
DECLARE
    simple_location text = 'Simple1';
    simple_location_diffcase text = 'SiMPLe1';
    complex_location text = 'This-Is-Complex'; 
    sub_location text = 'Simple1-Sub';   
    query_res record;
    sub_id bigint;
BEGIN
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');

    RETURN NEXT ok(housedb_locations.create_location(simple_location) > 0, 'can create a simple location');
    RETURN NEXT ok(housedb_locations.create_location(complex_location) > 0, 'can create a complex location' );

    RETURN NEXT isnt_empty( 'select * from housedb.locations where parent_id is not null', 'locations have been created' );

    sub_id = housedb_locations.create_location(sub_location);
    RETURN NEXT ok(sub_id > 0,'sub location is made' );
    RETURN NEXT ok(housedb_locations.expand_location_name(sub_id) = sub_location, 'expand_location_name expands correctly');

    --RAISE NOTICE 'checking case issues';
    RETURN NEXT throws_ok('select housedb_locations.create_location(''SiMPle1'',true)', 23505 );-- 'create_location does not allow mixed case' );
    RETURN NEXT ok(housedb_locations.create_location('SiMPle1',false) > 0, 'create_location return original if passed altered case');

    RETURN NEXT throws_ok('select housedb_locations.create_location(''Test0-Test1-Test2-Test3-Test4-Test5-Test6-Test7-Test8-Test9-Test11'')', 'PX091'); -- can't nest more than 10 deep

    sub_id := housedb_locations.create_location('Simple1-Simple1');
    RETURN NEXT ok( housedb_locations.expand_location_name(sub_id) = 'Simple1-Simple1','Can duplicate name in sublocations');
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION housedb_tests.test_expand_location()
RETURNS SETOF TEXT AS $$
DECLARE
    simple_location text = 'Simple';    
    complex_location text = 'This-Is-Complex';
    result text;
    a_parent_id bigint;
    sub_id bigint;
    the_simple_id bigint;
    the_complex_id bigint;
BEGIN
    RAISE NOTICE 'EXPANDING LOCATIONS';
    insert into housedb.locations(name) values ('Simple') returning id into the_simple_id;
    insert into housedb.locations(name) values ('This') returning id into a_parent_id;
    insert into housedb.locations(name,parent_id) values ('Is',a_parent_id) returning id into a_parent_id;
    insert into housedb.locations(name,parent_id) values ('Complex',a_parent_id) returning id into the_complex_id;
    --RAISE NOTICE 'Simple -> %', housedb_locations.expand_location_name(the_simple_id);
    --RAISE NOTICE 'Complex -> ';
    --RAISE NOTICE '%', housedb_locations.expand_location_name(the_complex_id);
    RETURN NEXT is( housedb_locations.expand_location_name(the_simple_id), simple_location, 'doesn''t ruin simple location' );
    RETURN NEXT is( housedb_locations.expand_location_name(the_complex_id), complex_location, 'complex location expands correctly' );
    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION housedb_tests.test_create_with_sub_doesnt_create_duplicate()
RETURNS SETOF TEXT AS $$
DECLARE
    base_name text = 'Test';
    full_loc text = 'Test-Sub Location';
    n_rows int;
BEGIN
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');

    perform housedb_locations.create_location(base_name);
    select into n_rows count(*) from housedb.locations;
    RETURN NEXT ok( n_rows = 1, 'Should only have 1 row');

    perform housedb_locations.create_location(full_loc);
    select into n_rows count(*) from housedb.locations;
    RETURN NEXT ok( n_rows = 2, 'Should only have 2 rows, duplicate row created');

END;
$$ LANGUAGE plpgsql;





