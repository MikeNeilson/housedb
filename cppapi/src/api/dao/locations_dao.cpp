// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "locations_dao.h"
#include <sqlpp11/sqlpp11.h>
#include <crow/json.h>
#include <crow/logging.h>
#include <sqlpp11/postgresql/connection.h>

namespace gardendb {
    namespace sql {
         std::vector<LocationDto> LocationDao::get_all(){
                
                std::vector<LocationDto> list;
                auto query = sqlpp::select(sqlpp::all_of(views::view_locations)).from(views::view_locations).unconditionally();
                auto result = db(query);
                for(const auto &row : result){
                    LocationDto loc(row.name,
                                    row.parent,
                                    row.latitude,
                                    row.longitude,
                                    row.horizontal_datum,
                                    row.elevation,
                                    row.vertical_datum);
                    
                    list.push_back(loc);
                }
                return list;
            }

        bool LocationDao::save( const gardendb::dto::LocationDto &name) {
            CROW_LOG_DEBUG << "saving location";
            try {
                auto update = sqlpp::insert_into(views::view_locations)
                                .set(views::view_locations.name = name.get_name())
                                ;
                CROW_LOG_DEBUG << "inserting";
                db.update(update);
                CROW_LOG_DEBUG << "inserted";
                return true;
            } catch( const sqlpp::exception &ex) {
                CROW_LOG_ERROR << "Database was Unable to save location: " << ex.what();
            } catch( const std::exception &ex) {
                CROW_LOG_ERROR << "System was Unable to save location: " << ex.what();
            }

            
            return false;
        }
    }
}