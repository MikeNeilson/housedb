// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
#include <crow/http_request.h>
#include <crow/http_response.h>

class RequestLogger {
    public:
        struct context{
            //sqlpp::postgressql::connection *db;
        };

        void before_handle(crow::request &req, crow::response &res, context &ctx) {
            CROW_LOG_INFO << req.remoteIpAddress << " "
                          << crow::method_name(req.method) << " " 
                          << req.raw_url << " " 
                          << res.code << " " << res.body.size();
        }

        void after_handle(crow::request &req, crow::response &res, context &ctx) {
           
        }
};