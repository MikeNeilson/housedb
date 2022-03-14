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
            
            if(auth_header != ""){
                auto token = jwt::decode(auth_header.substr(7));               
                auto user = token.get_subject();
                CROW_LOG_DEBUG << "User presented is: " + user;
                if(!user.empty()){
                    ctx.user = user;
                } 
            }
            if(ctx.user == ""){
                ctx.user = "guest";
            }
        }

        template<typename AllContext>
        void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {

        }
};