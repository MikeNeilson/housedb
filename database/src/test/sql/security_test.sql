CREATE OR REPLACE FUNCTION housedb_tests.test_can_perform()
RETURNS SETOF TEXT AS $$
DECLARE
    a_location text = 'Simple1';
    a_timeseries text = 'Loc 1.Moisture.Int.1Hour.0.raw';
    complex_location text = 'This-Is-Complex';    
    query text;
    query_res record;
BEGIN    
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''locations'', ''Simple1'')', 'Can read from a locations' );        
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''Simple1'')' , '%has no%', 'Cannot write to location since no permission' );
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''timeseries'',''Loc 1.Moisture.Int.1Hour.0.raw'')', 'Can read a timeseries' );
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''timeseries'',''This-Is-Complex'')', 'Can read a complex value');

    PERFORM housedb_security.add_permission('guest','WRITE','locations','^public\..*');
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''public.sidewalk'')', 'Can write to locatin given permission');
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''notpublic.driveway'')','%has no%', 'can not write to location without permission');    
    raise notice 'done with can_perform';

    PERFORM housedb_security.add_permission('guest','WRITE','locations','^private\.ok-?.*');
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''private.ok-?a test'')', 'with 2nd grant can write to location');
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''private.not ok-?a test'')', '%has no%', 'with 2nd grant can''t write to place not granted');

END;
$$ LANGUAGE plpgsql;

create or replace function housedb_tests.test_session_management()
returns setof text as $$
declare
begin
    RETURN NEXT ok(housedb_security.get_session_user() = 'guest', 'Default Session user is guest');
    RETURN NEXT ok(housedb_security.set_session_user('guest') = true, 'can set session user to guest');
    RETURN NEXT throws_like('select housedb_security.set_session_user(''invalid'')', '%does not exist%', 'set_session_user fails with invalid user.');

    RETURN NEXT ok(housedb_security.add_user('newuser') > 0, 'can create a new user');
    perform housedb_security.set_session_user('newuser');
    RETURN NEXT ok(housedb_security.get_session_user() = 'newuser','session user can be set to our new user');

end;
$$ LANGUAGE plpgsql


