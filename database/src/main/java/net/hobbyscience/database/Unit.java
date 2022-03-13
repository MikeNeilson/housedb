/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

package net.hobbyscience.database;

public class Unit {

    private String unit_class;
    private String name;
    private String system;
    private String description;

    public Unit(String unit_class, String name, String system, String description ){
        this.unit_class = unit_class;
        this.name = name;
        this.system = system;
        this.description = description;
    }
    
    public String getUnit_class() {
        return this.unit_class;
    }

    public String getName() {
        return this.name;
    }

    public String getSystem() {
        return this.system;
    }

    public String getDescription() {
        return this.description;
    }
    
    @Override
    public int hashCode(){
        return this.name.hashCode();
    }

    @Override
    public boolean equals(Object other ){
        if( !(other instanceof Unit)) return false;
        Unit u = (Unit)other;
        return this.name.equals(u.name);
    }

    @Override
    public String toString() {
        return name;
    }
}
