CREATE ROLE housedb_owner WITH PASSWORD 'housepassword' LOGIN;
CREATE ROLE housedb_user WITH PASSWORD 'testpassword' LOGIN;
CREATE DATABASE housedb OWNER housedb_owner;