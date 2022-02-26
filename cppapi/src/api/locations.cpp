#include "locations.h"
#include "locations_dao.h"

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
LocationHandler::LocationHandler(sqlpp::postgresql::connection &db) : db(db){}

void LocationHandler::routes( crow::SimpleApp &app){

    CROW_ROUTE(app, "/locations/")([&db=this->db](const crow::request &req, crow::response &res){
        gardendb::sql::LocationDao dao;
        auto result = dao.get_all(db);
        for( auto name : result ){
            res.write(name + "\r\n");
        }
        
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