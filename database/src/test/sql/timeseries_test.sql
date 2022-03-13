-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md


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

    RETURN NEXT throws_ok('select housedb_timeseries.create_timeseries(''Zone 1.Moisture.Inst.1Hour.0.0.raw'')',housedb_timeseries.error_bad_tsname());
    RETURN NEXT throws_ok('select housedb_timeseries.create_timeseries(''Zone 1.Moisture.Inst.1Hour.raw'')',housedb_timeseries.error_bad_tsname());
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION housedb_tests.test_store_timeseries()
RETURNS SETOF TEXT AS $$
DECLARE
    inputdata housedb.data_triple[];
    ts_name varchar(255) = 'Test1-Test1.Precip.Total.0.0.raw';
    l_ts_id bigint;
    thecount int;
BEGIN
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');
    perform housedb_security.add_permission('guest', 'CREATE', 'timeseries','.*');
    perform housedb_security.add_permission('guest', 'STORE', 'timeseries','Test1-.*');
    
    insert into housedb.timeseries_values(name,date_time,value,quality,units) 
        values 
            (ts_name,'2020-01-17T17:00:00Z-08:00',0,0,'ft'),
            (ts_name,'2020-01-17T08:00:00Z-08:00',0,0,'ft');
    select id into l_ts_id from housedb.catalog where timeseries_name = ts_name;
    --SELECT housedb_timeseries.store_timeseries_data(ts_name, inputdata) INTO ts_id;
    SELECT count(*) into thecount from housedb.timeseries_values where ts_id = l_ts_id;
    RETURN NEXT is( thecount, 2, 'can add data to timeseries values' );
END;
$$ LANGUAGE plpgsql;


create or replace function housedb_tests.test_store_regular_interval_ts()
returns setof text as $$
declare
    inputdata_reg housedb.data_triple[];
    inputdata_bad housedb.data_triple[];
    ts_name varchar(255) := 'Test1-Test1.Stage.Inst.1Hour.0.raw';    
    ts_id bigint;
    l_offset interval;
    l_row housedb.catalog%rowtype;
begin
    set search_path = housedb,public;
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');
    perform housedb_security.add_permission('guest', 'CREATE', 'timeseries','.*');
    perform housedb_security.add_permission('guest', 'STORE', 'timeseries','.*');
    
    ts_id := housedb_timeseries.create_timeseries(ts_name);              
    PREPARE insert_data as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T01:00:00Z',0,0,'ft'),
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T02:00:00Z',1,1,'ft'),
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T03:00:00Z',2,1,'ft')
    ;
    PREPARE insert_data_bad as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T01:00:00Z',0,0,'ft'),
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T02:30:00Z',1,1,'ft'),
        ('Test1-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T03:00:00Z',2,1,'ft')
    ;
    RETURN NEXT lives_ok('insert_data', 'Can insert properly formatted regular data');
    RETURN NEXT throws_ok('insert_data_bad',housedb_timeseries.error_bad_data()); -- bad offset


    ts_id := housedb_timeseries.create_timeseries('Test1-Test1.Stage.Inst.1Hour.0.offset','00:30:00');
    raise notice 'ts_id %',ts_id;
    select into l_offset interval_offset from housedb.timeseries where id=ts_id;
    for l_row in select * from housedb.catalog loop
        raise notice '%',l_row;
    end loop;
    raise notice 'created with interval %', l_offset;
    PREPARE insert_data2 as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T01:30:00Z',0,0,'ft'),
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T02:30:00Z',1,1,'ft'),
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T03:30:00Z',2,1,'ft')
    ;
    PREPARE insert_data_bad2 as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T01:00:00Z',0,0,'ft'),
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T02:30:00Z',1,1,'ft'),
        ('Test1-Test1.Stage.Inst.1Hour.0.offset','2020-01-01T03:00:00Z',2,1,'ft')
    ;
    raise notice ' checking properly formatted data with offset';
    RETURN NEXT lives_ok('insert_data2', 'Can insert properly formatted regular data with specified offset');
    RETURN NEXT throws_ok('insert_data_bad2',housedb_timeseries.error_bad_data()); -- bad offset
end;
$$ language plpgsql;

create or replace function housedb_tests.test_store_with_first_data_setting_offset()
returns setof text as $$
declare    
    ts_id bigint;
    l_offset interval;
    l_row housedb.catalog%rowtype;
begin
    set search_path = housedb,public;
    perform housedb_security.add_permission('guest', 'CREATE', 'locations','.*');
    perform housedb_security.add_permission('guest', 'CREATE', 'timeseries','.*');
    perform housedb_security.add_permission('guest', 'STORE', 'timeseries','.*');
        
    PREPARE insert_data_first_ts as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test1-Offset5min.Stage.Inst.1Hour.0.raw','2020-01-01T01:05:00Z',0,0,'ft'),
        ('Test1-Offset5min.Stage.Inst.1Hour.0.raw','2020-01-01T02:05:00Z',1,1,'ft'),
        ('Test1-Offset5min.Stage.Inst.1Hour.0.raw','2020-01-01T03:05:00Z',2,1,'ft')
    ;
    PREPARE insert_data_first_ts_bad as insert into housedb.timeseries_values(name,date_time,value,quality,units) values
        ('Test2-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T01:05:00Z',0,0,'ft'),
        ('Test2-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T02:30:00Z',1,1,'ft'),
        ('Test2-Reg.Stage.Inst.1Hour.0.raw','2020-01-01T03:00:00Z',2,1,'ft')
    ;
    RETURN NEXT lives_ok('insert_data_first_ts', 'Can insert properly formatted regular data');
    RETURN NEXT throws_ok('insert_data_first_ts_bad',housedb_timeseries.error_bad_data()); -- bad offset
end;
$$ language plpgsql;