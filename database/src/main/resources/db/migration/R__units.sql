create or replace function housedb.convert_units(p_value double precision, p_from text, p_to text )
returns double precision
as $$
begin
    return p_value;
end;
$$ language plpgsql;