/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */


#include "user_dto.h"
#include <string>
#include <vector>
#include <chrono>
#include <crow/json.h>

namespace gardendb {
    namespace dto {
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
    }
}