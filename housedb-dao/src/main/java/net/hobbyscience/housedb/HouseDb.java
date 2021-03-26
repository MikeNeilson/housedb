package net.hobbyscience.housedb;

import java.sql.Connection;
import javax.sql.DataSource;
import java.util.logging.*;
import java.util.List;
import java.util.ArrayList;

import net.hobbyscience.housedb.tables.*;
import net.hobbyscience.housedb.*;
import static org.jooq.impl.DSL.*;

import org.jooq.*;
import org.jooq.impl.DSL;

public class HouseDb {
    private static final Logger logger = Logger.getLogger(HouseDb.class.getName());
    private DataSource ds = null;
    private String username = null;

    public HouseDb(DataSource ds, String username ){
        this.ds = ds;
        this.username = username;
    }

    public List<String> getAllLocations() throws Exception{
        ArrayList<String> locations = new ArrayList<>();
        try( Connection conn = ds.getConnection(); ){        
            DSLContext dsl = DSL.using(conn,SQLDialect.POSTGRES);

            Result<Record> result = dsl.selectDistinct().from(Locations.LOCATIONS).fetch();
            for( Record r: result ){
                long id = r.getValue(Locations.LOCATIONS.ID);
                String loc = r.getValue(Locations.LOCATIONS.NAME);
                Long parent_id = r.getValue(Locations.LOCATIONS.PARENT_ID);                
                if ( Routines.canPerform(dsl.configuration(),username,"READ","locations",loc)){
                    if ( parent_id != null ){
                        logger.info("expanding name");
                        locations.add( Routines.expandLocationName(dsl.configuration(),id));
                    } else {
                        locations.add(loc);
                    }
                }
            }
            return locations;
        } catch(Exception ex){
            logger.info(ex.getLocalizedMessage());
            throw ex;
        }        
    }
}