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

        void set_db(sqlpp::postgresql::connection *db) { 
            this->db=db;                        
        };
        sqlpp::postgresql::connection* get_db() { return this->db; }

        void before_handle(crow::request &req, crow::response &res, context &ctx) {
            CROW_LOG_DEBUG << "Handling DB Session";
            auto user = req.get_header_value("user");
            CROW_LOG_DEBUG << "Users presented is: " + user;
            if( !user.empty()) {
                try {
                    db->execute("select housedb_security.set_session_user('" + db->escape(user) + "');");
                } catch( const std::exception &err ) {
                    res.code = 401;
                    res.end();
                }
            }
            
            
        }

        void after_handle(crow::request &req, crow::response &res, context &ctx) {

        }
};