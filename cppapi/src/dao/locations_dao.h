#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <vector>
#include <crow/json.h>
#include <crow/logging.h>
#include "sqlpp/housedb.h"
#include "location_dto.h"



namespace gardendb {
    namespace sql {
        using LocationDto = gardendb::dto::LocationDto;

        class LocationDao {
            private:
                sqlpp::postgresql::connection &db;
            public:
                LocationDao(sqlpp::postgresql::connection &db) : db(db){}
                std::vector<LocationDto> get_all();
                bool save(const LocationDto &location);
        };
    }
}