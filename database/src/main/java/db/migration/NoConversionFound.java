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
