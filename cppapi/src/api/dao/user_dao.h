/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <crow/json.h>
#include <crow/logging.h>
#include <memory>
#include <string>
#include <vector>
#include "sqlpp/housedb.h"
#include "user_dto.h"



namespace gardendb {
namespace sql {
using UserDto = gardendb::dto::UserDto;

class UserDao {
 private:
    sqlpp::postgresql::connection &db;

 public:
    explicit UserDao(sqlpp::postgresql::connection &db) : db(db) {}
    std::vector<UserDto> get_all();
    bool save(const UserDto &location);
    std::unique_ptr<UserDto> fromApiKey(const std::string& apikey);
    std::unique_ptr<UserDto> fromName(const std::string& name);
};
}  // namespace sql
}  // namespace gardendb
