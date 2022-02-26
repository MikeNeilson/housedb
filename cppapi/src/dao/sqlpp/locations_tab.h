#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/table.h>
namespace gardendb {
    namespace sql {

        struct Name {
            struct _alias_t {
                static constexpr const char _literal [] = "name";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T name;
                    T& operator()(){ return name; }
                    const T& operator()() const { return name; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::varchar>;
        };

        struct LocationTab : public sqlpp::table_t<LocationTab,Name> {
            struct _alias_t {
                static constexpr const char _literal [] = "locations";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T locationTab;
                    T& operator()(){
                        return locationTab;
                    }
                    const T& operator()() const {
                        return locationTab;
                    }
                };
            };

            
        };

        extern LocationTab locations;
    }
}
