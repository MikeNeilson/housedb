-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

alter table housedb.locations drop constraint unique_name;
drop index          housedb.location_names_lower;

create unique index location_names_lower on housedb.locations( lower(name), parent_id );