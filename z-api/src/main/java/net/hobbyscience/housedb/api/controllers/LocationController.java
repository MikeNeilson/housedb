package net.hobbyscience.housedb.api.controllers;

import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*;
import net.hobbyscience.housedb.api.NotAuthorized;
import net.hobbyscience.housedb.dao.*;
import net.hobbyscience.housedb.dto.Location;

import java.sql.SQLException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.jooq.exception.DataAccessException;

public class LocationController implements CrudHandler {
    public static final Logger logger = Logger.getLogger(LocationController.class.getName());

    @OpenApi(
        tags = {"Locations"},
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location[].class,isArray=true)})
        },
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        }
    )
    @Override 
    public void getAll( Context ctx){
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection(); ){        
            var db = new HouseDb(conn,ctx.attribute("username"));
            var locations = db.locationDao().getAll();
            ctx.json(locations);
        } catch( Exception err ){
            throw new RuntimeException("Error retrieving locations",err);
        }
    }

    @OpenApi(
        pathParams = {
            @OpenApiParam(name="location-name",description = "Name of the location you're trying to look up.")
        },        
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location.class)})
        },
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        },
        tags = {"Locations"}
    )
    public void getOne( Context ctx, String locationName ){
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection(); ){
            var db = new HouseDb(conn,ctx.attribute("username"));
            var loc = db.locationDao().getByUniqueName(locationName);
            if( loc.isPresent() ){
                ctx.json(loc.get()).contentType("application/json");
            } else {
                ctx.result("Location not found").status(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch( SQLException err ){
            throw new RuntimeException("Database error",err);
        }
    }

    @OpenApi(
        tags = {"Locations"},
        requestBody = @OpenApiRequestBody(content = {@OpenApiContent(from = Location.class)}),
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = Location.class)})
        },
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        }
    )
    public void create(Context ctx) {
        var loc = ctx.bodyAsClass(Location.class);
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection(); ){        
            var db = new HouseDb(conn,ctx.attribute("username"));
            db.locationDao().save(loc);            
        } catch (DataAccessException err ){
            if( err.getLocalizedMessage().contains("no CREATE")){
                throw new NotAuthorized("Location", err);
            }
        } 
        catch( Exception err ){
            throw new RuntimeException("Error creating location",err);
        }
    }

    
    @OpenApi(
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        },
        tags = {"Locations"}
    )
    public void update(Context ctx, String locationName){ throw new UnsupportedOperationException("not implemented yet"); }

    @OpenApi(
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        },
        tags = {"Locations"}
    )
    public void delete(Context ctx, String locationName){ throw new UnsupportedOperationException("not implemented yet"); }

}
