-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

\c housedb
CREATE SCHEMA HOUSEDB_TESTS;

\i src/test/sql/timeseries_test.sql
\i src/test/sql/location_test.sql
\i src/test/sql/security_test.sql
\i src/test/sql/units_test.sql

GRANT USAGE on SCHEMA housedb_tests to housedb_user;
