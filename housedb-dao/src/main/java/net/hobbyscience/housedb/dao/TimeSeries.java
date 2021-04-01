package net.hobbyscience.housedb.dao;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.*;

import io.swagger.v3.oas.annotations.media.Schema;
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
    //@Schema(required = false,allOf = DataTriple.class)    
    private ArrayList<DataTriple> data;

    public ArrayList<DataTriple> getData() {
        return this.data;
    }

    public void setData(ArrayList<DataTriple> data) {
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