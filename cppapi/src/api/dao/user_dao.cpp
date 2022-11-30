// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
// Except portions incidated
#include "user_dao.h"
#include <boost/optional.hpp>
#include "user_dto.h"
#include "api_exception.h"

namespace gardendb {
namespace sql {
using UserDto = gardendb::dto::UserDto;
using gardendb::sql::views::active_user_auth_keys;
using gardendb::exceptions::throw_with_trace;
using gardendb::exceptions::input_error;

std::vector<UserDto> get_all() {
    std::vector<UserDto> users;
    return users;
}
bool UserDao::save(const UserDto &location) {
    return false;
}
boost::optional<UserDto> UserDao::fromApiKey(const std::string& apikey) {
    boost::optional<UserDto> user;
    auto query = sqlpp::select(active_user_auth_keys.username, active_user_auth_keys.key_name,
                               active_user_auth_keys.apikey)
                        .from(active_user_auth_keys)
                        .where(active_user_auth_keys.apikey == apikey);
    auto result = db(query);
    if (result.size() == 1) {
        const auto &u = result.front();
        user = UserDto(0, u.username , "guest1", "");
    }
    return user;
}

boost::optional<UserDto> UserDao::fromName(const std::string& name) {
    boost::optional<UserDto> user;
    return user;
}
}  // namespace sql
}  // namespace gardendb
