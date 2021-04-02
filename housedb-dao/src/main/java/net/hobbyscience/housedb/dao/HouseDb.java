package net.hobbyscience.housedb.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import javax.sql.DataSource;
import java.util.logging.*;
import java.util.stream.Collectors;
import java.util.List;
import java.util.ArrayList;

import net.hobbyscience.housedb.housedb.tables.*;
import net.hobbyscience.housedb.housedb.udt.records.DataTripleRecord;
import net.hobbyscience.housedb.housedb_security.Routines;
import net.hobbyscience.housedb.housedb_timeseries.Tables;
import net.hobbyscience.housedb.housedb_timeseries.tables.records.RetrieveTimeseriesDataRecord;

import static net.hobbyscience.housedb.housedb_timeseries.Tables.*;
import net.hobbyscience.housedb.*;
import static org.jooq.impl.DSL.*;

import org.jooq.*;
import org.jooq.exception.*;
import org.jooq.impl.DSL;

public class HouseDb {
    private static final Logger logger = Logger.getLogger(HouseDb.class.getName());
    private DataSource ds = null;
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

    public HouseDb setDataSource(DataSource ds ){
        this.ds = ds;
        return this;
    }

    public HouseDb setUsername(String username){
        this.username = username;
        return this;
    }

    public List<String> getAllLocations() throws Exception{
        ArrayList<String> locations = new ArrayList<>();

        Result<Record> result = dsl.selectDistinct().from(ViewLocations.VIEW_LOCATIONS).fetch();
        for( Record r: result ){
            long id = r.getValue(Locations.LOCATIONS.ID);
            String loc = r.getValue(Locations.LOCATIONS.NAME);
            Long parent_id = r.getValue(Locations.LOCATIONS.PARENT_ID);                
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
        DataTripleRecord []dtrs = ts.getData().stream().map( dt -> dt.asDataTripleRecord() ).collect( Collectors.toList() ).toArray(new DataTripleRecord[0]);
        
        net.hobbyscience.housedb.housedb_timeseries.Routines.storeTimeseriesData(dsl.configuration(),ts.getName(),dtrs,Boolean.TRUE);
    }

    public TimeSeries getTimeSeries(TimeSeries ts) throws Exception {
        List<DataTriple> dts = new ArrayList<DataTriple>();        
        Result<RetrieveTimeseriesDataRecord> results = dsl.selectFrom(
                                    RETRIEVE_TIMESERIES_DATA( 
                                        ts.getName(),
                                        OffsetDateTime.of(0, 1, 1, 0, 0, 0, 0, ZoneOffset.ofHours(0)),
                                        OffsetDateTime.of(2022, 1, 1, 0, 0, 0, 0, ZoneOffset.ofHours(0)),
                                        "UTC", false)).fetch();
        dts = results.stream().map( dtr -> {
            DataTriple dt = new DataTriple();
            dt.dateTime = (OffsetDateTime) dtr.get("DateTime");
            dt.value = (double) dtr.get("value");
            dt.quality = (int) dtr.get("quality");
            return dt;
        } ).collect( Collectors.toList());
        ts.setData(dts);
        return ts;
    }

}