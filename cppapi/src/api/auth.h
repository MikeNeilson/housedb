#pragma once
#include <crow.h>
#include <jwt-cpp/jwt.h>

class Auth {
    
    
    public:
        struct context{    
            std::string user;
        };

        template<typename AllContext>     
        void before_handle(crow::request &req, crow::response &res, context &ctx, AllContext &all_ctx) {
            std::string auth_header = req.get_header_value("authorization");
            /* TODO: api key and openid token */
            if(ctx.user == ""){
                ctx.user = "guest";
            }
        }

        template<typename AllContext>
        void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {

        }
};