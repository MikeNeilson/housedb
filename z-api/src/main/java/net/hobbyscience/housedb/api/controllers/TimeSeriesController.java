package net.hobbyscience.housedb.api.controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*;
import net.hobbyscience.housedb.dao.*;
import net.hobbyscience.housedb.dto.TimeSeries;

import javax.sql.DataSource;
import org.jooq.exception.*;
import java.time.*;
import java.util.logging.Logger;

public class TimeSeriesController implements CrudHandler {
    public static final Logger logger = Logger.getLogger(TimeSeriesController.class.getName());
    @OpenApi(
        tags = {"TimeSeries"},
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = TimeSeries[].class,isArray=true)})
        },
        ignore = true
    )
    public void getAll(Context ctx){
        //throw NotImplemented("unable to retrieve all timeseries")
        logger.log(ctx.attribute("username"));
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection();) {
            var db = new HouseDb(conn,ctx.attribute("username"));
            var locations = db.getAllLocations();
            ctx.json(locations);
        } catch ( Exception err ){
            throw new RuntimeException("error retrieving all timeseries",err);
        }
        
    }
    
    @OpenApi(
        tags = {"TimeSeries"},
        queryParams = {
            @OpenApiParam(name="start", required = true, type = OffsetDateTime.class),
            @OpenApiParam(name="end", required = true, type = OffsetDateTime.class),            
            @OpenApiParam(name="units",required=false),
            @OpenApiParam(name="exclude_missing", type = Boolean.class, description = "For regular interval timeseries, do you want the elements that don't have values left out")
        },
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = TimeSeries.class)}),  
            @OpenApiResponse(status="404", content = {@OpenApiContent( from = NotFoundResponse.class)})
        },
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        }
    )
    public void getOne(Context ctx, String locationName){
        logger.info(ctx.attribute("username").toString());
        var ds = ctx.appAttribute(DataSource.class);
        var ts = new TimeSeries();
        ts.setName(ctx.pathParam("timeseries-name"));
        try( var conn = ds.getConnection();){
            var db = new HouseDb(conn,ctx.attribute("username"));      
            OffsetDateTime start = ctx.queryParam("start",OffsetDateTime.class).get();
            OffsetDateTime end = ctx.queryParam("end",OffsetDateTime.class).check( it -> it.isAfter(start) ).get();
            try {
                ts = db.getTimeSeries(
                        ts,
                        start,
                        end,
                        ctx.queryParam("timezone","UTC"),
                        ctx.queryParam("units"),
                        ctx.queryParam("exclude_missing",Boolean.class,"false").get()
                );
                ctx.json(ts);
            } catch (DataAccessException err ){
                if( err.sqlState().equals("ZX084") ){                    
                    throw new NotFoundResponse("No Timeseries by this name: " + ts.getName());
                }
                throw err;
            }
            
        } catch( Exception err ){
            throw new RuntimeException("Error retrieving time series data",err);
        }
    }

    @OpenApi(
        tags = {"TimeSeries"},
        requestBody = @OpenApiRequestBody(content = {@OpenApiContent(from = TimeSeries.class)}),
        summary = "data triples are not required when creating a timeseries, but will be immediately stored if present",
        responses = {
            @OpenApiResponse(status="200", content = {@OpenApiContent( from = TimeSeries.class)})            
        }
    )
    public void create(Context ctx){
        var ts = ctx.bodyAsClass(TimeSeries.class);
        var ds = ctx.appAttribute(DataSource.class);
        try( var conn = ds.getConnection();){        
            var db = new HouseDb(conn,ctx.attribute("username"));
            db.saveTimeSeries(ts);
        } catch( Exception err ){
            throw new RuntimeException("Error creating new time series",err );
        }
    }
    
    @OpenApi(
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        },
        tags = {"TimeSeries"}
    )
    public void update(Context ctx, String locationName){ throw new UnsupportedOperationException("not implemented yet"); }
    
    @OpenApi(
        security = {
            @OpenApiSecurity(name = "bearerAuth")
        },
        tags = {"TimeSeries"}
    )
    public void delete(Context ctx , String locationName){ throw new UnsupportedOperationException("not implemented yet"); }

}