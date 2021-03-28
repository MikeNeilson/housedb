
import java.sql.DriverManager;

import io.javalin.Javalin
import io.javalin.apibuilder.ApiBuilder.*
import controllers.*;
import org.apache.tomcat.jdbc.pool.DataSource;


fun main(args: Array<String>) {
    println("********")
    println(args[0])
    println(args[1])

    val ds = DataSource()
    ds.setDriverClassName("org.postgresql.Driver")
    ds.setUrl(args[0])
    ds.setUsername(args[1])
    ds.setPassword(args[2])
    ds.setInitialSize(5)
    ds.setMaxActive(10)
    ds.setMaxIdle(5);
    ds.setMinIdle(2);
        
    val app = Javalin.create()            
        .apply {
            exception(Exception::class.java){ e, _ -> e.printStackTrace() }
            error(404){ ctx -> ctx.json("not found") }
           
        }.attribute(javax.sql.DataSource::class.java,ds)
        .before { ctx -> 
            ctx.attribute("username","guest")
        }
        .start(7000)        
    app.routes {
        get("/") { ctx -> ctx.result("Hello World") }
        crud("locations/:location-name", LocationController())
    }
     
}

