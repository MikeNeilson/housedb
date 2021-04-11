package net.hobbyscience.database.methods;

import net.hobbyscience.database.ConversionMethod;

public class ForDB implements ConversionMethod{
    private String postfix;

    public ForDB(String data){
        this.postfix = data;
    }

    @Override
    public String getAlgebra() {
        return postfix;
    }

	@Override
	public ConversionMethod getInversion() {
		// TODO: Actually invert
		return new ForDB(postfix);
	}

	@Override
	public boolean equals(Object other) {
		if( !( other instanceof ForDB )) return false;
		return this.postfix.equals( ((ForDB)other).postfix );
	}

    
    
}
