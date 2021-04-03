package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*
import net.hobbyscience.housedb.dao.*;
import javax.sql.DataSource;
import net.hobbyscience.housedb.api.*;
import org.jooq.exception.*
import java.time.*

class TimeSeriesController : CrudHandler {
    @OpenApi(
        tags = ["TimeSeries"],
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = TimeSeries::class,isArray=true)])
        ],
        ignore = true
    )
    override fun getAll(ctx: Context){
        //throw NotImplemented("unable to retrieve all timeseries")
        println(ctx.attribute("username"))
        val ds = ctx.appAttribute(DataSource::class.java)        
        var conn = ds.getConnection()        
        conn.use {
            val db = HouseDb(conn,ctx.attribute("username"))        
            val locations = db.getAllLocations()          
            ctx.json(locations)
        }
        
    }

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    @OpenApi(
        tags = ["TimeSeries"],
        queryParams = [
            OpenApiParam(name="start", required = true, type = OffsetDateTime::class),
            OpenApiParam(name="end", required = true, type = OffsetDateTime::class),
            OpenApiParam(name="timezone"),
            OpenApiParam(name="exclude_missing", type = Boolean::class, description = "For regular interval timeseries, do you want the elements that don't have values left out")
        ],
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = TimeSeries::class)]),  
            OpenApiResponse(status="404", content = [OpenApiContent( from = NotFoundResponse::class)])            
        ]
    )
    override fun getOne(ctx: Context, LocationName: String){
        println(ctx.attribute("username"))
        val ds = ctx.appAttribute(DataSource::class.java)        
        var conn = ds.getConnection()
        var ts = TimeSeries()
        ts.setName(ctx.pathParam("timeseries-name"))
        conn.use {
            val db = HouseDb(conn,ctx.attribute("username"))        
            val start = ctx.queryParam<OffsetDateTime>("start").get()
            val end = ctx.queryParam<OffsetDateTime>("end").check({it.isAfter(start)}).get()
            try {
                ts = db.getTimeSeries(
                        ts,
                        start,
                        end,
                        ctx.queryParam("timezone","UTC"),
                        ctx.queryParam<Boolean>("exclude_missing","false").get()
                )         
                ctx.json(ts)
            } catch (err: DataAccessException ){                
                if( err.sqlState().equals("ZX084") ){                    
                    throw NotFoundResponse(message ="No Timeseries by this name: " + ts.getName())                                                                                        
                }
                throw err;
            }
            
        }
    }

    @OpenApi(
        tags = ["TimeSeries"],
        requestBody = OpenApiRequestBody(content = [OpenApiContent(from = TimeSeries::class)]),
        summary = "data triples are not required when creating a timeseries, but will be immediately stored if present",
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = TimeSeries::class)])            
        ]
    )
    override fun create(ctx: Context){
        val ts = ctx.bodyAsClass(TimeSeries::class.java)
        val ds = ctx.appAttribute(DataSource::class.java)        
        var conn = ds.getConnection()
        println(ts)
        conn.use {
            val db = HouseDb(conn,ctx.attribute("username"))        
            db.saveTimeSeries(ts);
        }
    }

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    @OpenApi(
        tags = ["TimeSeries"]
    )
    override fun update(ctx: Context, LocationName: String){}

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    @OpenApi(
        tags = ["TimeSeries"]
    )
    override fun delete(ctx: Context, LocationName: String){}

}