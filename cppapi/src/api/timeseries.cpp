// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "app.h"
#include "timeseries.h"
#include "timeseries_dao.h"
#include "api_exception.h"

using namespace gardendb::exceptions;

TimeseriesHandler::TimeseriesHandler() {

}

void TimeseriesHandler::routes( ApiApp &app){


    CROW_ROUTE(app, "/timeseries/")([&app](const crow::request &req, crow::response &res){
        
        auto &db = app.get_middleware<DatabaseSession>().get_db(*(app.get_context<Auth>(req).user));
        gardendb::sql::TimeseriesDao dao(db);
        auto result = dao.get_all();
        auto list = std::vector<crow::json::wvalue>();
        for( auto loc: result ){
            list.emplace_back(loc.operator crow::json::wvalue());
        }
        auto json = crow::json::wvalue(list);
        res.set_header("Content-Type","application/json");
        res.write(json.dump());               
        res.end();
    });

    CROW_ROUTE(app,"/timeseries/<string>")
        .methods(crow::HTTPMethod::GET)
        ([](const crow::request& req, crow::response &res, const std::string &name){
           res.write("You wanted: " + name);
            res.end();
    });

    CROW_ROUTE(app,"/timeseries/<string>")
        .methods(crow::HTTPMethod::PUT)
        ([](const crow::request& req, crow::response &res, const std::string &name){
            res.write("You are changing: " + name);
            res.end();
        });

    CROW_ROUTE(app,"/timeseries/")
        .methods(crow::HTTPMethod::POST)
        ([&app](const crow::request& req, crow::response &res){            
            auto json_data = crow::json::load(req.body);            
            CROW_LOG_DEBUG << json_data["name"].s();
            auto &db = app.get_middleware<DatabaseSession>().get_db(*(app.get_context<Auth>(req).user));
            CROW_LOG_DEBUG << "got db";
            gardendb::sql::TimeseriesDao dao(db);
            
            try {
                CROW_LOG_DEBUG << "saving dao";
                dao.save(json_data);
            } catch ( const input_error &err ) {
                CROW_LOG_DEBUG << "***Input error***";
                crow::json::wvalue error;
                error["message"] = "Invalid user input";
                error["error"] = err.what();
                res.code = 400;
                res.write(error.dump());
            }                        
            res.end();
        });

}