package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import net.hobbyscience.housedb.dao.*;
import javax.sql.DataSource;

class LocationController : CrudHandler {
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
    override fun getOne(ctx: Context, LocationName: String){}

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

    override fun update(ctx: Context, LocationName: String){}

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    override fun delete(ctx: Context, LocationName: String){}

}