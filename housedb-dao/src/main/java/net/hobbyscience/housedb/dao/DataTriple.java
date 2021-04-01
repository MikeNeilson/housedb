package net.hobbyscience.housedb.dao;

import java.util.Date;

import com.fasterxml.jackson.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat.Shape;

import io.swagger.v3.oas.annotations.media.Schema;
/**
 * row of data from the database.
 */
@Schema(description="Tuple of time series elements")
// Todo, figure out how to get this to work
//@JsonFormat(shape=JsonFormat.Shape.ARRAY)
@JsonPropertyOrder({"dateTime","value","quality"})
public class DataTriple {
    @JsonProperty(value="date-time")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSSX")
    @Schema(required = true,pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")
    public Date dateTime;
    @Schema(required = true)
    public double value;    
    @Schema(required = true)
    public int quality;
}
