-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

-- ${flyway:timestamp}

create or replace function housedb_timeseries.error_no_conversion() returns text as $$ begin return 'ZX091'; end; $$ language plpgsql;
create or replace function housedb_timeseries.error_bad_formula() returns text as $$ begin return 'ZX092'; end; $$ language plpgsql;

create or replace function housedb.convert_units(p_value double precision, p_from text, p_to text )
returns double precision
as $$
declare
    conv_function text;
    step text;
    conv_steps text[];    
    left double precision;
    right double precision;
    tmp double precision;
begin
    if p_from = p_to then
        return p_value;
    else
        select 
            into conv_function postfix_func
        from housedb_units.conversions
        where unit_from = p_from and unit_to = p_to;
            
        if not found then
            raise exception 'Cannot find conversions from % to %', p_from, p_to using errcode ='ZX091';
        end if;
        select regexp_split_to_array(conv_function,' ') into conv_steps;
        create temp table stack(id serial primary key, val double precision );
        foreach step in array conv_steps
        loop
            case step 
                when 'i' then
                    insert into stack(val) values (p_value);
                when '+' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp := "left" + "right";
                    insert into stack(val) values( tmp );
                when '-' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp = "left" - "right";
                    insert into stack(val) values( tmp );
                when '*' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp = "left" * "right";
                    insert into stack(val) values( tmp );
                when '/' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp = "left" / "right";
                    insert into stack(val) values ( tmp );
                when '^' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp = "left" ^ "right";
                    insert into stack(val) values ( tmp );
                when 'nroot' then
                    delete from stack where id = (select max(id) from stack) returning val into right;
                    delete from stack where id = (select max(id) from stack) returning val into left;
                    tmp = "left" ^ (1.0/"right");
                    insert into stack(val) values ( tmp );
                else
                    tmp = step::double precision;
                    insert into stack(val) values(tmp);
            end case;
        end loop;
        
        delete from stack where id = (select max(id) from stack) returning val into left;
        select into right count(*) from stack;
        drop table stack;
        if "right" > 0 then
            raise exception '% values left on stack, bad calculation formula', "right" using errcode='ZX092';
        end if;
        return left;
    end if;
end;
$$ language plpgsql;