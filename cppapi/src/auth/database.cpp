// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "database.h"
#include "auth.h"
#include <crow/middleware_context.h>
#include <thread>

void DatabaseSession::set_db_config(DatabaseSession::db_config_ptr config) { 
            this->config = config;            
};

sqlpp::postgresql::connection& DatabaseSession::get_db(/*const context &ctx*/) {
    std::map<std::thread::id,sqlpp::postgresql::connection>::iterator it;

    const std::thread::id thread_id = std::this_thread::get_id();
    it = pool.find(thread_id);
    
    if( it == pool.end() ) {
        pool[thread_id] = sqlpp::postgresql::connection(this->config);
        it = pool.find(thread_id);
    }

    //it->second.execute("select housedb_security.set_session_user('" + it->second.escape(ctx.user) + "');");    
    
    return it->second;
}        

