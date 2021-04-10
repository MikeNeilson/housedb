package db.migration;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.zip.CRC32;

import org.flywaydb.core.api.ResourceProvider;
import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import net.hobbyscience.database.Conversion;
import net.hobbyscience.database.Unit;

public class R__unit_conversions extends BaseJavaMigration{
    public ArrayList<Conversion> conversion = new ArrayList<>();
    public HashSet<Unit> units = new HashSet<>();
    //public ArrayList<Parameters> parameters = new ArrayList<>();
    public int checksum;

    public void init() throws Exception{
        System.out.println("Create conversions.");
        CRC32 crc = new CRC32();
        try(             
            InputStream units_conversions = this.getClass().getClassLoader().getResourceAsStream("net/hobbyscience/units/unit_conversions.csv");
            //InputStream parameters = this.getClass().getResourceAsStream("net/hobbyscience/units/parameters.csv");
            
            BufferedReader br = new BufferedReader( new InputStreamReader( units_conversions ) );
        ){
            System.out.println("reading lines");
            String line = null;
            while( (line = br.readLine()) != null ){
                if( line.trim().startsWith("#") ) continue;
                crc.update(line.getBytes());                
                String parts[] = line.trim().split(",");
                Unit from = new Unit(parts[0],parts[1],parts[3],parts[4]);
                Unit to = new Unit(parts[0],parts[2],parts[5],parts[6]);
                String method = parts[7];
                String data = parts[8];
                units.add(from);
                units.add(to);
                
            }
            Long crc_long = crc.getValue();
            checksum = crc_long.intValue();
            System.out.println("Checksum = " + checksum);
        } catch(NullPointerException ex){
            throw new Exception("Error reading data files",ex);
        } catch(Exception ex ){
            throw new Exception("Error reading data files",ex);
        }
        
    }
    

    @Override
    public void migrate(Context context) throws Exception {
        System.out.println("Showing resource files");
        this.init();  
        System.err.println("Building unit conversions");
        var conn = context.getConnection();
        var stmt = conn.createStatement();
        stmt.executeQuery("select 'making units'");               
    }

    @Override
    public String getDescription(){
        return "Build a fully expanded unit conversion table.";
    }
/*
    @Override
    public Integer getChecksum(){
        return 2;
    }
*/   
}
