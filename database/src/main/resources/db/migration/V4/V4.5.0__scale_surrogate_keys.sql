-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

drop view housedb.timeseries_values;
drop view housedb.catalog;
drop view housedb.catalog_view;

alter table housedb.intervals alter column id type integer;
alter table housedb.types alter column id type integer;
alter table housedb.timeseries alter column location_id type bigint;
