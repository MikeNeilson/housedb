#include "locations.h"

/*
void LocationHandler::get(const crow::request &req, crow::response &res){
    res.write("test");
    res.end();
}

void LocationHandler::get(const crow::request &req, crow::response &res, const std::string &name){
    
}

void LocationHandler::put(const crow::request &req, crow::response &res, const std::string &name){
    res.write("You are changing: " + name);
    res.end();
}*/

void LocationHandler::routes( crow::SimpleApp &app){

    CROW_ROUTE(app, "/locations/")([](const crow::request &req, crow::response &res){
        res.write("New test");
        res.end();
    });

    CROW_ROUTE(app,"/locations/<string>")
        .methods(crow::HTTPMethod::GET)
        ([](const crow::request& req, crow::response &res, const std::string &name){
           res.write("You wanted: " + name);
            res.end();
    });

    CROW_ROUTE(app,"/locations/<string>")
        .methods(crow::HTTPMethod::PUT)
        ([](const crow::request& req, crow::response &res, const std::string &name){
            res.write("You are changing: " + name);
            res.end();
        });

}