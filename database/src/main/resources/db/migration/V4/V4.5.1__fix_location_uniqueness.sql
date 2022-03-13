-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

drop index          housedb.location_names_lower;

create unique index location_names_lower_no_parent on housedb.locations( lower(name) ) where parent_id is null;
create unique index location_names_lower_has_parent on housedb.locations( lower(name), parent_id ) where parent_id is not null;