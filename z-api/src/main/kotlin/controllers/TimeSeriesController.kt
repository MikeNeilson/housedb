package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*
import net.hobbyscience.housedb.dao.*;
import javax.sql.DataSource;

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
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = TimeSeries::class)])
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
            val ts = db.getTimeSeries(ts)         
            ctx.json(ts)
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