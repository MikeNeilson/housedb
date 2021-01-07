BEGIN
SELECT plan(1);

SELECT is( create_timeseries('Zone 1.Box 1.Moister.1Hour.0.raw'), 1, ' time series creation');




SELECT * from finish();
ROLLBACK;