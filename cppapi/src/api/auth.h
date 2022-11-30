/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */
#pragma once
#include <crow.h>
#include <jwt-cpp/jwt.h>
#include <boost/optional.hpp>
#include <memory>
#include <string>
#include "user_dao.h"
#include "user_dto.h"
#include "database.h"

class Auth {
 public:
    struct context{
        boost::optional<gardendb::dto::UserDto> user;
    };

    template<typename AllContext>
    void before_handle(crow::request &req, crow::response &res, context &ctx, AllContext &all_ctx) {
        std::string auth_header = req.get_header_value("authorization");
        /* TODO: api key and openid token */
        auto idx = std::string::npos;
        CROW_LOG_INFO << "Attempting to lookup user.";
        auto &db = all_ctx.template get<DatabaseSession>().pool->get_db();
        gardendb::sql::UserDao dao(db);
        CROW_LOG_INFO << "Have DB and dao, now lookup auth type.";
        if ((idx = auth_header.find("apikey")) != std::string::npos) {
            auto apikey = auth_header.substr(idx+std::string("apikey").size()+1);
            CROW_LOG_INFO << "Looking up key: " << apikey;
            ctx.user = dao.fromApiKey(apikey);
        } else if (auth_header.find("bearer")) {
            res.code = 500;
            res.write("{\"error\":\"Not Implemented\"}");
            res.end();
        } else if (!auth_header.empty()) {
            res.code = 500;
            res.write("{\"error\":\"Invalid authentication presented\"");
            res.end();
        }
        if (ctx.user) {
            CROW_LOG_INFO << "Got user '" << ctx.user->get_username() << "'";
        }
    }

    template<typename AllContext>
    void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {}
};
