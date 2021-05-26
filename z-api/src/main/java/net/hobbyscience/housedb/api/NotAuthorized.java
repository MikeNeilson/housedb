package net.hobbyscience.housedb.api;

public class NotAuthorized extends RuntimeException{
    public NotAuthorized(String msg, Throwable err ){
        super(msg,err);
    }
}
