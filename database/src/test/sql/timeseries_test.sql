
CREATE OR REPLACE FUNCTION housedb_tests.test_create_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    tsid1 bigint;
    tsid2 bigint;
BEGIN
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');
    perform housedb_security.add_permission('guest', 'CREATE', 'timeseries','.*');

    RAISE NOTICE 'creating timeseries';
    tsid1 := housedb_timeseries.create_timeseries('Zone 1-Box 1.Moisture.Inst.1Hour.0.raw');
    RAISE NOTICE 'tsid: %', tsid1; 
    RETURN NEXT ok( tsid1 > 0, 'can create timeseries' ) ;
    tsid2 := housedb_timeseries.create_timeseries('Zone 1-Box 1.Moisture.Inst.1Hour.0.raw');
    RETURN NEXT is( tsid2, tsid1, ' cannot create duplicate timeseries, attempt returns original code');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION housedb_tests.test_store_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    inputdata housedb.data_triple[];
    ts_name varchar(255) = 'Test1-Test1.Precip.Total.0.0.raw';
    ts_id bigint;
    thecount int;
BEGIN
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');
    perform housedb_security.add_permission('guest', 'CREATE', 'timeseries','.*');
    perform housedb_security.add_permission('guest', 'STORE', 'timeseries','Test1-.*');

    inputdata = array[ ('2020-01-17T17:00:00Z-08:00',0,0), ('2020-01-17T08:00:00Z-08:00',0,0) ];
    SELECT housedb_timeseries.store_timeseries_data(ts_name, inputdata) INTO ts_id;
    SELECT count(*) into thecount from housedb.timeseries_values where timeseries_id = ts_id;
    RETURN NEXT is( thecount, 2, 'can add data to timeseries values' );
END;
$$ LANGUAGE plpgsql;