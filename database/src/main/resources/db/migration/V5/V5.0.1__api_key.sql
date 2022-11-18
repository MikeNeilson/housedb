create table housedb.user_authorization (
    user_id bigserial not null references housedb.users(id),
    key_name text not null,
    apikey text not null,    
    created timestamp with time zone default current_timestamp,
    expires timestamp with time zone default current_timestamp + interval '90 days',
    primary key (user_id,key_name)
);
