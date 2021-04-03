insert into housedb.permissions(name) values ('CREATE');
insert into housedb.permissions(name) values ('DELETE');
insert into housedb.permissions(name) values ('STORE');


CREATE UNIQUE INDEX permission_names_lower on housedb.permissions( lower(name) );