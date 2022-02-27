#define CROW_MAIN
#include <crow_all.h>
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <sqlpp11/select.h>
#include <sqlpp11/alias_provider.h>
#include "locations.h"
#include "common.h"

using connection = sqlpp::postgresql::connection;

int main(int argc, char *argv[]) {
    crow::App<DatabaseSession> app;
    
    auto config = std::make_shared<sqlpp::postgresql::connection_config>();
    config->host="localhost";
    config->port=5433;
    config->dbname="housedb";
    config->user="housedb_user";
    config->password="testpassword";
    config->debug=1;
    app.loglevel(crow::LogLevel::DEBUG);
    try {
        
        connection db(config);
        CROW_LOG_DEBUG << "Database Connection Open";
        //sqlpp::connection db(pgdb);
        app.get_middleware<DatabaseSession>().set_db(&db);        

        CROW_LOG_DEBUG << "DB Session Context Set";

        CROW_ROUTE(app,"/")([](const crow::request &req){        
            return "Welcome to my data API.";
        });
    
        LocationHandler loc;

        loc.routes(app);

        app.server_name("housedb").port(18080).run();
        return 0;
    } catch( const sqlpp::postgresql::broken_connection& ex ){
        std::cout << "Connection failed: " << ex.what() << "";
        return 1;
    }


}