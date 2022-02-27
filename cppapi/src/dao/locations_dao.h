#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <vector>
//#include <crow_all.h>
#include "sqlpp/locations_tab.h"
#include "location_dto.h"


namespace gardendb {
    namespace sql {
        class LocationDao {
            private:
                sqlpp::postgresql::connection *db;
            public:
                LocationDao(sqlpp::postgresql::connection *db) : db(db){}
                std::vector<std::string> get_all();
                bool save(const gardendb::dto::LocationDto &location);
        };
    }
}