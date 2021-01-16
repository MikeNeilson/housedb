
CREATE OR REPLACE FUNCTION housedb_tests.test_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    tsid1 bigint;
    tsid2 bigint;
BEGIN
    RAISE NOTICE 'creating timeseries';
    tsid1 := create_timeseries('Zone 1.Box 1.Moisture.Inst.1Hour.0.raw');
    RAISE NOTICE 'tsid: %', tsid1; 
    RETURN NEXT ok( tsid1 > 0, 'failed to create timeseries' ) ;
    tsid2 := create_timeseries('Zone 1.Box 1.Moisture.Inst.1Hour.0.raw');
    RETURN NEXT is( tsid2, tsid1, ' duplicate timeseries created but should not have been');
END;
$$ LANGUAGE plpgsql;

