
CREATE OR REPLACE FUNCTION housedb_tests.test_create_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    tsid1 bigint;
    tsid2 bigint;
BEGIN
    RAISE NOTICE 'creating timeseries';
    tsid1 := housedb.create_timeseries('Zone 1.Box 1.Moisture.Inst.1Hour.0.raw');
    RAISE NOTICE 'tsid: %', tsid1; 
    RETURN NEXT ok( tsid1 > 0, 'failed to create timeseries' ) ;
    tsid2 := housedb.create_timeseries('Zone 1.Box 1.Moisture.Inst.1Hour.0.raw');
    RETURN NEXT is( tsid2, tsid1, ' duplicate timeseries created but should not have been');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION housedb_tests.test_store_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    inputdata housedb.data_triple[];
    tsid varchar(255) = 'Test1.Test1.Precip.Total.0.0.raw';
    thecount int;
BEGIN
    inputdata = array[ ('2020-01-17T17:00:00Z-08:00',0,0), ('2020-01-17T08:00:00Z-08:00',0,0) ];
    housedb.store_timeseries_data(tsid, inputdata);
    SELECT count(*) into thecount from hosuedb.timeseries_values;
    RETURN NEXT is( thecount, 2 );
END;
$$ LANGUAGE plpgsql;