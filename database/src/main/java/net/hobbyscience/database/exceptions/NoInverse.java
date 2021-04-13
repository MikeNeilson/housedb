package net.hobbyscience.database.exceptions;

public class NoInverse extends RuntimeException{

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    public NoInverse(String msg ){
        super(msg);
    }
}
