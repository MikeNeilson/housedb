grant usage on schema authdb to authdb_user;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA authdb to authdb_user; 
GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA authdb TO authdb_user;
