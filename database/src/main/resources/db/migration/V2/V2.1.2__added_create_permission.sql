-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

insert into housedb.permissions(name) values ('CREATE');
insert into housedb.permissions(name) values ('DELETE');
insert into housedb.permissions(name) values ('STORE');


CREATE UNIQUE INDEX permission_names_lower on housedb.permissions( lower(name) );