create or replace function housedb_tests.test_unit_basics()
returns setof text as $$
declare    
    
begin
    set search_path = housedb_units,housedb,public;
    RETURN NEXT ok( covert_units(1,'%','%') = 1, 'Pass through work');
    
    --RETURN NEXT lives_ok('insert_data_first_ts', 'Can insert properly formatted regular data');
    --RETURN NEXT throws_ok('insert_data_first_ts_bad',housedb_timeseries.error_bad_data()); -- bad offset
end;
$$ language plpgsql;