package net.hobbyscience.housedb.dao;

import java.util.Objects;

public class Location{
    private String name;

    public Location() {
    }

    public Location(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Location name(String name) {
        setName(name);
        return this;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Location)) {
            return false;
        }
        Location location = (Location) o;
        return Objects.equals(name, location.name);
    }

    @Override
    public int hashCode() {        
        return Objects.hashCode(name);
    }

    @Override
    public String toString() {
        return "{" +
            " name='" + getName() + "'" +
            "}";
    }
}