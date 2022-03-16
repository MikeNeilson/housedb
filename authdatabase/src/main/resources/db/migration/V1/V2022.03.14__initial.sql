create domain email_address as text
check(
        not null
        and
        VALUE ~ '.*@.*'        
) ;

create table users (
    id serial not null primary key,
    username varchar(255) unique,
    email email_address unique    
);


create table user_crendentials (
    id int not null primary key references users(id),
    otp_key text,
    password_hash text
);
