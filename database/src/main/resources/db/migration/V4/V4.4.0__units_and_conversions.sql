do $$
begin 
    if not exists (select 1 from information_schema.schemata where schema_name = 'housedb_units') then   
        create schema housedb_units;
    end if;
end;
$$ ;
create table housedb.units(
    unit text primary key,
    unitClass text not null,
    system varchar(255) not null,
    description text
);

create table housedb.units_parameters(
    unit text references housedb.units(unit),
    parameter_id bigint references housedb.parameters(id),
    is_default boolean,
    primary key (unit,parameter_id)
);

create table housedb_units.conversions(
    unit_from text references housedb.units(unit),
    unit_to text references housedb.units(unit),
    postfix_func text not null,
    primary key (unit_from,unit_to)
);

create or replace view housedb.units_for_parameters as 
    select 
        p.name,
        u.unit,
        u.system,
        u.description,
        up.is_default
    from
        housedb.units u
    join housedb.units_parameters up on up.unit = u.unit
    join housedb.parameters p on p.id = up.parameter_id
;