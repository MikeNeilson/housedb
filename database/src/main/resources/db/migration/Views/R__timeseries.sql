-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

create or replace view housedb.timeseries_values as 
      select 
        itv.timeseries_id as ts_id,        
        tscat.timeseries_name as name,
        itv.date_time as date_time,
        itv.value as value,
        itv.quality as quality,
        parms.units as units
      from 
        housedb.internal_timeseries_values itv
      join housedb.catalog tscat on itv.timeseries_id = tscat.id
      join housedb.parameters parms on tscat.parameter = parms.name
      order by timeseries_id,date_time;

drop trigger if exists insert_tsv_trigger on housedb.timeseries_values;
create trigger insert_tsv_trigger instead of insert or update or delete on housedb.timeseries_values 
    for each row execute procedure housedb_timeseries.insert_tsv();      