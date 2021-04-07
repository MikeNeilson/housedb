CREATE ROLE housedb_owner WITH PASSWORD 'housepassword' LOGIN;
CREATE ROLE housedb_user WITH PASSWORD 'testpassword' LOGIN;
CREATE DATABASE housedb OWNER housedb_owner;
GRANT ALL PRIVILEGES ON DATABASE housedb to housedb_owner;