// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
#include <string>
#include <vector>
#include "app.h"
#include "timeseries.h"
#include "timeseries_dao.h"
#include "api_exception.h"

using gardendb::exceptions::throw_with_trace;

TimeseriesHandler::TimeseriesHandler() {}

void TimeseriesHandler::routes(ApiApp &app) {
    CROW_ROUTE(app, "/timeseries/")([&app](const crow::request &req, crow::response &res){
        error_wrapper([&app, &req, &res](){
            auto &db = app.get_middleware<DatabaseSession>().get_db(*(app.get_context<Auth>(req).user));
            gardendb::sql::TimeseriesDao dao(db);
            auto result = dao.get_all();
            auto list = std::vector<crow::json::wvalue>();
            for (auto loc : result) {
                list.emplace_back(loc.operator crow::json::wvalue());
            }
            auto json = crow::json::wvalue(list);
            res.set_header("Content-Type", "application/json");
            res.write(json.dump());
            res.end();
        }, res);
    });

    CROW_ROUTE(app, "/timeseries/<string>")
        .methods(crow::HTTPMethod::GET)
        ([&app](const crow::request& req, crow::response &res, const std::string &name) {
            error_wrapper([&app, &req, &res, &name]() {
                res.write("You wanted: " + name);
                res.end();
            }, res);
    });

    CROW_ROUTE(app, "/timeseries/<string>")
        .methods(crow::HTTPMethod::PUT)
        ([&app](const crow::request& req, crow::response &res, const std::string &name) {
            error_wrapper([&app, &req, &res, &name]() {
                res.write("You are changing: " + name);
                res.end();
            }, res);
        });

/**
 * @brief Write timeseries data
 * 
 * @response{201} Timeseries was created and data saved
 * @response{203} Data was saved, not response content
 * 
 */
    CROW_ROUTE(app, "/timeseries/")
        .methods(crow::HTTPMethod::POST)
        ([&app](const crow::request& req, crow::response &res) {
            error_wrapper([&app, &req, &res]() {
                auto json_data = crow::json::load(req.body);
                CROW_LOG_DEBUG << json_data["name"].s();
                auto &db = app.get_middleware<DatabaseSession>().get_db(*(app.get_context<Auth>(req).user));
                CROW_LOG_DEBUG << "got db";
                gardendb::sql::TimeseriesDao dao(db);
                CROW_LOG_DEBUG << "saving dao";
                dao.save(json_data);
                res.code = 201;
                res.end();
            }, res);
        });
}
