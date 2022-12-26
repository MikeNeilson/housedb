/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <crow/json.h>
#include <crow/logging.h>
#include <vector>
#include <string>
#include "sqlpp/housedb.h"
#include "timeseries_dto.h"

namespace gardendb {
namespace sql {
using TimeseriesDto = gardendb::dto::TimeseriesDto;

class TimeseriesDao {
 private:
    sqlpp::postgresql::connection &db;

 public:
    explicit TimeseriesDao(sqlpp::postgresql::connection &db) : db(db) {}
    std::vector<TimeseriesDto> get_all();
    TimeseriesDto get(const std::string &name, const std::string &start_time,
                      const std::string &end_time, const std::string &units);
    void save(const TimeseriesDto &timeseries);
};
}  // namespace sql
}  // namespace gardendb
