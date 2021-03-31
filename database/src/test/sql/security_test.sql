CREATE OR REPLACE FUNCTION housedb_tests.test_can_perform()
RETURNS SETOF TEXT AS $$
DECLARE
    a_location text = 'Simple1';
    a_timeseries text = 'Loc 1.Moisture.Int.1Hour.0.raw';
    complex_location text = 'This-Is-Complex';    
    query text;
    query_res record;
BEGIN    
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''locations'', ''Simple1'')', 'should have passed' );        
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''Simple1'')' , '%has no%', 'should have failed' );
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''timeseries'',''Loc 1.Moisture.Int.1Hour.0.raw'')', 'should have passed' );
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''READ'',''timeseries'',''This-Is-Complex'')', 'should have passed');

    PERFORM housedb_security.add_permission('guest','WRITE','locations','^public\..*');
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''public.sidewalk'')', 'should have passed');
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''notpublic.driveway'')','%has no%', 'should have failed');    
    raise notice 'done with can_perform';

    PERFORM housedb_security.add_permission('guest','WRITE','locations','^private\.ok-?.*');
    RETURN NEXT lives_ok('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''private.ok-?a test'')', 'should have passed');
    RETURN NEXT throws_like('select housedb_security.can_perform(''guest'',''WRITE'',''locations'',''private.not ok-?a test'')', '%has no%', 'should have failed');

END;
$$ LANGUAGE plpgsql;

create or replace function housedb_tests.test_session_management()
returns setof text as $$
declare
begin
    RETURN NEXT ok(housedb_security.get_session_user() = 'guest', 'Default Session user not set');
    RETURN NEXT ok(housedb_security.set_session_user('guest') = true, 'unable to set session to guest');
    RETURN NEXT throws_like('select housedb_security.set_session_user(''invalid'')', '%does not exist%', 'Invalid user got through.');

    RETURN NEXT ok(housedb_security.add_user('newuser') > 0, 'unabled to create new user');
    perform housedb_security.set_session_user('newuser');
    RETURN NEXT ok(housedb_security.get_session_user() = 'newuser','session user wasn''t changed');

end;
$$ LANGUAGE plpgsql


