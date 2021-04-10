package net.hobbyscience.database;

public class Conversion {
    private Unit from;
    private Unit to;
    private ConversionMethod method;    

    public Conversion(Unit from, Unit to, ConversionMethod method){
        this.from = from;
        this.to = to;
        this.method = method;
    }

    public Unit getFrom() {
        return this.from;
    }

    public Unit getTo() {
        return this.to;
    }

    public ConversionMethod getMethod() {
        return this.method;
    }
    
}
