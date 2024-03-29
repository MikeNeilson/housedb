/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */


#pragma once
#include <crow/json.h>
#include <string>
#include <vector>
#include <chrono>

namespace gardendb {
namespace dto {
/**
 * @brief Basic User Info
 * 
 * @api_schema
 * 
 */
class UserDto {
 private:
    /**
     * @brief 
     * @api_schema_ignore
     */
    uint64_t id;
    std::string username;
    std::string display_name;
    std::string email;

 public:
    UserDto(uint64_t id, const std::string &username, const std::string &display_name, const std::string &email)
        : id(id), username(username), display_name(display_name), email(email) {}
    UserDto(UserDto &&other);
    UserDto(const UserDto &other);

    UserDto& operator=(const UserDto &other);
    UserDto& operator=(UserDto &&other);

    uint64_t get_id() const;
    const std::string& get_username() const;
    const std::string& get_display_name() const;
    const std::string& get_email() const;
};
}  // namespace dto
}  // namespace gardendb
