#pragma once
#include <sqlpp11/sqlpp11.h>

namespace authdb { 
	 namespace views {
	 }
	 namespace tables {

namespace gen_flyway_schema_history {

    struct installed_rank {
        struct _alias_t {
            static constexpr const char _literal [] = "installed_rank";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T installed_rank;
                T& operator()(){ return installed_rank; }
                const T& operator()() const { return installed_rank;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct version {
        struct _alias_t {
            static constexpr const char _literal [] = "version";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T version;
                T& operator()(){ return version; }
                const T& operator()() const { return version;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct description {
        struct _alias_t {
            static constexpr const char _literal [] = "description";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T description;
                T& operator()(){ return description; }
                const T& operator()() const { return description;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct type {
        struct _alias_t {
            static constexpr const char _literal [] = "type";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T type;
                T& operator()(){ return type; }
                const T& operator()() const { return type;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct script {
        struct _alias_t {
            static constexpr const char _literal [] = "script";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T script;
                T& operator()(){ return script; }
                const T& operator()() const { return script;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct checksum {
        struct _alias_t {
            static constexpr const char _literal [] = "checksum";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T checksum;
                T& operator()(){ return checksum; }
                const T& operator()() const { return checksum;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct installed_by {
        struct _alias_t {
            static constexpr const char _literal [] = "installed_by";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T installed_by;
                T& operator()(){ return installed_by; }
                const T& operator()() const { return installed_by;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct installed_on {
        struct _alias_t {
            static constexpr const char _literal [] = "installed_on";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T installed_on;
                T& operator()(){ return installed_on; }
                const T& operator()() const { return installed_on;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::time_point>;        
    };

    struct execution_time {
        struct _alias_t {
            static constexpr const char _literal [] = "execution_time";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T execution_time;
                T& operator()(){ return execution_time; }
                const T& operator()() const { return execution_time;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct success {
        struct _alias_t {
            static constexpr const char _literal [] = "success";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T success;
                T& operator()(){ return success; }
                const T& operator()() const { return success;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::boolean>;        
    };


    struct flyway_schema_history : public sqlpp::table_t<flyway_schema_history,installed_rank,version,description,type,script,checksum,installed_by,installed_on,execution_time,success> {
        struct _alias_t {
            static constexpr const char _literal [] = "authdb.flyway_schema_history";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T flyway_schema_history;
                T& operator()(){ return flyway_schema_history; }
                const T& operator()() const { return flyway_schema_history; }
            };
        };
    };

}
constexpr gen_flyway_schema_history::flyway_schema_history flyway_schema_history;

namespace gen_garden_users {

    struct id {
        struct _alias_t {
            static constexpr const char _literal [] = "id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T id;
                T& operator()(){ return id; }
                const T& operator()() const { return id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct username {
        struct _alias_t {
            static constexpr const char _literal [] = "username";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T username;
                T& operator()(){ return username; }
                const T& operator()() const { return username;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct email {
        struct _alias_t {
            static constexpr const char _literal [] = "email";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T email;
                T& operator()(){ return email; }
                const T& operator()() const { return email;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct garden_users : public sqlpp::table_t<garden_users,id,username,email> {
        struct _alias_t {
            static constexpr const char _literal [] = "authdb.garden_users";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T garden_users;
                T& operator()(){ return garden_users; }
                const T& operator()() const { return garden_users; }
            };
        };
    };

}
constexpr gen_garden_users::garden_users garden_users;

namespace gen_user_crendentials {

    struct id {
        struct _alias_t {
            static constexpr const char _literal [] = "id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T id;
                T& operator()(){ return id; }
                const T& operator()() const { return id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct otp_key {
        struct _alias_t {
            static constexpr const char _literal [] = "otp_key";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T otp_key;
                T& operator()(){ return otp_key; }
                const T& operator()() const { return otp_key;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct password_hash {
        struct _alias_t {
            static constexpr const char _literal [] = "password_hash";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T password_hash;
                T& operator()(){ return password_hash; }
                const T& operator()() const { return password_hash;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct user_crendentials : public sqlpp::table_t<user_crendentials,id,otp_key,password_hash> {
        struct _alias_t {
            static constexpr const char _literal [] = "authdb.user_crendentials";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T user_crendentials;
                T& operator()(){ return user_crendentials; }
                const T& operator()() const { return user_crendentials; }
            };
        };
    };

}
constexpr gen_user_crendentials::user_crendentials user_crendentials;
	 }
/* routines */
} 

