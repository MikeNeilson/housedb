// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "app.h"
#include "locations.h"
#include "locations_dao.h"


LocationHandler::LocationHandler() {

}

void LocationHandler::routes( ApiApp &app){


    CROW_ROUTE(app, "/locations/")([&app](const crow::request &req, crow::response &res){
                
        auto &db = app.get_middleware<DatabaseSession>().get_db(app.get_context<DatabaseSession>(req));
        gardendb::sql::LocationDao dao(db);
        auto result = dao.get_all();
        auto list = std::vector<crow::json::wvalue>();
        for( auto loc: result ){
            list.emplace_back(loc);
        }
        auto json = crow::json::wvalue(list);
        res.set_header("Content-Type","application/json");
        res.write(json.dump());               
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

    CROW_ROUTE(app,"/locations/")
        .methods(crow::HTTPMethod::POST)
        ([&app](const crow::request& req, crow::response &res){            
            auto json_data = crow::json::load(req.body);            
            CROW_LOG_DEBUG << json_data["name"].s();
            auto &db = app.get_middleware<DatabaseSession>().get_db(app.get_context<DatabaseSession>(req));
            CROW_LOG_DEBUG << "got db";
            gardendb::sql::LocationDao dao(db);
            CROW_LOG_DEBUG << "saving dao";           
            auto result = dao.save(json_data);
            CROW_LOG_DEBUG << "done";
            res.end();
            //auto result = dao.save(nullptr);
        });

}