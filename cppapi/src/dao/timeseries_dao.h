#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <vector>
#include <string>
//#include <crow_all.h>
#include "sqlpp/housedb.h"
#include "timeseries_dto.h"



namespace gardendb {
    namespace sql {
        using TimeseriesDto = gardendb::dto::TimeseriesDto;

        class TimeseriesDao {
            private:
                sqlpp::postgresql::connection &db;
            public:
                TimeseriesDao(sqlpp::postgresql::connection &db) : db(db){}
                std::vector<TimeseriesDto> get_all();
                TimeseriesDto get(const std::string &name, const std::string start_time, const std::string &end_time, const std::string &units);
                bool save(const TimeseriesDto &timeseries);
        };
    }
}