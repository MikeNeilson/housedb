alter table housedb.locations add column latitude double precision;
alter table housedb.locations add column longitude double precision;
alter table housedb.locations add column horizontal_datum varchar(50);
alter table housedb.locations add column elevation double precision;
alter table housedb.locations add column vertical_datum varchar(50);