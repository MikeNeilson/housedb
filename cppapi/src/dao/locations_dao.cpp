#include "locations_dao.h"
#include <sqlpp11/sqlpp11.h>
#include <crow_all.h>
#include <sqlpp11/postgresql/connection.h>

namespace gardendb {
    namespace sql {
         std::vector<std::string> LocationDao::get_all(){
                
                std::vector<std::string> list;
                auto query = sqlpp::select(sqlpp::all_of(locations)).from(locations).unconditionally();
                auto result = db->operator()(query);
                for(const auto &row : result){
                    list.push_back(row.name);
                }
                return list;
            }

        bool LocationDao::save( const gardendb::dto::LocationDto &name) {
            auto update = sqlpp::insert_into(locations)
                                .set(locations.name = name.get_name())
                                ;
            CROW_LOG_DEBUG << "inserting";
            db->update(update);
            CROW_LOG_DEBUG << "inserted";
            return false;
        }
    }
}