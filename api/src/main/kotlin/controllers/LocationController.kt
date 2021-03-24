package controllers;
import io.javalin.apibuilder.*;
import io.javalin.http.*;
import net.hobbyscience.housedb.*;
import javax.sql.DataSource;

class LocationController : CrudHandler {
    override fun getAll(ctx: Context){
        val ds = ctx.appAttribute(DataSource::class.java)
        val db = HouseDb(ds)
        if(db != null ){ ctx.json("have db")}
        else{ ctx.json("don't have db")}
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