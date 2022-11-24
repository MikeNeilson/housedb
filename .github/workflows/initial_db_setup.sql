create extension citext;

CREATE ROLE housedb_owner WITH PASSWORD 'housepassword' LOGIN;
CREATE ROLE housedb_user WITH PASSWORD 'testpassword' LOGIN;
CREATE DATABASE housedb OWNER housedb_owner;
GRANT ALL PRIVILEGES ON DATABASE housedb to housedb_owner;

CREATE ROLE authdb_owner WITH PASSWORD 'authpassword' LOGIN;
CREATE ROLE authdb_user WITH PASSWORD 'authuserpassword' LOGIN;
CREATE DATABASE authdb OWNER authdb_owner;
GRANT ALL PRIVILEGES ON DATABASE authdb to authdb_owner;