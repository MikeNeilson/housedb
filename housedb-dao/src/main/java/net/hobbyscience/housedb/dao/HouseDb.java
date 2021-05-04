package net.hobbyscience.housedb.dao;

import java.sql.Connection;
import java.time.OffsetDateTime;

import java.util.logging.*;
import java.util.stream.Collectors;
import java.util.List;
import java.util.ArrayList;

import static net.hobbyscience.housedb.housedb.Routines.*;
import net.hobbyscience.housedb.housedb.tables.*;

import static net.hobbyscience.housedb.housedb.tables.TimeseriesValues.*;
import static net.hobbyscience.housedb.housedb.tables.Timeseries.*;
import static net.hobbyscience.housedb.housedb.tables.Catalog.*;
import static net.hobbyscience.housedb.housedb.tables.Parameters.*;
import static net.hobbyscience.housedb.housedb.tables.Intervals.*;
import net.hobbyscience.housedb.housedb_security.Routines;

import static org.jooq.impl.DSL.*;

import org.jooq.*;
import org.jooq.conf.ParamType;
import org.jooq.exception.*;
import org.jooq.impl.DSL;
import org.jooq.types.YearToSecond;

public class HouseDb {
    private static final Logger logger = Logger.getLogger(HouseDb.class.getName());    
    private String username = null;
    private DSLContext dsl = null;

    public HouseDb(){

    }

    public HouseDb(Connection conn, String username ){
        dsl = DSL.using(conn,SQLDialect.POSTGRES);
        try {
            Routines.setSessionUser(dsl.configuration(),username);
        } catch( DataAccessException err ){  
            logger.info(err.sqlState());
            if( !err.sqlState().equalsIgnoreCase("PX000") ){
                throw err;
            } // else continue as guest
        }
        
        this.username = username;
    }    

    public HouseDb setUsername(String username){
        this.username = username;
        return this;
    }

    public List<String> getAllLocations() throws Exception{
        ArrayList<String> locations = new ArrayList<>();

        Result<Record> result = dsl.selectDistinct().from(ViewLocations.VIEW_LOCATIONS).fetch();
        for( Record r: result ){            
            String loc = r.getValue(Locations.LOCATIONS.NAME);            
            Routines.canPerform(dsl.configuration(),username,"READ","locations",loc);
            locations.add(loc);                
        }
        return locations;        
    }

    public void saveLocation(Location loc) throws Exception {
        logger.info(username);
        logger.info(Routines.getSessionUser(dsl.configuration()));
        net.hobbyscience.housedb.housedb_locations.Routines.createLocation(dsl.configuration(),loc.getName(),true);
    }

    public void saveTimeSeries(TimeSeries ts) throws Exception {    
        //DataTripleRecord []dtrs = ts.getData().stream().map( dt -> dt.asDataTripleRecord() ).collect( Collectors.toList() ).toArray(new DataTripleRecord[0]);

        dsl.transaction( config -> {
            var insert = DSL.using(config).insertInto(TIMESERIES_VALUES, TIMESERIES_VALUES.NAME, TIMESERIES_VALUES.DATE_TIME, TIMESERIES_VALUES.VALUE, TIMESERIES_VALUES.QUALITY, TIMESERIES_VALUES.UNITS);
            ts.getData().stream().forEach( dt -> {
                insert.values( ts.getName(), dt.dateTime, dt.value, dt.quality, ts.getUnits() );
            });              
            insert.execute(); // TODO: consider returning to user;
        });        
        
        //net.hobbyscience.housedb.housedb_timeseries.Routines.storeTimeseriesData(dsl.configuration(),ts.getName(),dtrs,Boolean.TRUE);
    }

    private Result<Record3<OffsetDateTime, Double, Integer>> getIrregularInterval(TimeSeries ts, OffsetDateTime start, OffsetDateTime end, String timeZone, String unitsFrom, String unitsTo ){
        return dsl.select( 
                field("date_time",OffsetDateTime.class),
                convertUnits(field("value",Double.class),value(unitsFrom), value(unitsTo) ),
                field("quality",Integer.class)
                //field("units",String.class)
            ).from(TIMESERIES_VALUES)
             .where(TIMESERIES_VALUES.NAME.equalIgnoreCase(ts.getName()))
             .and(TIMESERIES_VALUES.DATE_TIME.between(start,end)).fetch();            
    }

    private Result<Record3<OffsetDateTime, Double, Integer>> getRegularInterval(TimeSeries ts, OffsetDateTime start, OffsetDateTime end, String timeZone, String unitsFrom, String unitsTo ){
        var gs = table("generate_series(?::timestamp,?::timestamp,?::interval)",start,end,ts.getInterval()).as("gs");
        var tv = TIMESERIES_VALUES.as("tv");
        var gs_dt = field("{0}.gs",OffsetDateTime.class, gs);
        var query = dsl.select(
            field("gs",OffsetDateTime.class).as("date_time"),
            convertUnits(field("tv.value",Double.class),value(unitsFrom), value(unitsTo) ),
            tv.QUALITY 
        //    value(unitsTo) // the conversion works or this query fails
        ).from(
            gs
        )
        .leftOuterJoin(tv).on(
                gs_dt.eq(tv.DATE_TIME).and(tv.NAME.eq(ts.getName()))
        );
        //.where(TIMESERIES_VALUES.NAME.equalIgnoreCase(ts.getName()));
        logger.info( query.getSQL());
        logger.info( query.getSQL(ParamType.INLINED));
        return query.fetch();
    }

    public TimeSeries getTimeSeries(TimeSeries ts, OffsetDateTime start, OffsetDateTime end, String timeZone, String units, boolean excludeMissing) throws Exception {
        List<DataTriple> dts = new ArrayList<DataTriple>();    
        
        Record3<String,String,String> offset_units = dsl.select(
                                    TIMESERIES.INTERVAL_OFFSET.concat(""),
                                    PARAMETERS.UNITS,
                                    INTERVALS.TIME_INTERVAL.concat("")
                                  ).from(TIMESERIES)
                                   .join(CATALOG).on(TIMESERIES.ID.eq(CATALOG.ID))
                                   .join(PARAMETERS).on(TIMESERIES.PARAMETER_ID.eq(PARAMETERS.ID))
                                   .join(INTERVALS).on(TIMESERIES.INTERVAL_ID.eq(INTERVALS.ID))
                                   .where(
                                        upper(CATALOG.TIMESERIES_NAME).eq( upper(ts.getName() ))
                                    ).fetchOne();
                                  ;
        String unitsFrom = offset_units.value2();
        String unitsTo = units != null ? units : unitsFrom;
        String interval = offset_units.value3();
        logger.info(interval.toString());        
        ts.setIntervalOffset(offset_units.value1());
        ts.setInterval(interval);
        var results = 
            interval.equals("00:00:00") ? 
                getIrregularInterval(ts, start, end, timeZone, unitsFrom, unitsTo)
                :
                getRegularInterval(ts,start,end,timeZone,unitsFrom,unitsTo);
            
        dts = results.stream().map( dtr -> {
            logger.info(dtr.toString());
            DataTriple dt = new DataTriple();
            dt.dateTime = dtr.value1();
            dt.value = dtr.value2() != null ? dtr.value2() : Double.NaN;
            dt.quality = dtr.value3() != null ? dtr.value3() : 0;
            return dt;
        } ).collect( Collectors.toList());
        ts.setUnits(unitsTo);        
        ts.setData(dts);
        return ts;
         
    }



}