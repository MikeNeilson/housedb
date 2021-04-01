package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import io.javalin.plugin.openapi.annotations.*
import net.hobbyscience.housedb.dao.*;
import javax.sql.DataSource;

class LocationController : CrudHandler {
    @OpenApi(
        tags = ["Locations"],
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = Location::class,isArray=true)])
        ]
    )
    override fun getAll(ctx: Context){
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
        tags = ["Locations"],
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = Location::class)])
        ]
    )
    override fun getOne(ctx: Context, LocationName: String){}

    @OpenApi(
        tags = ["Locations"],
        requestBody = OpenApiRequestBody(content = [OpenApiContent(from = Location::class)]),
        responses = [
            OpenApiResponse(status="200", content = [OpenApiContent( from = Location::class)])
        ]
    )
    override fun create(ctx: Context){
        val loc = ctx.bodyAsClass(Location::class.java)
        val ds = ctx.appAttribute(DataSource::class.java)        
        var conn = ds.getConnection()
        conn.use {
            val db = HouseDb(conn,ctx.attribute("username"))        
            db.saveLocation(loc);
        }
    }

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    @OpenApi(
        tags = ["Locations"]
    )
    override fun update(ctx: Context, LocationName: String){}

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    @OpenApi(
        tags = ["Locations"]
    )
    override fun delete(ctx: Context, LocationName: String){}

}