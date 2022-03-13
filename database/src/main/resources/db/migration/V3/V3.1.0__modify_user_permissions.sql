-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

alter table housedb.user_permissions drop constraint user_permissions_pkey;

alter table housedb.user_permissions add constraint user_permissions_pkey primary key (user_id,permission_id,data_table_id,regex);

do $$
declare
    admin_id bigint;
begin 
    insert into housedb.users(username,active) values ('admin',true) returning id into admin_id;
    alter table housedb.user_permissions
        add column granter_id bigint,
        add constraint granter_id_fkey foreign key (granter_id) references housedb.users(id);

    update housedb.user_permissions set granter_id = admin_id where granter_id is null;

    alter table housedb.user_permissions alter column granter_id set not null;
    
end;
$$