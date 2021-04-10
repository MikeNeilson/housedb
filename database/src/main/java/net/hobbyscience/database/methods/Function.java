package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.exceptions.BadMethodData;

public class Function implements ConversionMethod{
    private String data;

    public Function(String data){
        if( data == null || data.isEmpty() ){
            throw new BadMethodData("an equation must be provided");
        }
        this.data = data;
    }

    @Override
    public String getAlgebra() {        
        return data;
    }
    
}
