/*
    List of users who may have access to the database
*/
create table housedb.users (
    id bigserial primary key,
    username varchar(255) not null unique,
    active bool default true
);
/*
    list of permission types
*/
create table housedb.permissions (
    id serial primary key,
    name varchar(255) unique
);
/*
    list of possible tables for which we may have a permission on
*/
create table housedb.data_tables (
    id serial primary key,
    name varchar(255) unique
);

create table housedb.user_permissions (
    user_id bigint references housedb.users(id) not null,
    permission_id int references housedb.permissions(id) not null,
    data_table_id int references housedb.data_tables(id) not null,
    regex text not null,
    primary key (user_id,permission_id,data_table_id)
);
comment on column user_permissions.regex is 'regular expression that will be matched against what the user is requesting.';


/* default permissions */
insert into housedb.permissions(name)
    values ('READ'),
           ('WRITE'),
           ('UPDATE')
;

/* data tables */
insert into housedb.data_tables (name)
    values ('locations'),
           ('timeseries'),
           ('intervals'),
           ('types'),
           ('parameters')
;

/* guest user */
insert into housedb.users(id,username,active)
    values (0,'guest',true);
