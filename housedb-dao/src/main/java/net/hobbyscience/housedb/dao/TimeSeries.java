package net.hobbyscience.housedb.dao;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.*;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Schema;
import net.hobbyscience.housedb.housedb.udt.records.DataTripleRecord;
/**
 * 
 */
@Schema(description = "Collection of timeseries values")
public class TimeSeries{
    @Schema(required = false)
    private String name;
    @Schema(required = false,name = "interval-offset")
    @JsonAlias("interval-offset")    
    @JsonProperty(value = "interval-offset")
    private String intervalOffset;
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
}