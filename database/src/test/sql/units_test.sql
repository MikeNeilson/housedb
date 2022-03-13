-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

create or replace function housedb_tests.test_unit_basics()
returns setof text as $$
declare    
    
begin
    set search_path = housedb_units,housedb,public;
    RETURN NEXT ok( convert_units(1,'%','%') = 1, 'Pass through work');
    
    RETURN NEXT ok( convert_units(20,'degC','degF') = 68, 'Can Convert from C to F');
    RETURN NEXT ok( convert_units(68,'degF','degC') = 20, 'Can Convert from F to C' );
    --RETURN NEXT lives_ok('insert_data_first_ts', 'Can insert properly formatted regular data');
    --RETURN NEXT throws_ok('insert_data_first_ts_bad',housedb_timeseries.error_bad_data()); -- bad offset
end;
$$ language plpgsql;