create or replace function housedb.can_perform( p_username varchar(255), p_permission varchar(255), p_data_table varchar(255), p_object text ) 
returns boolean 
AS $$
DECLARE
    l_regex text;
BEGIN
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
    end if;
    return p_object ~ l_regex;
END;
$$ language plpgsql