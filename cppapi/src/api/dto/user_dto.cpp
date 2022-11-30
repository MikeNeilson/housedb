/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#include <crow/json.h>
#include <string>
#include <vector>
#include <chrono>
#include <utility>
#include "user_dto.h"

namespace gardendb {
namespace dto {

    UserDto::UserDto(UserDto &&other) {
        this->id = other.id;
        this->username = std::move(other.username);
        this->email = std::move(other.email);
        this->display_name = std::move(other.display_name);
    }

    UserDto::UserDto(const UserDto &other) {
        this->id = other.id;
        this->username = other.username;
        this->email = other.email;
        this->display_name = other.email;
    }

    UserDto& UserDto::operator=(const UserDto &other) {
        this->id = other.id;
        this->username = other.username;
        this->email = other.email;
        this->display_name = other.email;
        return *this;
    }

    UserDto& UserDto::operator=(UserDto &&other) {
        this->id = other.id;
        this->username = std::move(other.username);
        this->email = std::move(other.email);
        this->display_name = std::move(other.display_name);
        return *this;
    }

    uint64_t UserDto::get_id() const {
        return this->id;
    }

    const std::string& UserDto::get_username() const {
        return this->username;
    }

    const std::string& UserDto::get_display_name() const {
        return this->display_name;
    }

    const std::string& UserDto::get_email() const {
        return this->email;
    }
}  // namespace dto
}  // namespace gardendb
