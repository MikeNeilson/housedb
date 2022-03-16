// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#define CROW_MAIN
#include <crow.h>
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <sqlpp11/select.h>
#include <sqlpp11/alias_provider.h>
#include "app.h"
#include "config.h"
#include <signal.h>
#include <sstream>
#include <fstream>
#include <jwt-cpp/jwt.h>

using connection = sqlpp::postgresql::connection;

ApiApp app;

void health_check_handler(int sig){
    if( sig = SIGUSR1 ) {
        CROW_LOG_ERROR << "health check called";
    }
}
using namespace std;
int main(int argc, char *argv[]) {

    struct sigaction sigusr;
    sigusr.sa_handler = &health_check_handler;
    sigemptyset(&sigusr.sa_mask);
    sigusr.sa_flags = 0;
    sigaction(SIGUSR1,&sigusr,NULL);
    
    Config config(argc,argv);    
    
    app.loglevel(config.get_app_log_level());
    try {
        stringstream ss;
        string pubkey;
        string privkey;
        string ca;
        {
            // scoping for fstreams
            fstream ca_file ("../../test_config/certs/ca.cert.pem");
            fstream pubkey_file ("../../test_config/certs/jwt.pem");
            fstream privkey_file("../../test_config/certs/jwt.key");
            ss << pubkey_file.rdbuf();
            pubkey = ss.str();
            ss.str(""); ss.clear();
            
            ss << privkey_file.rdbuf();
            privkey = ss.str();

            ss.str(""); ss.clear();

            ss << ca_file.rdbuf();
            ca = ss.str();
            cout << pubkey << endl;
            cout << privkey << endl;
            cout << ca << endl;
        }
        //connection db(config.get_db_config());
        CROW_LOG_DEBUG << "Database Connection Open";
        //sqlpp::connection db(pgdb);
        app.get_middleware<DatabaseSession>().set_db_config(config.get_db_config());        

        CROW_LOG_DEBUG << "DB Session Context Set";

        vector<string> x5c_keys;
        auto test = jwt::helper::load_public_key_from_string(pubkey);
        
        x5c_keys.push_back(pubkey);

        CROW_ROUTE(app,"/")([&pubkey,&privkey,&x5c_keys](const crow::request &req){        
            return "test return";
            /*
            auto token = jwt::create()
                            .set_header_claim("x5c", jwt::claim{x5c_keys.begin(),x5c_keys.end()})
                            .set_issuer("test")
                            .set_subject("testuser")
                            .sign(jwt::algorithm::rs256{"",privkey,"",""})
            
                        ;

            return token;*/
        });

        
    
        
        
        app.server_name(config.get_server_name()).concurrency(config.get_threads()).port(18080).run();
        return 0;
    } catch( const sqlpp::postgresql::broken_connection& ex ){
        std::cout << "Connection failed: " << ex.what() << "";
        return 1;
    }


}