/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

package db.migration;

public class NoConversionFound extends RuntimeException{
    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public NoConversionFound(String msg){
        super(msg);
    }
}
