/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

package db.migration.java.units;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Queue;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.zip.CRC32;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import db.migration.NoConversionFound;
import net.hobbyscience.ConversionGraph;
import net.hobbyscience.database.Conversion;
import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.Parameter;
import net.hobbyscience.database.Unit;
import net.hobbyscience.database.exceptions.InvalidMethod;
import net.hobbyscience.database.methods.ForDB;
import net.hobbyscience.database.methods.Function;
import net.hobbyscience.database.methods.Linear;
import net.hobbyscience.database.methods.USGS;
import net.hobbyscience.math.Equations;



public class R__unit_conversions extends BaseJavaMigration{
    public HashSet<Conversion> baseConversions = new HashSet<>();
    public HashSet<Unit> units = new HashSet<>();
    public HashSet<Parameter> parameters = new HashSet<>();

    //public ArrayList<Parameters> parameters = new ArrayList<>();
    public int checksum;

    public void init() throws Exception{
        System.out.println("Create conversions.");
        CRC32 crc = new CRC32();
        int line_num = 1;
        try(             
            InputStream units_conversions = this.getClass().getClassLoader().getResourceAsStream("net/hobbyscience/units/unit_conversions.csv");
            InputStream parameters_csv =        this.getClass().getClassLoader().getResourceAsStream("net/hobbyscience/units/parameters.csv");
            
            BufferedReader br = new BufferedReader( new InputStreamReader( units_conversions ) );
            BufferedReader parm_br = new BufferedReader( new InputStreamReader( parameters_csv ) );
        ){            
            System.out.println("reading lines");
            String line = null;
            while( (line = br.readLine()) != null ){

                if( line.trim().startsWith("#") || line.trim().isEmpty() ) continue;
                System.out.println("processing: " + line);
                crc.update(line.getBytes());                
                String parts[] = line.trim().split(",");
                Unit from = new Unit(parts[0].trim(),parts[1].trim(),parts[3].trim(),parts[4].trim());
                Unit to = new Unit(parts[0].trim(),parts[2].trim(),parts[5].trim(),parts[6].trim());
                String method_str = parts[7].trim();
                String data = parts[8].trim();
                ConversionMethod method = null;
                switch( method_str.toLowerCase() ){
                    case "linear": { method = new Linear(data); break; } 
                    case "usgs": { method = new USGS(data); break; }
                    case "func": { method = new Function(data); break; }
                    default :{
                        throw new InvalidMethod("invalid method " + method_str + " on line " + line_num);
                    }
                }
                units.add(from);
                units.add(to);
                if( !baseConversions.add(new Conversion(from,to,method))){
                    System.out.println("You have a duplicate conversion on line " + line_num);
                }   

                line_num += 1;
            }
                        
            while( (line = parm_br.readLine()) != null ){

                if( line.trim().startsWith("#") || line.trim().isEmpty() ) continue;
                System.out.println("processing: " + line);
                crc.update(line.getBytes());                
                String parts[] = line.trim().split(",");
                parameters.add( new Parameter(parts[0],parts[1],parts[2]));
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

    public R__unit_conversions() throws Exception{
        this.init();
    }

    @Override
    public void migrate(Context context) throws Exception {        
        
        System.err.println("Building unit conversions");
        var conn = context.getConnection();
        var conversions = new ConversionGraph(baseConversions).generateConversions();
        try( 
            var insert_conv = conn.prepareStatement("insert into housedb_units.conversions(unit_from,unit_to,postfix_func) values (?,?,?) on conflict (unit_from,unit_to) do update set postfix_func = EXCLUDED.postfix_func");
            var insert_unit = conn.prepareStatement("insert into housedb.units(unit,unitClass,system,description) values (?,?,?,?) on conflict (unit) do nothing");
            var insert_parameters = conn.prepareStatement("insert into housedb.parameters(name,units) values (?,?) on conflict do nothing");
        ){
            System.out.println("Inserting Units");
            for( Unit unit: units){
                insert_unit.setString(1,unit.getName());
                insert_unit.setString(2,unit.getUnit_class());
                insert_unit.setString(3,unit.getSystem());
                insert_unit.setString(4,unit.getDescription());
                insert_unit.addBatch();
                System.out.println(unit);
            }
            insert_unit.executeBatch();
            System.out.println("Inserting converions");
            for( Conversion c: conversions ){
                System.out.print(c.getFrom().getName() + " -> " + c.getTo().getName() + ": ");
                System.out.println( c.getMethod().getPostfix() );                
                insert_conv.setString(1,c.getFrom().getName());
                insert_conv.setString(2,c.getTo().getName());
                insert_conv.setString(3,c.getMethod().getPostfix());       
                insert_conv.addBatch();
            }
            insert_conv.executeBatch();
            System.out.println("Inserting parameters");
            for( Parameter parm: parameters){
                insert_parameters.setString(1,parm.getName());
                insert_parameters.setString(2,parm.getStorageUnits());
                insert_parameters.addBatch();
            }
            insert_parameters.executeBatch();

        } catch( SQLException e ){
            throw new RuntimeException("Error adding unit conversions.",e);
        }

    }

    @Override
    public String getDescription(){
        return "Build a fully expanded unit conversion table.";
    }

    
    @Override
    public Integer getChecksum(){
        return Integer.valueOf(checksum);
    }
    
   
}
