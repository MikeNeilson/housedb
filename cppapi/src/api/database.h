#pragma once
#include <crow_all.h>
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>

class DatabaseSession {
    sqlpp::postgresql::connection *db;
    sqlpp::postgresql::prepared_statement_t set_user;
    
    public:
        struct context{
            //sqlpp::postgressql::connection *db;
        };

        void set_db(sqlpp::postgresql::connection *db);
        sqlpp::postgresql::connection* get_db();

        void before_handle(crow::request &req, crow::response &res, context &ctx);

        void after_handle(crow::request &req, crow::response &res, context &ctx) {

        }
};