CREATE ROLE housedb_owner WITH PASSWORD 'housepassword' LOGIN;
CREATE ROLE housedb_user WITH PASSWORD 'testpassword' LOGIN;
CREATE DATABASE housedb OWNER housedb_owner;
ALTER DATABASE housedb set search_path = housedb, "$user", public;