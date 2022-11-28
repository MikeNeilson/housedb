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
#include "app.h"
#include "config.h"
#include "api_exception.h"
#include <signal.h>

using connection = sqlpp::postgresql::connection;
using namespace gardendb::exceptions;

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

void error_wrapper( std::function<void(void)> func, crow::response &res) {
    try {
        func();
    } catch( const gardendb::exceptions::input_error& ex) {
        res.code = 400;
        CROW_LOG_ERROR << ex.what();
        const boost::stacktrace::stacktrace* st = boost::get_error_info<traced>(ex);
        if (st) {
        CROW_LOG_ERROR << *st << '\n';
        }
        res.write("Unable to process input.");
        res.end();
    } catch( const std::exception& ex) {
        CROW_LOG_ERROR << "Unable to process input: " << ex.what();
        res.write("Server Error.");
        res.code = 500;
        res.end();
    }
}