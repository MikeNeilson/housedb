package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import net.hobbyscience.housedb.*;
import javax.sql.DataSource;
import com.fasterxml.jackson.databind.*;

class LocationController : CrudHandler {
    override fun getAll(ctx: Context){
        val ds = ctx.appAttribute(DataSource::class.java)
        val db = HouseDb(ds)
        val locations = db.getAllLocations()
        val om = ObjectMapper()
        ctx.json(om.writerWithDefaultPrettyPrinter().writeValueAsString(locations))
    }

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    override fun getOne(ctx: Context, LocationName: String){

    }

    override fun create(ctx: Context){}

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")

    override fun update(ctx: Context, LocationName: String){}

    @Suppress("PARAMETER_NAME_CHANGED_ON_OVERRIDE")
    override fun delete(ctx: Context, LocationName: String){}

}