// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "database.h"
#include "user_dto.h"
#include <crow/middleware_context.h>
#include <thread>

void DatabaseSession::set_db_config(DatabaseSession::db_config_ptr config) { 
            this->config = config;            
};

sqlpp::postgresql::connection& DatabaseSession::get_db() { 
    std::map<std::thread::id,sqlpp::postgresql::connection>::iterator it;

    const std::thread::id thread_id = std::this_thread::get_id();
    it = pool.find(thread_id);
    
    if( it == pool.end() ) {
        pool[thread_id] = sqlpp::postgresql::connection(this->config);
        it = pool.find(thread_id);
    }
    
    return it->second;
}        

sqlpp::postgresql::connection& DatabaseSession::get_db(const gardendb::dto::UserDto& user) { 
    auto &conn = this->get_db();
    conn.execute("select housedb_security.set_session_user('" + conn.escape(user.get_username()) + "');");
    return conn;
}
