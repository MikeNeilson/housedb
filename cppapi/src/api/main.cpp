#define CROW_MAIN
#include <crow_all.h>
#include <sqlpp11/select.h>
#include <sqlpp11/alias_provider.h>

int main(int argc, char *argv[]) {
    crow::SimpleApp app;
    CROW_ROUTE(app,"/")([](const crow::request &req){
        
        return req.get_header_value("user-agent");
    });
    app.port(18080).run();
    return 0;
}