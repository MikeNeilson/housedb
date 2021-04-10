package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;

public class ForDB implements ConversionMethod{
    private String data;

    public ForDB(String data){
        this.data = data;
    }

    @Override
    public String getAlgebra() {
        return data;
    }
    
}
