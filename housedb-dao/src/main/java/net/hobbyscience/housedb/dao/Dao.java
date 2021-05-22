package net.hobbyscience.housedb.dao;

import java.util.List;
import java.util.Optional;

import org.jooq.DSLContext;

public abstract class Dao<T> {

    @SuppressWarnings("unused")
    protected DSLContext dsl = null;

    public Dao(DSLContext dsl){
        this.dsl = dsl;
    }

    public abstract List<T> getAll();
    public abstract Optional<T> getByUniqueName(String uniqueName);

    public abstract T update(T modified);
    public abstract void save(T newObj);

}
