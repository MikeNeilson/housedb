alter table housedb.timeseries add column interval_offset interval;
update housedb.timeseries set interval_offset = '00:00:00' where interval_offset is null;
alter table housedb.timeseries alter column interval_offset set not null;

alter table housedb.intervals
    add column time_interval interval;
update housedb.intervals set time_interval = '00:00:00' where name='0';
update housedb.intervals set time_interval = '00:15:00' where name='15Minutes';
update housedb.intervals set time_interval = '01:00:00' where name='1Hour';
update housedb.intervals set time_interval = '24:00:00' where name='1Day';

alter table housedb.intervals
    alter column time_interval set not null;