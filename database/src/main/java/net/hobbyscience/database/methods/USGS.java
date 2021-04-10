package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.exceptions.BadMethodData;

public class USGS implements ConversionMethod {
    public double a;
    public double b;
    public double c;
    public double d;

    public USGS(String data) {
        String parts[] = data.split("\\.*");
        if( parts.length != 2){
            throw new BadMethodData("Linear conversions consist of only 2 values");
        }
        try {
            a = Double.parseDouble(parts[0]);
            b = Double.parseDouble(parts[1]);
            c = Double.parseDouble(parts[2]);
            d = Double.parseDouble(parts[3]);
        } catch( NumberFormatException ex ){
            throw new BadMethodData("values must be doubles", ex);
        }
    }

    @Override
    public String getAlgebra() {        
        return String.format("%0.4f * (%0.4f + i)^%0.4f + %0.4f",a,b,c,d);
    }
    
}
