// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
#include <string>
#include <vector>
#include "app.h"
#include "locations.h"
#include "locations_dao.h"
#include "api_exception.h"

using gardendb::exceptions::throw_with_trace;


LocationHandler::LocationHandler() {}

void LocationHandler::routes(ApiApp &app) {
    /**
     * @brief 
     * 
     * @api_path{/locations}
     *  <get>
     *      <description>Get all locations in the database</description>
     *  </get>
     * @end_api_path
     * 
     */
    CROW_ROUTE(app, "/locations/")([&app](const crow::request &req, crow::response &res){
        error_wrapper([&app, &req, &res]() {
            auto &db = app.get_middleware<DatabaseSession>().get_db((*app.get_context<Auth>(req).user));
            gardendb::sql::LocationDao dao(db);
            auto result = dao.get_all();
            auto list = std::vector<crow::json::wvalue>();
            for (auto loc : result) {
                list.emplace_back(loc);
            }
            auto json = crow::json::wvalue(list);
            res.set_header("Content-Type", "application/json");
            res.write(json.dump());
            res.end();
        }, res);
    });

    CROW_ROUTE(app, "/locations/<string>")
        .methods(crow::HTTPMethod::GET)
        ([&app](const crow::request& req, crow::response &res, const std::string &name) {
            error_wrapper([&app, &req, &res, &name]() {
                res.write("You wanted: " + name);
                res.end();
            }, res);
    });

    CROW_ROUTE(app, "/locations/<string>")
        .methods(crow::HTTPMethod::PUT)
        ([&app](const crow::request& req, crow::response &res, const std::string &name) {
            error_wrapper([&app, &req, &res, &name]() {
                res.write("You are changing: " + name);
                res.end();
            }, res);
        });

    CROW_ROUTE(app, "/locations/")
        .methods(crow::HTTPMethod::POST)
        ([&app](const crow::request& req, crow::response &res) {
            error_wrapper([&app, &req, &res]() {
                auto json_data = crow::json::load(req.body);
                CROW_LOG_DEBUG << json_data["name"].s();
                auto &db = app.get_middleware<DatabaseSession>().get_db(*(app.get_context<Auth>(req).user));
                CROW_LOG_DEBUG << "got db";
                gardendb::sql::LocationDao dao(db);
                CROW_LOG_DEBUG << "saving dao";
                auto result = dao.save(json_data);
                CROW_LOG_DEBUG << "done: " << result;
                if (result) {
                    res.code = 201;
                } else {
                    res.code = 422;
                    res.write("Unable to save data");
                }
                res.end();
            }, res);
        });
}
