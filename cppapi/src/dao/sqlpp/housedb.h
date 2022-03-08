#pragma once
#include <sqlpp11/sqlpp11.h>

namespace gardendb { namespace sql { 
	 namespace views {

namespace gen_units_for_parameters {

    struct name {
        struct _alias_t {
            static constexpr const char _literal [] = "name";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T name;
                T& operator()(){ return name; }
                const T& operator()() const { return name;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct unit {
        struct _alias_t {
            static constexpr const char _literal [] = "unit";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T unit;
                T& operator()(){ return unit; }
                const T& operator()() const { return unit;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct system {
        struct _alias_t {
            static constexpr const char _literal [] = "system";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T system;
                T& operator()(){ return system; }
                const T& operator()() const { return system;}
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

    struct is_default {
        struct _alias_t {
            static constexpr const char _literal [] = "is_default";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T is_default;
                T& operator()(){ return is_default; }
                const T& operator()() const { return is_default;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::boolean>;        
    };


    struct units_for_parameters : public sqlpp::table_t<units_for_parameters,name,unit,system,description,is_default> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.units_for_parameters";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T units_for_parameters;
                T& operator()(){ return units_for_parameters; }
                const T& operator()() const { return units_for_parameters; }
            };
        };
    };

}
constexpr gen_units_for_parameters::units_for_parameters units_for_parameters;

namespace gen_view_locations {

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

    struct name {
        struct _alias_t {
            static constexpr const char _literal [] = "name";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T name;
                T& operator()(){ return name; }
                const T& operator()() const { return name;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct parent_id {
        struct _alias_t {
            static constexpr const char _literal [] = "parent_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parent_id;
                T& operator()(){ return parent_id; }
                const T& operator()() const { return parent_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct parent {
        struct _alias_t {
            static constexpr const char _literal [] = "parent";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parent;
                T& operator()(){ return parent; }
                const T& operator()() const { return parent;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct latitude {
        struct _alias_t {
            static constexpr const char _literal [] = "latitude";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T latitude;
                T& operator()(){ return latitude; }
                const T& operator()() const { return latitude;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::floating_point>;        
    };

    struct longitude {
        struct _alias_t {
            static constexpr const char _literal [] = "longitude";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T longitude;
                T& operator()(){ return longitude; }
                const T& operator()() const { return longitude;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::floating_point>;        
    };

    struct horizontal_datum {
        struct _alias_t {
            static constexpr const char _literal [] = "horizontal_datum";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T horizontal_datum;
                T& operator()(){ return horizontal_datum; }
                const T& operator()() const { return horizontal_datum;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct elevation {
        struct _alias_t {
            static constexpr const char _literal [] = "elevation";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T elevation;
                T& operator()(){ return elevation; }
                const T& operator()() const { return elevation;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::floating_point>;        
    };

    struct vertical_datum {
        struct _alias_t {
            static constexpr const char _literal [] = "vertical_datum";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T vertical_datum;
                T& operator()(){ return vertical_datum; }
                const T& operator()() const { return vertical_datum;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct view_locations : public sqlpp::table_t<view_locations,id,name,parent_id,parent,latitude,longitude,horizontal_datum,elevation,vertical_datum> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.view_locations";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T view_locations;
                T& operator()(){ return view_locations; }
                const T& operator()() const { return view_locations; }
            };
        };
    };

}
constexpr gen_view_locations::view_locations view_locations;

namespace gen_catalog_view {

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

    struct location {
        struct _alias_t {
            static constexpr const char _literal [] = "location";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T location;
                T& operator()(){ return location; }
                const T& operator()() const { return location;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct parameter {
        struct _alias_t {
            static constexpr const char _literal [] = "parameter";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parameter;
                T& operator()(){ return parameter; }
                const T& operator()() const { return parameter;}
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

    struct interval {
        struct _alias_t {
            static constexpr const char _literal [] = "interval";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T interval;
                T& operator()(){ return interval; }
                const T& operator()() const { return interval;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct duration {
        struct _alias_t {
            static constexpr const char _literal [] = "duration";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T duration;
                T& operator()(){ return duration; }
                const T& operator()() const { return duration;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
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


    struct catalog_view : public sqlpp::table_t<catalog_view,id,location,parameter,type,interval,duration,version> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.catalog_view";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T catalog_view;
                T& operator()(){ return catalog_view; }
                const T& operator()() const { return catalog_view; }
            };
        };
    };

}
constexpr gen_catalog_view::catalog_view catalog_view;

namespace gen_catalog {

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

    struct timeseries_name {
        struct _alias_t {
            static constexpr const char _literal [] = "timeseries_name";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T timeseries_name;
                T& operator()(){ return timeseries_name; }
                const T& operator()() const { return timeseries_name;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct parameter {
        struct _alias_t {
            static constexpr const char _literal [] = "parameter";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parameter;
                T& operator()(){ return parameter; }
                const T& operator()() const { return parameter;}
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

    struct interval {
        struct _alias_t {
            static constexpr const char _literal [] = "interval";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T interval;
                T& operator()(){ return interval; }
                const T& operator()() const { return interval;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct duration {
        struct _alias_t {
            static constexpr const char _literal [] = "duration";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T duration;
                T& operator()(){ return duration; }
                const T& operator()() const { return duration;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
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


    struct catalog : public sqlpp::table_t<catalog,id,timeseries_name,parameter,type,interval,duration,version> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.catalog";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T catalog;
                T& operator()(){ return catalog; }
                const T& operator()() const { return catalog; }
            };
        };
    };

}
constexpr gen_catalog::catalog catalog;

namespace gen_timeseries_values {

    struct ts_id {
        struct _alias_t {
            static constexpr const char _literal [] = "ts_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T ts_id;
                T& operator()(){ return ts_id; }
                const T& operator()() const { return ts_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct name {
        struct _alias_t {
            static constexpr const char _literal [] = "name";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T name;
                T& operator()(){ return name; }
                const T& operator()() const { return name;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct date_time {
        struct _alias_t {
            static constexpr const char _literal [] = "date_time";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T date_time;
                T& operator()(){ return date_time; }
                const T& operator()() const { return date_time;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::time_point>;        
    };

    struct value {
        struct _alias_t {
            static constexpr const char _literal [] = "value";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T value;
                T& operator()(){ return value; }
                const T& operator()() const { return value;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::floating_point>;        
    };

    struct quality {
        struct _alias_t {
            static constexpr const char _literal [] = "quality";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T quality;
                T& operator()(){ return quality; }
                const T& operator()() const { return quality;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct units {
        struct _alias_t {
            static constexpr const char _literal [] = "units";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T units;
                T& operator()(){ return units; }
                const T& operator()() const { return units;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct timeseries_values : public sqlpp::table_t<timeseries_values,ts_id,name,date_time,value,quality,units> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.timeseries_values";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T timeseries_values;
                T& operator()(){ return timeseries_values; }
                const T& operator()() const { return timeseries_values; }
            };
        };
    };

}
constexpr gen_timeseries_values::timeseries_values timeseries_values;
	 }
/* tables */
/* routines */
} } 

