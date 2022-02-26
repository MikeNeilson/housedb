#define CROW_MAIN
#include <crow_all.h>
#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <sqlpp11/select.h>
#include <sqlpp11/alias_provider.h>
#include "locations.h"

class Test {
    public:
        void operator()(const crow::request& req, crow::response &res) {
            res.write("test2");
            res.end();
        }
};


int main(int argc, char *argv[]) {
    crow::SimpleApp app;
    
    auto config = std::make_shared<sqlpp::postgresql::connection_config>();
    config->host="localhost";
    config->port=5433;
    config->dbname="housedb";
    config->user="housedb_user";
    config->password="testpassword";

    try {
        sqlpp::postgresql::connection db(config);
        //sqlpp::connection db(pgdb);
        

        CROW_ROUTE(app,"/")([](const crow::request &req){        
            return "Welcome to my data API.";
        });
    
        LocationHandler loc(db);

        loc.routes(app);

        app.server_name("housedb").port(18080).run();
        return 0;
    } catch( const sqlpp::postgresql::broken_connection& ex ){
        std::cout << "Connection failed: " << ex.what() << "";
        return 1;
    }


}