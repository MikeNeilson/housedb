package net.hobbyscience.database;

public class Parameter {
    private String name;
    private String storageUnits;
    private String description;

    public Parameter(String name, String storageUnits, String description){
        this.name = name;
        this.storageUnits = storageUnits;
    }

    public String getName() {
        return this.name;
    }

    public String getStorageUnits() {
        return this.storageUnits;
    }

    public String getDescription() {
        return this.description;
    }
}
