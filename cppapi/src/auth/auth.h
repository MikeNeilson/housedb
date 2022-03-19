#pragma once
#include <crow.h>
#include <string>
#include <jwt-cpp/jwt.h>
#include <crow/middlewares/cookie_parser.h>
#include <openssl/rand.h>
#include <openssl/bio.h>
#include <chrono>

class Session{
    std::string user;
    std::chrono::time_point<std::chrono::system_clock> created_at;
    public:
        Session() :created_at(std::chrono::system_clock::now()) {}
        Session(std::string user) : Session()  {
            this->user = user;
        }
        Session(const Session &other){
            this->user = other.user;
            this->created_at = other.created_at;
        }

        std::string get_user() { return user; }
        auto get_created_at() { return this->created_at; }
    private:
        void set_user(std::string user) {
            this->user = user;
        }
    friend class Auth; // auth can use the user and other properties
};

class Auth {
    
    std::map<std::string,std::shared_ptr<Session>> sessions;
        

    public:
        struct context{    
            std::shared_ptr<Session> session;
        };

        template<typename AllContext>     
        void before_handle(crow::request &req, crow::response &res, context &ctx, AllContext &all_ctx) {
            CROW_LOG_DEBUG << "Getting Session Cookie";
            auto &cookie_ctx = all_ctx.template get<crow::CookieParser>();
            // TODO: set appropriate settings for secure and http only
            auto session_cookie = cookie_ctx.get_cookie("SESSION");
            
            if(session_cookie == ""){
                CROW_LOG_DEBUG << "Generating new session";
                auto session_id = generate_session_id();                
                sessions[session_id] = std::make_shared<Session>();
                ctx.session = sessions[session_id];
                cookie_ctx.set_cookie("SESSION",session_id);
                return;
            }

            auto session = sessions.find(session_cookie);
            if (session != sessions.end()) {
                CROW_LOG_DEBUG << "Existing session found.";
                ctx.session = session->second;
            } else {
                // statle or reset session
                CROW_LOG_INFO << "resetting user session";
                ctx.session = std::make_shared<Session>();
                auto session_id = generate_session_id();
                sessions[session_id] = ctx.session;
                cookie_ctx.set_cookie("SESSION",session_id);
            }
            
        }

        template<typename AllContext>
        void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {

        }
        

    private:
        std::string generate_session_id() {
            std::array<unsigned char,256> buffer = {0};
            std::array<unsigned char,512> base64 = {0};
            int result = RAND_bytes(buffer.data(), 256);
            if( result ){
                EVP_EncodeBlock (base64.data(),buffer.data(),buffer.size());
                return std::string(reinterpret_cast<char*>(base64.data()));
            } else {
                throw std::runtime_error("Open SSL RAND_Bytes failed with code " + ERR_get_error());
            }
        }
};