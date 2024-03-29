-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

DROP FUNCTION IF EXISTS housedb.store_timeseries_data ( character varying, housedb.data_triple[], overwrite boolean);
DROP FUNCTION IF EXISTS housedb.retrieve_timeseries_data( text, timestamp with time zone, timestamp with time zone, excludenulls boolean );