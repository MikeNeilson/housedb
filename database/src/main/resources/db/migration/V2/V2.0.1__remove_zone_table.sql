-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

alter table housedb.timeseries drop column zone_id;
alter table housedb.timeseries drop constraint if exists timeseries_zone_id_fkey;
drop table housedb.zones;