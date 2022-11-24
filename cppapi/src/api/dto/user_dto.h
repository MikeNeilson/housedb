/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */


#pragma once
#include <string>
#include <vector>
#include <chrono>
#include <crow/json.h>

namespace gardendb {
    namespace dto {
        class UserDto {
            private:
                uint64_t id;
                std::string username;
                std::string display_name;
                std::string email;

            public:
                UserDto( uint64_t, std::string username, std::string display_name, std::string email) 
                    : id(id), username(username), display_name(display_name), email(email) {}                    

                uint64_t get_id() const;
                const std::string& get_username() const;
                const std::string& get_display_name() const;
                const std::string& get_email() const;
        };
    }
}