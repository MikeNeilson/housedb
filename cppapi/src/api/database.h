/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <map>
#include <crow.h>
#include <sqlpp11/sqlpp11.h>
#include <thread>
#include <sqlpp11/postgresql/connection.h>
#include <sqlpp11/postgresql/connection_config.h>

class DatabaseSession {
    using db_config_ptr = std::shared_ptr<sqlpp::postgresql::connection_config>;
    db_config_ptr config;
    sqlpp::postgresql::prepared_statement_t set_user;

    std::map<std::thread::id,sqlpp::postgresql::connection> pool;
    
    public:
        struct context{
            //sqlpp::postgressql::connection *db;
            std::string user;
        };

        void set_db_config(db_config_ptr config);
        sqlpp::postgresql::connection& get_db(const context &ctx);

        void before_handle(crow::request &req, crow::response &res, context &ctx);

        void after_handle(crow::request &req, crow::response &res, context &ctx) {

        }
};

