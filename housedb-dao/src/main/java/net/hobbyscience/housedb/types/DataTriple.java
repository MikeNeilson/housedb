package net.hobbyscience.housedb.types;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import net.hobbyscience.housedb.housedb.udt.records.*;
/**
 * row of data from the database. Used for REST API, should be derived from the Jooq 
 * or just be the JOOQ Udt but that appears to crash javalin.
 */
// Todo, figure out how to get this to work
@JsonFormat(shape=JsonFormat.Shape.ARRAY)
@JsonPropertyOrder({"dateTime","value","quality"})
public class DataTriple {     
    @JsonProperty(value="date-time")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSSX")
    @Schema(required = true,pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")    
    public OffsetDateTime dateTime;
    
    @Schema(required = true,nullable = true)
    //@JsonSerialize(as = Double.class)
    //@JsonDeserialize(as = Double.class)
    public double value;    
    
    
    @Schema(required = true, nullable = true)
    //@JsonSerialize(as = Integer.class)
    //@JsonDeserialize(as = Integer.class)
    public int quality;

    @JsonIgnore
    public DataTripleRecord asDataTripleRecord(){
        return new DataTripleRecord(dateTime, value, quality);
    }

    @JsonIgnore
    public static DataTriple fromDataTripleRecord(DataTripleRecord dtr ){
        DataTriple dt = new DataTriple();
        dt.dateTime = dtr.getDateTime();
        dt.value = dtr.getValue();
        dt.quality = dtr.getQuality();
        return dt;
    }
}
