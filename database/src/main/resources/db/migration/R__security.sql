create or replace function housedb_security.can_perform__( p_username varchar(255), p_permission varchar(255), p_data_table varchar(255), p_object text ) 
returns boolean
AS $$
DECLARE
    l_regex text;
    l_cando boolean;
BEGIN
    set search_path to housedb_security,housedb,public;
    select 
        up.regex into l_regex 
        from 
           user_permissions up
        join users u on u.id = up.user_id
        join permissions p on p.id = up.permission_id
        join data_tables dt on dt.id = up.data_table_id
        where 
            u.username = p_username
            and
            p.name = p_permission
            and
            dt.name = p_data_table;

    if l_regex is null THEN
        return false;
    else
        return p_object ~ l_regex;
    end if;
    
END;
$$ language plpgsql;

create or replace function housedb_security.can_perform( p_username varchar(255), p_permission varchar(255), p_data_table varchar(255), p_object text ) 
returns void
as $$
declare
    l_cando boolean;
begin
    --raise notice 'checking (%,%,%,%)',p_username,p_permission,p_data_table,p_object;
    set search_path to housedb_security,housedb,public;

    if can_perform__(p_username,p_permission,p_data_table,p_object) THEN
        raise notice 'user has permission';--return
    elsif can_perform__('guest',p_permission,p_data_table,p_object) then 
        raise notice 'guest has permission'; --return -- all users can always do what a guest can
    else 
        raise exception 'User % has no % permission to object %s',p_username,p_permission,p_object USING ERRCODE= 'PX001';
    end if;    
end;
$$ language plpgsql;


create or replace function housedb_security.add_permission( p_username varchar(255), p_permission varchar(255), p_data_table varchar(255), p_regex text )
RETURNS boolean
AS $$
DECLARE
    l_userid bigint;
    l_perm_id int;
    l_dt_id int;
BEGIN
    set search_path to housedb,public;
    select id into l_userid from users where username = p_username;
    select id into l_perm_id from permissions where name = p_permission;
    select id into l_dt_id from data_tables where name = p_data_table;
    if l_userid is null then 
        raise exception 'Unrecognized Username %', p_username::text;
    elsif l_perm_id is null then 
        raise exception 'Unrecognized permission %', p_permission;
    elsif l_dt_id is null THEN
        raise exception 'Unrecognized data table %', p_data_table;
    end if;
    insert into user_permissions(user_id,permission_id,data_table_id,regex) values (l_userid,l_perm_id,l_dt_id,p_regex);
    return true;
END;
$$ language plpgsql;

create or replace function housedb_security.set_session_user( p_username varchar(255) )
returns boolean
as $$
declare
    l_userid bigint;
begin
    set search_path to housedb,public;

    select id into l_userid from users where username = p_username;
    if l_userid is not null then 
        perform set_config('housedb.user', p_username::text, false);
        return true;
    else 
        raise exception 'User % does not exist in this database', p_username using ERRCODE = 'PX000';
    end if;
end;
$$ language plpgsql;

create or replace function housedb_security.get_session_user()
returns text
as $$
declare
    l_username varchar(255);
begin
    set search_path to housedb_security,housedb,public;

    select current_setting('housedb.user',true) into l_username;
    if l_username is null or l_username = '' then 
        --raise notice 'user not set, defaulting to guest';
        perform set_session_user('guest');
        l_username := 'guest';
    end if;
    raise notice 'setting user to %', l_username;
    return l_username;
end;
$$ language plpgsql;

create or replace function housedb_security.add_user( p_username text, p_active boolean default true)
returns bigint
as $$
declare
    l_userid bigint;
begin 
    set search_path to housedb,public;

    select id into l_userid from users where lower(username) = p_username;
    if l_userid is not null then
        raise exception 'User ''%'' already exists in this database', p_username USING ERRCODE = 'unique_violation';
    else 
        insert into users(username,active) values ( p_username,p_active) returning id into l_userid;
        return l_userid;
    end if;
end;
$$ language plpgsql
