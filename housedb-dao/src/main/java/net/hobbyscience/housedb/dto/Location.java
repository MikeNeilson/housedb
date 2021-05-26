package net.hobbyscience.housedb.dto;

import java.util.Objects;

import com.fasterxml.jackson.annotation.*;


public class Location{
    @JsonIgnore
    private long id;
    private String name;
    @JsonIgnore
    private String parent;
    private Double latitude;
    private Double longitude;
    private String horizontalDatum;
    private Double elevation;
    private String verticalDatum;


    @JsonCreator
    public Location(     
            @JsonProperty("name") String name,             
            @JsonProperty("latitude") Double latitude, 
            @JsonProperty("longitude") Double longitude, 
            @JsonProperty("horizontalDatum") String horizontalDatum, 
            @JsonProperty("elevation") Double elevation, 
            @JsonProperty("verticalDatum") String verticalDatum) {
        this.id = -1;
        this.name = name;
        this.parent = null;
        this.latitude = latitude;
        this.longitude = longitude;
        this.horizontalDatum = horizontalDatum;
        this.elevation = elevation;
        this.verticalDatum = verticalDatum;
    }
    
    public Location(
            long id, 
            String name, 
            String parent, 
            Double latitude, 
            Double longitude, 
            String horizontalDatum, 
            Double elevation, 
            String verticalDatum) {
        this.id = id;
        this.name = name;
        this.parent = parent;
        this.latitude = latitude;
        this.longitude = longitude;
        this.horizontalDatum = horizontalDatum;
        this.elevation = elevation;
        this.verticalDatum = verticalDatum;
    }
    
    @JsonIgnore
    public long getId(){
        return this.id;
    }

    @JsonIgnore
    public String getParent() {
        return this.parent;
    }

    public Double getLatitude() {
        return this.latitude;
    }

    public Double getLongitude() {
        return this.longitude;
    }

    public String getHorizontalDatum() {
        return this.horizontalDatum;
    }

    public Double getElevation() {
        return this.elevation;
    }

    public String getVerticalDatum() {
        return this.verticalDatum;
    }    

    public String getName() {
        return this.name;
    }        


    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Location)) {
            return false;
        }
        Location location = (Location) o;
        return Objects.equals(name, location.name) && Objects.equals(parent, location.parent) && Objects.equals(latitude, location.latitude) && Objects.equals(longitude, location.longitude) && Objects.equals(horizontalDatum, location.horizontalDatum) && Objects.equals(elevation, location.elevation) && Objects.equals(verticalDatum, location.verticalDatum);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, parent, latitude, longitude, horizontalDatum, elevation, verticalDatum);
    }
    

    @Override
    public String toString() {
        return "{" +
            " name='" + name + "'" +
            ", parent='" + parent + "'" +
            ", latitude='" + latitude + "'" +
            ", longitude='" + longitude + "'" +
            ", horizontal_datum='" + horizontalDatum + "'" +
            ", elevation='" + elevation + "'" +
            ", vertical_datum='" + verticalDatum + "'" +
            "}";
    }
}