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
import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.Unit;
import net.hobbyscience.database.exceptions.InvalidMethod;
import net.hobbyscience.database.methods.Function;
import net.hobbyscience.database.methods.Linear;
import net.hobbyscience.database.methods.USGS;

import net.objecthunter.exp4j.*;
import net.objecthunter.exp4j.shuntingyard.ShuntingYard;
import net.objecthunter.exp4j.tokenizer.Token;

public class R__unit_conversions extends BaseJavaMigration{
    public HashSet<Conversion> conversions = new HashSet<>();
    public HashSet<Unit> units = new HashSet<>();
    //public ArrayList<Parameters> parameters = new ArrayList<>();
    public int checksum;

    public void init() throws Exception{
        System.out.println("Create conversions.");
        CRC32 crc = new CRC32();
        int line_num = 1;
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
                if( !conversions.add(new Conversion(from,to,method))){
                    System.out.println("You have a duplicate conversion on line " + line_num);
                }   
                HashSet<String> vars = new HashSet<>();  
                vars.add("i");        
                for( Conversion c: conversions ){                
                    Expression e = new ExpressionBuilder(c.getMethod().getAlgebra()).variables("i").build();
                    System.out.println(e.toString());
                    
                    Token tokens[] = ShuntingYard.convertToRPN(c.getMethod().getAlgebra(), null, null, vars, false);
                    for( Token tok: tokens ){
                        System.out.print(tok.toString()+ " ");
                    }
                    System.out.println();
                }   
                line_num += 1;
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

    @Override
    public Integer getChecksum(){
        return Integer.valueOf(checksum);
    }
   
}
