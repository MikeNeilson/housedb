package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.exceptions.BadMethodData;

public class Linear implements ConversionMethod{
    private double a;
    private double b;

    public Linear(double a, double b){
        this.a = a;
        this.b = b;
    }

    public Linear(String data){
        String []parts = data.split("\\s+");
        if( parts.length != 2){
            throw new BadMethodData("Linear conversions consist of only 2 values. (" + data + ") has " + parts.length + " values");
        }
        try {
            a = Double.parseDouble(parts[0]);
            b = Double.parseDouble(parts[1]);
        } catch( NumberFormatException ex ){
            throw new BadMethodData("values must be doubles", ex);
        }
    }    

    @Override
    public String getAlgebra() {
        return String.format("i*%.04f+%.0f",a,b);
    }

	@Override
	public ConversionMethod getInversion() {		
		return new InvLinear(a,b);
	}

    @Override
    public boolean equals(Object other){
        if( !(other instanceof Linear)) return false;
        return getAlgebra().equals(((Linear)other).getAlgebra());
    }

}
