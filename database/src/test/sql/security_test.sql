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
END;
$$ LANGUAGE plpgsql;