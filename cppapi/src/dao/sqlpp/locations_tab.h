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
        struct Parent {
            struct _alias_t {
                static constexpr const char _literal [] = "parent";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T parent;
                    T& operator()(){ return parent; }
                    const T& operator()() const { return parent; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::varchar,sqlpp::tag::can_be_null>;
        };

        struct Latitude {
            struct _alias_t {
                static constexpr const char _literal [] = "latitude";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T latitude;
                    T& operator()(){ return latitude; }
                    const T& operator()() const { return latitude; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::floating_point,sqlpp::tag::can_be_null>;
        };

        struct Longitude {
            struct _alias_t {
                static constexpr const char _literal [] = "longitude";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T longitude;
                    T& operator()(){ return longitude; }
                    const T& operator()() const { return longitude; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::floating_point,sqlpp::tag::can_be_null>;
        };

        struct HorizontalDatum {
            struct _alias_t {
                static constexpr const char _literal [] = "horizontal_datum";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T horizontal_datum;
                    T& operator()(){ return horizontal_datum; }
                    const T& operator()() const { return horizontal_datum; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::varchar,sqlpp::tag::can_be_null>;
        };

        struct Elevation {
            struct _alias_t {
                static constexpr const char _literal [] = "elevation";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T elevation;
                    T& operator()(){ return elevation; }
                    const T& operator()() const { return elevation; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::floating_point,sqlpp::tag::can_be_null>;
        };

        struct VerticalDatum {
            struct _alias_t {
                static constexpr const char _literal [] = "vertical_datum";
                using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
                template<typename T>
                struct _member_t {
                    T vertical_datum;
                    T& operator()(){ return vertical_datum; }
                    const T& operator()() const { return vertical_datum; }
                };
            };
            using _traits = sqlpp::make_traits<sqlpp::varchar,sqlpp::tag::can_be_null>;
        };              

        struct LocationTab : public sqlpp::table_t<LocationTab,Name,Parent,Latitude,Longitude,HorizontalDatum,Elevation,VerticalDatum> {
            struct _alias_t {
                static constexpr const char _literal [] = "view_locations";
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
