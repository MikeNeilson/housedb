package net.hobbyscience.housedb.dao;

import java.sql.Connection;
import javax.sql.DataSource;
import java.util.logging.*;
import java.util.List;
import java.util.ArrayList;

import net.hobbyscience.housedb.housedb.tables.*;
import net.hobbyscience.housedb.housedb_security.Routines;
import net.hobbyscience.housedb.*;
import static org.jooq.impl.DSL.*;

import org.jooq.*;
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
        Routines.setSessionUser(dsl.configuration(),username);
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
}