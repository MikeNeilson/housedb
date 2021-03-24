package net.hobbyscience.housedb;

import java.sql.Connection;
import javax.sql.DataSource;
import java.util.logging.*;
import java.util.List;
//import housedb.tables.Records.*;

public class HouseDb {
    private static final Logger logger = Logger.getLogger(HouseDb.class.getName());
    private DataSource ds = null;

    public HouseDb(DataSource ds ){
        this.ds = ds;
    }

    public List<String> getAllLocations() throws Exception{
        try( Connection conn = ds.getConnection(); ){
            return null;
        } catch(Exception ex){
            logger.info(ex.getLocalizedMessage());
            throw ex;
        }        
    }
}