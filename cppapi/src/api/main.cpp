// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#define CROW_MAIN
#include <crow.h>
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <sqlpp11/select.h>
#include <sqlpp11/alias_provider.h>
#include "locations.h"
#include "timeseries.h"
#include "database.h"
#include "config.h"
#include <signal.h>

using connection = sqlpp::postgresql::connection;

ApiApp app;

void health_check_handler(int sig){
    if( sig = SIGUSR1 ) {
        CROW_LOG_ERROR << "health check called";
    }
}

int main(int argc, char *argv[]) {

    struct sigaction sigusr;
    sigusr.sa_handler = &health_check_handler;
    sigemptyset(&sigusr.sa_mask);
    sigusr.sa_flags = 0;
    sigaction(SIGUSR1,&sigusr,NULL);
    
    Config config(argc,argv);    
    
    app.loglevel(config.get_app_log_level());
    try {
        
        //connection db(config.get_db_config());
        CROW_LOG_DEBUG << "Database Connection Open";
        //sqlpp::connection db(pgdb);
        app.get_middleware<DatabaseSession>().set_db_config(config.get_db_config());        

        CROW_LOG_DEBUG << "DB Session Context Set";

        CROW_ROUTE(app,"/")([](const crow::request &req){        
            return "Welcome to my data API.";
        });
    
        LocationHandler loc;
        TimeseriesHandler ts;

        loc.routes(app);
        ts.routes(app);
        
        app.server_name(config.get_server_name()).concurrency(config.get_threads()).port(18080).run();
        return 0;
    } catch( const sqlpp::postgresql::broken_connection& ex ){
        std::cout << "Connection failed: " << ex.what() << "";
        return 1;
    }


}