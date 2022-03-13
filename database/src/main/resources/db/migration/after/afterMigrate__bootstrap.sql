-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

insert into housedb.types (name) values 
('Inst'),
('Ave'),
('Min'),
('Max'),
('Total'),
('Accum')
on conflict do nothing;

insert into housedb.intervals(name,time_interval) values
('0','00:00:00'),
('15Minutes','00:15:00'),
('1Hour','01:00:00'),
('1Day','24:00:00')
on conflict (lower(name)) do update set time_interval=EXCLUDED.time_interval;
 
 

insert into housedb.parameters(name,units) values 
('Moisture','%'),
('Precip','in'),
('Temp-Air','degC'),
('Temp-Soil','degC')
on conflict (lower(name)) do update
set units = EXCLUDED.units, name=EXCLUDED.name;


insert into housedb.users(id,username,active) values (1,'admin',true) on conflict do nothing;
-- table 6 users
-- table 7 permisions
-- table 8 user_permissions

/* 
    Perm 1 READ
    Perm 2 WRITE
    Perm 3 UPDATE
    Perm 4 CREATE
    Perm 5 DELETE
    Perm 6 STORE
*/

insert into housedb.user_permissions(user_id,permission_id,data_table_id,regex,granter_id)
    values (1,1,6,'.*',1),
           (1,1,7,'.*',1),
           (1,1,8,'.*',1),
           (1,2,6,'.*',1),
           (1,2,7,'.*',1),
           (1,2,8,'.*',1),
           (1,3,6,'.*',1),
           (1,3,7,'.*',1),
           (1,3,8,'.*',1),
           (1,4,6,'.*',1),
           (1,4,7,'.*',1),
           (1,4,8,'.*',1),
           (1,5,6,'.*',1),
           (1,5,7,'.*',1),
           (1,5,8,'.*',1)
on conflict do nothing;
