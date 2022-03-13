#include "database.h"
#include <thread>

void DatabaseSession::set_db_config(DatabaseSession::db_config_ptr config) { 
            this->config = config;      
            
            //pool[i];
};

sqlpp::postgresql::connection& DatabaseSession::get_db(const context &ctx) { 
    std::map<std::thread::id,sqlpp::postgresql::connection>::iterator it;

    const std::thread::id thread_id = std::this_thread::get_id();
    it = pool.find(thread_id);
    
    if( it == pool.end() ) {
        pool[thread_id] = sqlpp::postgresql::connection(this->config);
        it = pool.find(thread_id);
    }

    it->second.execute("select housedb_security.set_session_user('" + it->second.escape(ctx.user) + "');");    
    
    return it->second;
}        

void DatabaseSession::before_handle(crow::request &req, crow::response &res, context &ctx) {
    CROW_LOG_DEBUG << "Handling DB Session";
    auto user = req.get_header_value("user");
    CROW_LOG_DEBUG << "Users presented is: " + user;
    if( !user.empty()) {
        try {
            ctx.user = user;            
        } catch( const std::exception &err ) {
            res.code = 401;
            res.end();
        }
    }    
}