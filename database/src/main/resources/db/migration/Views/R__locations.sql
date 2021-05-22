create or replace view housedb.view_locations as
    select id,
            housedb_locations.expand_location_name(
                id
            ) AS name,
            parent_id,
            housedb_locations.expand_location_name(
                parent_id
            ) AS parent,
            latitude,
            longitude,
            horizontal_datum,
            elevation,
            vertical_datum
    from housedb.locations
;

drop trigger if exists insert_location_trigger on housedb.view_locations;
create trigger insert_location_trigger instead of insert or update or delete on housedb.view_locations
    for each row execute procedure housedb_timeseries.insert_location();
