\c housedb
CREATE SCHEMA HOUSEDB_TESTS;

\i src/test/sql/timeseries_test.sql
\i src/test/sql/location_test.sql

GRANT USAGE on SCHEMA housedb_tests to housedb_user;
