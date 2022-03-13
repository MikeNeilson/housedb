#pragma once
#include <crow.h>

class Auth {
    
    
    public:
        struct context{    
            std::string user;
        };

        template<typename AllContext>     
        void before_handle(crow::request &req, crow::response &res, context &ctx, AllContext &all_ctx) {
            auto user = req.get_header_value("user");                
            CROW_LOG_DEBUG << "User presented is: " + user;
            if( !user.empty()) {
                try {
                    ctx.user = user;            
                } catch( const std::exception &err ) {
                    res.code = 401;
                    res.end();
                }
            }
        }

        template<typename AllContext>
        void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {

        }
};