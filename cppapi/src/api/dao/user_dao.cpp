// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
// Except portions incidated
#include "user_dao.h"
#include "user_dto.h"

namespace gardendb {
namespace sql {
using UserDto = gardendb::dto::UserDto;
using gardendb::sql::views::active_user_auth_keys;

std::vector<UserDto> get_all() {
    std::vector<UserDto> users;
    return users;
}
bool UserDao::save(const UserDto &location) {
    return false;
}
std::unique_ptr<UserDto> UserDao::fromApiKey(const std::string& apikey) {
    auto query = sqlpp::select(active_user_auth_keys.username, active_user_auth_keys.key_name,
                               active_user_auth_keys.apikey)
                        .from(active_user_auth_keys)
                        .where(active_user_auth_keys.apikey == apikey);
    return std::make_unique<UserDto>(0, "guest1", "guest1", "");
}
std::unique_ptr<UserDto> UserDao::fromName(const std::string& name) {
    return std::make_unique<UserDto>(0, "guest2", "guest2", "");
}
}  // namespace sql
}  // namespace gardendb
