package net.hobbyscience.housedb.dao;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.jooq.DSLContext;
import org.jooq.impl.DSL;

import net.hobbyscience.housedb.dto.Location;

import static net.hobbyscience.housedb.housedb.tables.ViewLocations.*;
import static net.hobbyscience.housedb.housedb.tables.Locations.*;

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
                    r.getId(),
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
        var res = dsl
            .select()
            .from(VIEW_LOCATIONS)
            .where(DSL.upper(VIEW_LOCATIONS.NAME).eq(DSL.upper(uniqueName)))
            .orderBy(VIEW_LOCATIONS.NAME)
            .fetchOne();
        if( res == null ){
            return Optional.ofNullable(null);
        } else {
            var r = res.into(VIEW_LOCATIONS); 
            return Optional.of(                
                new Location (
                    r.getId(),
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
    public void update(Location modified) {
        dsl.update(VIEW_LOCATIONS)
            .set(VIEW_LOCATIONS.NAME,modified.getName())
            
            .set(VIEW_LOCATIONS.LATITUDE,modified.getLatitude())
            .set(VIEW_LOCATIONS.LONGITUDE,modified.getLongitude())
            .set(VIEW_LOCATIONS.HORIZONTAL_DATUM,modified.getHorizontal_datum())

            .set(VIEW_LOCATIONS.LATITUDE,modified.getElevation())
            .set(VIEW_LOCATIONS.VERTICAL_DATUM,modified.getVertical_datum())
            
            .where(VIEW_LOCATIONS.ID.eq(modified.getId()))
            .execute();        
    }

    @Override
    public void save(Location newObj) {
        dsl.insertInto(VIEW_LOCATIONS)
           .columns(
               VIEW_LOCATIONS.NAME,
               VIEW_LOCATIONS.LATITUDE,
               VIEW_LOCATIONS.LONGITUDE,
               VIEW_LOCATIONS.HORIZONTAL_DATUM,
               VIEW_LOCATIONS.ELEVATION,
               VIEW_LOCATIONS.HORIZONTAL_DATUM
           ).values(
                newObj.getName(),
                newObj.getLatitude(),
                newObj.getLongitude(),
                newObj.getHorizontal_datum(),
                newObj.getElevation(),
                newObj.getVertical_datum()
           ).execute();
        
    }
    
}
