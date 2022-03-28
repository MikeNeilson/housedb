#pragma once
#include <crow.h>
#include <string>
#include <jwt-cpp/jwt.h>
#include <crow/middlewares/cookie_parser.h>
#include <openssl/rand.h>
#include <openssl/bio.h>
#include <sqlpp11/postgresql/connection.h>
#include <chrono>
#include "authdb.h"
#include "sslpp.h"

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

SQLPP_ALIAS_PROVIDER(pw_salt);
SQLPP_ALIAS_PROVIDER(pw_iterations);
SQLPP_ALIAS_PROVIDER(pw_parts);

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

        bool do_login(const crow::json::rvalue &form, std::shared_ptr<Session> current_session, sqlpp::postgresql::connection &db){
            auto &users_tbl = authdb::tables::garden_users;
            auto &cred_tbl = authdb::tables::user_crendentials;
            auto user_query = sqlpp::select( sqlpp::all_of(users_tbl) ).from(users_tbl).where(
                users_tbl.username == form["username"].s()
                ||
                users_tbl.email == form["username"].s()
            );
            auto result = db(user_query);            
            if( result.size() == 1){
                auto inner = sqlpp::cte(sqlpp::alias::a).as(
                                    sqlpp::select(
                                            sqlpp::verbatim("regexp_split_to_array(password_hash,E'\\$')").as(pw_parts)
                                    )
                                    .from(cred_tbl)
                                    .where(cred_tbl.id == result.begin()->id));
                auto cred_query = sqlpp::select(sqlpp::verbatim("pw_parts[0]").as(pw_salt), sqlpp::verbatim("pw_parts[1]").as(pw_iterations))
                                    .from(sqlpp::from_table(inner)).unconditionally();
                auto parts = db(sqlpp::with(inner)(cred_query));
               /* const auto& row = parts.begin();
                if( row) {
                    std::string salt = row.pw_salt;
                    int iterations = row.pw_iterations;
                    return true;
                }
                return false;*/
                return true;
                // check password
                // reset session
                // set user variable
                
            } else if( result.size() > 1){
                CROW_LOG_CRITICAL << "User database is corrupted";
                return false;
            } // no user
            return false;
        }

        bool do_register(const crow::json::rvalue &form, std::shared_ptr<Session> current_session, sqlpp::postgresql::connection &db){
            
            return false;
        }

        template<typename AllContext>
        void after_handle(crow::request &req, crow::response &res, context &ctx, AllContext& /*unused*/) {

        }
        

    private:
        std::string generate_session_id() {
            std::array<unsigned char,256> buffer = {0};            
            int result = RAND_bytes(buffer.data(), buffer.size());
            if( result ){
                std::stringstream ss;
                ss << std::hex << std::setfill('0');
                for( auto c: buffer){
                    ss << std::setw(2) << static_cast<int>(c);
                }
                return ss.str();                
            } else {
                throw std::runtime_error("Open SSL RAND_Bytes failed with code " + ERR_get_error());
            }
        }
};