CREATE OR REPLACE FUNCTION housedb_tests.test_can_perform()
RETURNS SETOF TEXT AS $$
DECLARE
    a_location text = 'Simple1';
    a_timeseries text = 'Loc 1.Moisture.Int.1Hour.0.raw';
    complex_location text = 'This-Is-Complex';    
    query_res record;
BEGIN
    RETURN NEXT ok(housedb.can_perform('guest','READ','locations',a_location) = true );
    RETURN NEXT ok(housedb.can_perform('guest','WRITE','locations',a_location) = false );
    RETURN NEXT ok(housedb.can_perform('guest','READ','timeseries',a_timeseries) = true );
    RETURN NEXT ok(housedb.can_perform('guest','READ','timeseries',complex_location) = true);

    PERFORM housedb.add_permission('guest','WRITE','locations','^public\..*');
    RETURN NEXT ok(housedb.can_perform('guest','WRITE','locations','public.sidewalk') = true);
    RETURN NEXT ok(housedb.can_perform('guest','WRITE','locations','notpublic.driveway') = false);
END;
$$ LANGUAGE plpgsql;

create or replace function housedb_tests.test_session_management()
returns setof text as $$
declare
begin
    RETURN NEXT ok(housedb.get_session_user() = 'guest', 'Default Session user not set');
    RETURN NEXT ok(housedb.set_session_user('guest') = true, 'unable to set session to guest');
    RETURN NEXT throws_like('select housedb.set_session_user(''invalid'')', '%does not exist%', 'Invalid user got through.');

    RETURN NEXT ok(housedb.add_user('newuser') > 0, 'unabled to create new user');
    perform housedb.set_session_user('newuser');
    RETURN NEXT ok(housedb.get_session_user() = 'newuser','session user wasn''t changed');

end;
$$ LANGUAGE plpgsql


