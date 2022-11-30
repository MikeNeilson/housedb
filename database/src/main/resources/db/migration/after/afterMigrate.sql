-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

GRANT USAGE ON SCHEMA housedb to housedb_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA housedb to housedb_user;
GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA housedb TO housedb_user;
GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA housedb_units TO housedb_user;

grant usage on schema housedb_security to housedb_user;
grant execute on all functions in schema housedb_security to housedb_user;
grant select,insert,update,delete,references,trigger on housedb_security.active_user_auth_keys to housedb_user;

grant usage on schema housedb_locations to housedb_user;
grant execute on all functions in schema housedb_locations to housedb_user;

grant usage on schema housedb_timeseries to housedb_user;
grant execute on all functions in schema housedb_timeseries to housedb_user;

grant usage on schema housedb_units to housedb_user;
grant execute on all functions in schema housedb_units to housedb_user;