package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;
import net.hobbyscience.database.exceptions.BadMethodData;
import net.hobbyscience.math.Equations;

public class InvUSGS implements ConversionMethod {
    public double a;
    public double b;
    public double c;
    public double d;

    public InvUSGS(double a, double b, double c, double d){
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
    }

    public InvUSGS(String data) {
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

    /**
     * def inv_usgs( y, a, b, c, d):
	 *    return ( (y-d)/a )**(1.0/c)-b
     */
    @Override
    public String getAlgebra() {        
        return String.format("( (i-%0.4f)/%0.4f)^(1.0/%0.4f) - %0.4f",d,a,c,b);
    }

    @Override
    public String getPostfix() {        
        return Equations.infixToPostfix(getAlgebra());
    }

	@Override
	public ConversionMethod getInversion() {
		return new USGS(a,b,c,d);
	}

    @Override
    public boolean equals(Object other){
        if( !(other instanceof InvUSGS)) return false;
        return getAlgebra().equals(((InvUSGS)other).getAlgebra());
    }
    
}
