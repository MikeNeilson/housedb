
import java.sql.DriverManager;

import io.javalin.Javalin
import io.javalin.core.validation.JavalinValidation
import io.javalin.plugin.json.JavalinJackson

import io.javalin.apibuilder.ApiBuilder.*

import controllers.*;
import net.hobbyscience.housedb.api.ErrorResponse;
import net.hobbyscience.housedb.dao.*
import net.hobbyscience.housedb.housedb.udt.records.*
import net.hobbyscience.housedb.jackson.*

import org.apache.tomcat.jdbc.pool.DataSource;
import java.util.Base64;
import java.time.*;
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.KotlinModule
import com.fasterxml.jackson.module.kotlin.readValue
import com.fasterxml.jackson.module.kotlin.treeToValue
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.databind.module.SimpleModule
import org.jooq.exception.*
import org.postgresql.util.PSQLException
import io.javalin.plugin.openapi.OpenApiOptions
import io.javalin.plugin.openapi.OpenApiPlugin
import io.javalin.plugin.openapi.ui.ReDocOptions
import io.javalin.plugin.openapi.ui.SwaggerOptions
import io.swagger.v3.oas.models.info.Info



fun getOpenApiPlugin() = OpenApiPlugin(
    OpenApiOptions(
        Info().apply {
            version("1.0")
            description("HouseDB API")
        }
    ). apply {
        path("/swagger-docs")        
        //.toJsonMapper(JacksonToJsonMapper.INSTANCE)
        swagger(SwaggerOptions("/swagger-ui"))
        reDoc(ReDocOptions("/redoc"))
        defaultDocumentation { doc ->
            doc.json("500", ErrorResponse::class.java)
            doc.json("503", ErrorResponse::class.java)
        }
    }
)

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
    val om = JavalinJackson.getObjectMapper()
    om.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    om.registerModule(SimpleModule().addDeserializer(DataTriple::class.java, DataTripleDeserializer()));
    om.registerModule(SimpleModule().addSerializer(DataTriple::class.java, DataTripleSerializer()));
    om.setAnnotationIntrospector(IgnoreJooq());

    JavalinValidation.register(OffsetDateTime::class.java){
        OffsetDateTime.parse(it)
    }

    val app = Javalin.create(){ config ->
            config.registerPlugin(getOpenApiPlugin())
            config.defaultContentType = "application/json"
        }            
        .apply { 
            
            exception(DataAccessException::class.java) { e, ctx ->       
                println("General error")
                println(e.sqlState())          
                if( e.sqlState() == "PX001" ){
                    ctx.status(401)
                    val err: PSQLException = e.getCause(PSQLException::class.java)
                    println(err.getServerErrorMessage())
                    ctx.json("Not Authorized")
                } else {
                    ctx.status(500)
                    ctx.json("Internal Error")
                    e.printStackTrace()
                }
            }           
            exception(Exception::class.java){ e, _ -> e.printStackTrace() }            
            //error(404){ ctx -> ctx.json("not found") }           
        }.attribute(javax.sql.DataSource::class.java,ds)
        .before { ctx -> 
            val header = ctx.header("Authorization")
            if( header != null ){
                // verification will be handled at the gateway
                //val jwt = Jwts.parserBuilder().build().parseClaimsJws(ctx.header("Authorization"))
                val jwt = header.split(".")
                val jwtClaims = Base64.getDecoder().decode(jwt[1])                
                val jsonClaims = om.readTree(jwtClaims)
                //val user = jwt.subject()
                println(jsonClaims)
                val user = om.treeToValue<String>(jsonClaims.get("sub"))
                println(user);                
                ctx.attribute("username",user);
            } else {
                ctx.attribute("username","guest")
            }
        }
        .start(7000)        
    app.routes {
        get("/") { ctx -> ctx.result("Hello World") }
        crud("/locations/:location-name", LocationController())
        crud("/timeseries/:timeseries-name",TimeSeriesController())
    }
}

