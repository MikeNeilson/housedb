package net.hobbyscience.housedb.api.controllers;

import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*;
import net.hobbyscience.housedb.dao.*;

import java.util.logging.Logger;

import javax.sql.DataSource;

public class LocationController implements CrudHandler {
    public static final Logger logger = Logger.getLogger(LocationController.class.getName());

    @OpenApi(
        tags = {"Locations"},
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location[].class,isArray=true)})
        }
    )
    @Override 
    public void getAll( Context ctx){
        logger.log(ctx.attribute("username"));
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection(); ){        
            var db = new HouseDb(conn,ctx.attribute("username"));
            var locations = db.getAllLocations();
            ctx.json(locations);
        } catch( Exception err ){
            throw new RuntimeException("Error retrieving locations",err);
        }
    }

    @OpenApi(
        tags = {"Locations"},
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location.class)})
        }
    )
    public void getOne( Context ctx, String locationName ){
        throw new UnsupportedOperationException("not implemented yet");
    }

    @OpenApi(
        tags = {"Locations"},
        requestBody = @OpenApiRequestBody(content = {@OpenApiContent(from = Location.class)}),
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location.class)})
        }
    )
    public void create(Context ctx) {
        var loc = ctx.bodyAsClass(Location.class);
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection(); ){        
            var db = new HouseDb(conn,ctx.attribute("username"));
            db.saveLocation(loc);
        } catch( Exception err ){
            throw new RuntimeException("Error creating location",err);
        }
    }

    
    @OpenApi(
        tags = {"Locations"}
    )
    public void update(Context ctx, String locationName){ throw new UnsupportedOperationException("not implemented yet"); }

    @OpenApi(
        tags = {"Locations"}
    )
    public void delete(Context ctx, String locationName){ throw new UnsupportedOperationException("not implemented yet"); }

}