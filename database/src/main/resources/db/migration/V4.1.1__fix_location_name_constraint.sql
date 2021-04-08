alter table housedb.locations drop constraint unique_name;
drop index location_names_lower;
create unique index location_names_lower on housedb.locations( lower(name), parent_id );