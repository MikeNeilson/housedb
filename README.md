# House TSDB


# Description
-----------

This is a database create to store time series database for monitoring my home and garden.


# How to Use


There are a few support function and some views, these should be used to interact with the database.
A time series is identified with the following format:

	Location[-Sublocation[.. up to 10 deep]].Measurement Name.Type.Interval.Duration.Version

For example:

	Front Yard-Rose Rushes nr Road.Soil Moisture.Inst.15Minutes.0.raw

Is the identifier for a time series the contains soil moisture for the roses in my front yard near the road. The data is Instantaneous sampled at 15 minute intervals and has no duration ( the value applies to a point in time. ) The version is arbitrary.

The duration would be used for average data. For example if we were to take the above data and average it for an hour (an average of 4 fifteen minute values) it would look like this:

	Front Yard-Rose Rushes nr Road.Soil Moisture.Ave.1Hour.1Hour.raw

Valid types are:
	
 - Inst
 - Ave
 - Min
 - Max
 - Total

The three primary function are 

| Function | Descrption |
| -------- | ---------- |
| create_timeseries(ts_name text) | creates a time series, without data, in the database within default interval_offset|
| create_timeseries(ts_name text, interval_offset interval) | create a new time series with the specified offset from <br />- daily -> midnight<br />- hourly -> the top the hour<br />- minutes -> the top of the hour |
| store_timeseries_data(ts_name, array of (time timestamp,value double,quality integer)| stores data into the database, creating a time series as needed |
| retrieve_timeseries_data(ts_name, start, end)| retrieve data from the database|
| catalog | lists the available time series in the database|
|create_location(location_name) | Inserts a new location in the locations table, creating all the intermediate locations as required.|
|expend_location_name(location_id) | Takes the lowested level location and expands out it's parents|


# Why another Timseries database in SQL

Wanted simple database for home/garden automation. I'm familiar with SQL and wanted to work with it more. 
And I wanted a place to expirement with how timeseries data interacts with an RDBMS.
