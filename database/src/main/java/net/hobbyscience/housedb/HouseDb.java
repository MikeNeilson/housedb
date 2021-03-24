package net.hobbyscience.housedb;

import java.sql.Connection;
import javax.sql.DataSource;
import java.util.logging.*;
import java.util.List;
import java.util.ArrayList;

import housedb.tables.*;
import static org.jooq.impl.DSL.*;

import org.jooq.*;
import org.jooq.impl.DSL;

public class HouseDb {
    private static final Logger logger = Logger.getLogger(HouseDb.class.getName());
    private DataSource ds = null;

    public HouseDb(DataSource ds ){
        this.ds = ds;
    }

    public List<String> getAllLocations() throws Exception{
        ArrayList<String> locations = new ArrayList<>();
        try( Connection conn = ds.getConnection(); ){
            DSLContext dsl = DSL.using(conn,SQLDialect.POSTGRES);
            Result<Record> result = dsl.select().from(Locations.LOCATIONS).fetch();
            for( Record r: result ){
                locations.add(r.getValue(Locations.LOCATIONS.NAME));
            }
            return locations;
        } catch(Exception ex){
            logger.info(ex.getLocalizedMessage());
            throw ex;
        }        
    }
}