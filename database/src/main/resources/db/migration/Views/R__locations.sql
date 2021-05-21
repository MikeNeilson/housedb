create or replace view housedb.view_locations as
    select id,
            housedb_locations.expand_location_name(
                id
            ) AS name,
            parent_id
    from housedb.locations
;

