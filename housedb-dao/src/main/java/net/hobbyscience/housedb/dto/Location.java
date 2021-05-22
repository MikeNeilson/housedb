package net.hobbyscience.housedb.dto;

import java.util.Objects;

public class Location{
    private String name;
    private String parent;
    private Double latitude;
    private Double longitude;
    private String horizontal_datum;
    private Double elevation;
    private String vertical_datum;

    public Location(String name, String parent, Double latitude, Double longitude, String horizontal_datum, Double elevation, String vertical_datum) {
        this.name = name;
        this.parent = parent;
        this.latitude = latitude;
        this.longitude = longitude;
        this.horizontal_datum = horizontal_datum;
        this.elevation = elevation;
        this.vertical_datum = vertical_datum;
    }
    
    public String getParent() {
        return this.parent;
    }

    public Double getLatitude() {
        return this.latitude;
    }

    public Double getLongitude() {
        return this.longitude;
    }

    public String getHorizontal_datum() {
        return this.horizontal_datum;
    }

    public Double getElevation() {
        return this.elevation;
    }

    public String getVertical_datum() {
        return this.vertical_datum;
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
        return Objects.equals(name, location.name) && Objects.equals(parent, location.parent) && Objects.equals(latitude, location.latitude) && Objects.equals(longitude, location.longitude) && Objects.equals(horizontal_datum, location.horizontal_datum) && Objects.equals(elevation, location.elevation) && Objects.equals(vertical_datum, location.vertical_datum);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, parent, latitude, longitude, horizontal_datum, elevation, vertical_datum);
    }
    

    @Override
    public String toString() {
        return "{" +
            " name='" + name + "'" +
            ", parent='" + parent + "'" +
            ", latitude='" + latitude + "'" +
            ", longitude='" + longitude + "'" +
            ", horizontal_datum='" + horizontal_datum + "'" +
            ", elevation='" + elevation + "'" +
            ", vertical_datum='" + vertical_datum + "'" +
            "}";
    }
}