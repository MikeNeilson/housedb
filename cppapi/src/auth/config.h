/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <string>
#include <memory>
#include <crow.h>
#include <sqlpp11/postgresql/connection_config.h>


class Config {
    public:
        using db_config_ptr = std::shared_ptr<sqlpp::postgresql::connection_config>;
    // database config
    private: 
        db_config_ptr db_config;

        int threads = 1;
        std::string server_name = "gardendb_auth";
        crow::LogLevel log_level = crow::LogLevel::INFO;

        void load_file(const std::string &filename);
        void load_env(const std::string &prefix);
        crow::LogLevel log_level_str_to_enum(const std::string& log_level);

    public:
        Config(int argc, char **argv);
        const db_config_ptr get_db_config() const;
        
        const crow::LogLevel& get_app_log_level() const;
        int get_threads() const;
        const std::string& get_server_name() const;        

};