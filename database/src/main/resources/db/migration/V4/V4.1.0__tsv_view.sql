-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

create view housedb.timeseries_values as 
      select 
        itv.timeseries_id as ts_id,        
        tscat.timeseries_name as name,
        itv.date_time as date_time,
        itv.value as value,
        itv.quality as quality
      from 
        housedb.internal_timeseries_values itv
      join housedb.catalog tscat on itv.timeseries_id = tscat.id
      order by timeseries_id,date_time;