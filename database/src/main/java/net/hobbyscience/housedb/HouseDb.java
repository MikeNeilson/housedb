package net.hobbyscience.housedb;

import java.sql.Connection;
import javax.sql.DataSource;

public class HouseDb {
    private DataSource ds = null;

    public HouseDb(DataSource ds ){
        this.ds = ds;
    }
}