#include "locations_dao.h"
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>

namespace gardendb {
    namespace sql {
         std::vector<std::string> LocationDao::get_all(){
                
                std::vector<std::string> list;
                auto query = sqlpp::select(sqlpp::all_of(locations)).from(locations).unconditionally();
                
                for(const auto &row : db(query)){
                    list.push_back(row.name);
                }
                return list;
            }

        bool LocationDao::save( const LocationDto &name) {
            auto update = sqlpp::insert_into(locations)
                                .set(locations.name = name)
                                );
            db(update);
            return false;
        }
    }
}