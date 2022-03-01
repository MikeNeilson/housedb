#include "database.h"

void DatabaseSession::set_db(sqlpp::postgresql::connection *db) { 
            this->db=db;                        
        };

sqlpp::postgresql::connection* DatabaseSession::get_db() { return this->db; }        

void DatabaseSession::before_handle(crow::request &req, crow::response &res, context &ctx) {
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