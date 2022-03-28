create domain email_address as text
check(
        not null
        and
        VALUE ~ '.*@.*'        
) ;

create table garden_users (
    id serial not null primary key,
    username varchar(255) unique not null,
    email email_address unique not null
);


create table user_crendentials (
    id int not null primary key references garden_users(id),
    otp_key text,
    password_hash text
);
