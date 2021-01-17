
CREATE SCHEMA IF NOT EXISTS HOUSEDB_TESTS;

\i src/test/timeseries_test.sql

GRANT USAGE on SCHEMA housedb_tests to housedb_user;