drop view housedb.view_locations;

drop function if exists housedb.expand_location_name cascade;
create function housedb_locations.expand_location_name( bigint ) returns text as $$ BEGIN return "forward declaration"; END; $$ language plpgsql;

create or replace view housedb.view_locations as 
    select id,housedb_locations.expand_location_name(id) as name,parent_id from housedb.locations;

CREATE VIEW housedb.catalog_view AS
    SELECT ts.id AS id, 			
			housedb_locations.expand_location_name(
                (SELECT locations.id FROM housedb.locations locations WHERE (locations.id = ts.location_id)) 
            ) AS location, 
			(SELECT parameters.name FROM housedb.parameters parameters WHERE (parameters.id = ts.parameter_id)) AS parameter, 
			(SELECT types.name FROM housedb.types types WHERE (types.id = ts.type_id)) AS type, 
			(SELECT intervals.name FROM housedb.intervals intervals WHERE (intervals.id = ts.interval_id)) AS "interval",
			(SELECT intervals.name FROM housedb.intervals intervals WHERE (intervals.id = ts.duration_id)) AS duration,
			ts.version 
	FROM 
		housedb.timeseries ts			
	;

CREATE VIEW housedb.catalog AS
    SELECT catalog_view.id,
           (catalog_view.location)::text   || '.'::text 
        || (catalog_view.parameter)::text  || '.'::text
        || (catalog_view.type)::text       || '.'::text 
        || (catalog_view."interval")::text || '.'::text 
        || (catalog_view.duration)::text   || '.'::text 
        || (catalog_view.version)::text AS timeseries_name,
           catalog_view.parameter, 
           catalog_view.type, 
           catalog_view."interval", 
           catalog_view.duration, 
           catalog_view.version 
    FROM 
        housedb.catalog_view;