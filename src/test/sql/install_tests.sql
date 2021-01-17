\c housedb
CREATE SCHEMA HOUSEDB_TESTS;

\i src/test/sql/timeseries_test.sql

GRANT USAGE on SCHEMA housedb_tests to housedb_user;
