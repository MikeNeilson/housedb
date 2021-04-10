package net.hobbyscience.database;

public class Unit {

    public Unit(String unit_class, String name, String system, String description ){

    }

    private String unit_class;
    private String name;
    private String system;
    private String description;
    
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
    
}
