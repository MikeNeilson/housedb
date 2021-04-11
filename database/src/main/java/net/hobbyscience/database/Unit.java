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
    public boolean equals(Object other ){
        if( !(other instanceof Unit)) return false;
        Unit u = (Unit)other;
        return this.name == u.name;
    }

    @Override
    public String toString() {
        return name;
    }
}
