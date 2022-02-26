#define CROW_MAIN
#include <crow_all.h>
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
    
    CROW_ROUTE(app,"/")([](const crow::request &req){        
        return "Welcome to my data API.";
    });
    
    LocationHandler loc;

    loc.routes(app);



    app.server_name("housedb").port(18080).run();
    return 0;
}