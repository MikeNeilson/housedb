package net.hobbyscience.housedb.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.*;

import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Schema;
import net.hobbyscience.housedb.types.DataTriple;
/** 
 * 
 */
@Schema(description = "Collection of timeseries values")
public class TimeSeries{
    @Schema(required = false)
    private String name;

    @Schema(required = false, example="00:15:00", description = " the hours:minuts:seconds each value should be in time from each other")    
    private String interval;

    @Schema(required = false,name = "interval-offset", example = "00:00:00", description = "the hours:minute:seconds these values should be offset from the top of the interval.")
    @JsonAlias("interval-offset")    
    @JsonProperty(value = "interval-offset")
    private String intervalOffset;

    @Schema(required = true)
    private String units;

    //@Schema(required = false,allOf = DataTripleRecord.class)    
    //@ArraySchema()    
    @ArraySchema(
        schema = @Schema(description = "Tuple of time series elements",implementation = DataTriple.class)        
    )    
    private List<DataTriple> data;

    public List<DataTriple> getData() {
        return this.data;
    }

    public void setData(List<DataTriple> data) {
        this.data = data;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIntervalOffset() {
        return this.intervalOffset;
    }

    public void setIntervalOffset(String intervalOffset) {
        this.intervalOffset = intervalOffset;
    }

    public String getUnits() {
        return this.units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getInterval() {
        return this.interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }
}