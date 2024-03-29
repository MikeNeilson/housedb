-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

drop function if exists housedb.create_location( text );

create view housedb.view_locations as 
    select id,housedb.expand_location_name(id) as name,parent_id from housedb.locations;


--GRANT SELECT ON housedb.view_locations to housedb_user;