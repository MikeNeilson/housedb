package net.hobbyscience.housedb.dao;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.jooq.DSLContext;
import org.jooq.impl.DSL;

import net.hobbyscience.housedb.dto.Location;

import static net.hobbyscience.housedb.housedb.tables.ViewLocations.*;

public class LocationsDao extends Dao<Location>{

    public LocationsDao(DSLContext dsl) {
        super(dsl);        
    }

    @Override
    public List<Location> getAll() {
        var locs = dsl
            .select()
            .from(VIEW_LOCATIONS).orderBy(VIEW_LOCATIONS.NAME)
            .fetch().stream().map( r -> r.into(VIEW_LOCATIONS) )
            .map( r -> {
                return new Location (
                    r.getName(),
                    r.getParent(),
                    r.getLatitude(),
                    r.getLongitude(),
                    r.getHorizontalDatum(),
                    r.getElevation(),
                    r.getVerticalDatum()
                );            
            }).collect(Collectors.toList());
        return locs;
    }

    @Override
    public Optional<Location> getByUniqueName(String uniqueName) {        
        var r = dsl
            .select()
            .from(VIEW_LOCATIONS)
            .where(DSL.upper(VIEW_LOCATIONS.NAME).eq(DSL.upper(uniqueName)))
            .orderBy(VIEW_LOCATIONS.NAME)
            .fetchOne().into(VIEW_LOCATIONS);
        if( r == null ){
            return Optional.ofNullable(null);
        } else {
            return Optional.of(
                new Location (
                    r.getName(),
                    r.getParent(),
                    r.getLatitude(),
                    r.getLongitude(),
                    r.getHorizontalDatum(),
                    r.getElevation(),
                    r.getVerticalDatum()
                )
            );
        }
        
        
    }

    @Override
    public Location update(Location modified) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void save(Location newObj) {
        // TODO Auto-generated method stub
        
    }
    
}
