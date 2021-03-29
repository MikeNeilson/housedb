create schema housedb_locations;
create schema housedb_timeseries;
create schema housedb_security;

alter function housedb.create_location set schema housedb_locations;
alter function housedb.expand_location_name set schema housedb_locations;

alter function housedb.create_timeseries set schema housedb_timeseries;
alter function housedb.store_timeseries_data set schema housedb_timeseries;
alter function housedb.retrieve_timeseries_data set schema housedb_timeseries;

alter function housedb.can_perform set schema housedb_security;
alter function housedb.add_user set schema housedb_security;
alter function housedb.add_permission set schema housedb_security;
alter function housedb.set_session_user set schema housedb_security;
alter function housedb.get_session_user set schema housedb_security;