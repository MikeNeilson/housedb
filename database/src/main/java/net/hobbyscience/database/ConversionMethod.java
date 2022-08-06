package net.hobbyscience.database;

public interface ConversionMethod { 
    public String getAlgebra();
    public String getPostfix();
    public ConversionMethod getInversion();
    public default String render() {
        return this.getPostfix();
    }
}
