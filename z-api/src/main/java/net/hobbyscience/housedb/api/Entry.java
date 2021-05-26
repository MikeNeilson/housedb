package net.hobbyscience.housedb.api;

import io.javalin.Javalin;
import io.javalin.core.util.Header;
import io.javalin.core.validation.JavalinValidation;
import io.javalin.plugin.json.JavalinJackson;

import static io.javalin.apibuilder.ApiBuilder.*;

import net.hobbyscience.housedb.api.controllers.*;
import net.hobbyscience.housedb.dao.*;
import net.hobbyscience.housedb.jackson.*;
import net.hobbyscience.housedb.types.DataTriple;
import net.hobbyscience.housedb.types.serializers.DataTripleDeserializer;
import net.hobbyscience.housedb.types.serializers.DataTripleSerializer;

import org.apache.tomcat.jdbc.pool.DataSource;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletResponse;

import java.time.*;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.jooq.exception.*;
import org.postgresql.util.PSQLException;
import io.javalin.plugin.openapi.OpenApiOptions;
import io.javalin.plugin.openapi.OpenApiPlugin;
import io.javalin.plugin.openapi.ui.ReDocOptions;
import io.javalin.plugin.openapi.ui.SwaggerOptions;
import io.swagger.v3.oas.models.info.Info;


public class Entry {
    private static final Logger logger = Logger.getLogger(Entry.class.getName());
    public static OpenApiPlugin getOpenApiPlugin() {
        Info info = new Info().version("1.0").description("HouseDB API");
        OpenApiOptions ops = new OpenApiOptions(info)
                                .path("/swagger-docs")        
                                //.toJsonMapper(JacksonToJsonMapper.INSTANCE)
                                .swagger(new SwaggerOptions("/swagger-ui"))
                                .reDoc(new ReDocOptions("/redoc"))
                                .defaultDocumentation( doc -> {
                                    doc.json("500", ErrorResponse.class);
                                    doc.json("503", ErrorResponse.class);
                                });
        return new OpenApiPlugin(ops);
        
    }

    public static void main(String []args) {        

        var ds = new DataSource();
        ds.setDriverClassName("org.postgresql.Driver");
        ds.setUrl(System.getenv("HOUSEDB_URL"));
        ds.setUsername(System.getenv("HOUSEDB_USERNAME"));
        ds.setPassword(System.getenv("HOUSEDB_PASSWORD"));
        ds.setInitialSize(5);
        ds.setMaxActive(10);
        ds.setMaxIdle(5);
        ds.setMinIdle(2);
        var om = JavalinJackson.getObjectMapper();
        om.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
        om.registerModule(new SimpleModule().addDeserializer(DataTriple.class, new DataTripleDeserializer()));
        om.registerModule(new SimpleModule().addSerializer(DataTriple.class, new DataTripleSerializer()));
        om.setAnnotationIntrospector(new IgnoreJooq());

        String _port = System.getenv("HOUSEDB_PORT");
        int port = _port != null ? Integer.parseInt(_port) : 7000;

        
        String address = System.getenv("HOUSEDB_LISTEN_ADDRESS");
        address = address != null ? address : "0.0.0.0";

        JavalinValidation.register(OffsetDateTime.class, it -> {
            return OffsetDateTime.parse(it);
        });

        var app = Javalin.create( config -> {
                config.registerPlugin(getOpenApiPlugin());
                config.defaultContentType = "application/json";
            })        
            .exception(DataAccessException.class,( e, ctx ) -> {       
                    logger.warning("General error");
                    logger.warning(e.sqlState());
                    if( e.sqlState().equals("PX001") ){
                        ctx.status(401);
                        var err = e.getCause(PSQLException.class);
                        logger.warning(err.getServerErrorMessage().toString());
                        ctx.json("Not Authorized");
                    } else {
                        ctx.status(500);
                        ctx.json("Internal Error");
                        logger.log(Level.WARNING,"database error",e);
                    }
                })
            .exception(NotAuthorized.class, (e, ctx ) -> {
                logger.warning("Unauthorized access");
                logger.warning(e.getCause().getMessage());
                ctx.status(HttpServletResponse.SC_UNAUTHORIZED).json("Unauthorized Access");
            })
            .exception(UnsupportedOperationException.class, (e,ctx) -> {
                ctx.status(HttpServletResponse.SC_NOT_IMPLEMENTED);
                logger.log(Level.WARNING,"error",e);
            })            
            .exception(Exception.class, (e, ctx) -> { 
                ctx.status(500);
                ctx.json("Error processing request");
                logger.log(Level.WARNING,"error",e); } 
            )
                //error(404){ ctx -> ctx.json("not found") }           
            .attribute(javax.sql.DataSource.class,ds)
            .before( ctx -> {
                var header = ctx.header(Header.AUTHORIZATION);
                if( header != null ){
                    // verification will be handled at the gateway
                    //val jwt = Jwts.parserBuilder().build().parseClaimsJws(ctx.header("Authorization"))
                    logger.info(header);
                    var parts = header.split("\\\\s+");
                    var jwt = parts[parts.length-1].split("\\.");
                    logger.info(""+jwt.length);
                    var jwtClaims = Base64.getDecoder().decode(jwt[1]);
                    var jsonClaims = om.readTree(jwtClaims);
                    //val user = jwt.subject()
                    logger.fine(jsonClaims.toString());
                    var user = om.treeToValue(jsonClaims.get("sub"),String.class);
                    logger.fine(user);                
                    ctx.attribute("username",user);
                } else {
                    ctx.attribute("username","guest");
                }                
                ctx.header("X-Content-Type-Options","nosniff");
            })
            .start(address,port);
        app.routes( () -> {
            get("/", ctx -> {ctx.result("Hello World"); });
            crud("/locations/:location-name", new LocationController());
            crud("/timeseries/:timeseries-name", new TimeSeriesController());
        });
    }

}