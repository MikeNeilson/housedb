GRANT USAGE ON SCHEMA housedb to housedb_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA housedb to housedb_user; 
GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA housedb TO housedb_user;
GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA housedb_units TO housedb_user;

grant usage on schema housedb_security to housedb_user;
grant execute on all functions in schema housedb_security to housedb_user;

grant usage on schema housedb_locations to housedb_user;
grant execute on all functions in schema housedb_locations to housedb_user;

grant usage on schema housedb_timeseries to housedb_user;
grant execute on all functions in schema housedb_timeseries to housedb_user;

grant usage on schema housedb_units to housedb_user;
grant execute on all functions in schema housedb_units to housedb_user;