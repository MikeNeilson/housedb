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
            static constexpr const char _literal [] = "housedb.flyway_schema_history";
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

namespace gen_parameters {

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


    struct parameters : public sqlpp::table_t<parameters,id,name,units> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.parameters";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parameters;
                T& operator()(){ return parameters; }
                const T& operator()() const { return parameters; }
            };
        };
    };

}
constexpr gen_parameters::parameters parameters;

namespace gen_users {

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

    struct active {
        struct _alias_t {
            static constexpr const char _literal [] = "active";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T active;
                T& operator()(){ return active; }
                const T& operator()() const { return active;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::boolean>;        
    };


    struct users : public sqlpp::table_t<users,id,username,active> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.users";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T users;
                T& operator()(){ return users; }
                const T& operator()() const { return users; }
            };
        };
    };

}
constexpr gen_users::users users;

namespace gen_permissions {

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


    struct permissions : public sqlpp::table_t<permissions,id,name> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.permissions";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T permissions;
                T& operator()(){ return permissions; }
                const T& operator()() const { return permissions; }
            };
        };
    };

}
constexpr gen_permissions::permissions permissions;

namespace gen_data_tables {

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


    struct data_tables : public sqlpp::table_t<data_tables,id,name> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.data_tables";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T data_tables;
                T& operator()(){ return data_tables; }
                const T& operator()() const { return data_tables; }
            };
        };
    };

}
constexpr gen_data_tables::data_tables data_tables;

namespace gen_user_permissions {

    struct user_id {
        struct _alias_t {
            static constexpr const char _literal [] = "user_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T user_id;
                T& operator()(){ return user_id; }
                const T& operator()() const { return user_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct permission_id {
        struct _alias_t {
            static constexpr const char _literal [] = "permission_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T permission_id;
                T& operator()(){ return permission_id; }
                const T& operator()() const { return permission_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct data_table_id {
        struct _alias_t {
            static constexpr const char _literal [] = "data_table_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T data_table_id;
                T& operator()(){ return data_table_id; }
                const T& operator()() const { return data_table_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct regex {
        struct _alias_t {
            static constexpr const char _literal [] = "regex";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T regex;
                T& operator()(){ return regex; }
                const T& operator()() const { return regex;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct granter_id {
        struct _alias_t {
            static constexpr const char _literal [] = "granter_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T granter_id;
                T& operator()(){ return granter_id; }
                const T& operator()() const { return granter_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };


    struct user_permissions : public sqlpp::table_t<user_permissions,user_id,permission_id,data_table_id,regex,granter_id> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.user_permissions";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T user_permissions;
                T& operator()(){ return user_permissions; }
                const T& operator()() const { return user_permissions; }
            };
        };
    };

}
constexpr gen_user_permissions::user_permissions user_permissions;

namespace gen_units {

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

    struct unitclass {
        struct _alias_t {
            static constexpr const char _literal [] = "unitclass";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T unitclass;
                T& operator()(){ return unitclass; }
                const T& operator()() const { return unitclass;}
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


    struct units : public sqlpp::table_t<units,unit,unitclass,system,description> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.units";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T units;
                T& operator()(){ return units; }
                const T& operator()() const { return units; }
            };
        };
    };

}
constexpr gen_units::units units;

namespace gen_intervals {

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

    struct time_interval {
        struct _alias_t {
            static constexpr const char _literal [] = "time_interval";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T time_interval;
                T& operator()(){ return time_interval; }
                const T& operator()() const { return time_interval;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct intervals : public sqlpp::table_t<intervals,id,name,time_interval> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.intervals";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T intervals;
                T& operator()(){ return intervals; }
                const T& operator()() const { return intervals; }
            };
        };
    };

}
constexpr gen_intervals::intervals intervals;

namespace gen_types {

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


    struct types : public sqlpp::table_t<types,id,name> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.types";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T types;
                T& operator()(){ return types; }
                const T& operator()() const { return types; }
            };
        };
    };

}
constexpr gen_types::types types;

namespace gen_units_parameters {

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

    struct parameter_id {
        struct _alias_t {
            static constexpr const char _literal [] = "parameter_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parameter_id;
                T& operator()(){ return parameter_id; }
                const T& operator()() const { return parameter_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
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


    struct units_parameters : public sqlpp::table_t<units_parameters,unit,parameter_id,is_default> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.units_parameters";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T units_parameters;
                T& operator()(){ return units_parameters; }
                const T& operator()() const { return units_parameters; }
            };
        };
    };

}
constexpr gen_units_parameters::units_parameters units_parameters;

namespace gen_locations {

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


    struct locations : public sqlpp::table_t<locations,id,name,parent_id,latitude,longitude,horizontal_datum,elevation,vertical_datum> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.locations";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T locations;
                T& operator()(){ return locations; }
                const T& operator()() const { return locations; }
            };
        };
    };

}
constexpr gen_locations::locations locations;

namespace gen_internal_timeseries_values {

    struct timeseries_id {
        struct _alias_t {
            static constexpr const char _literal [] = "timeseries_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T timeseries_id;
                T& operator()(){ return timeseries_id; }
                const T& operator()() const { return timeseries_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
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


    struct internal_timeseries_values : public sqlpp::table_t<internal_timeseries_values,timeseries_id,date_time,value,quality> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.internal_timeseries_values";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T internal_timeseries_values;
                T& operator()(){ return internal_timeseries_values; }
                const T& operator()() const { return internal_timeseries_values; }
            };
        };
    };

}
constexpr gen_internal_timeseries_values::internal_timeseries_values internal_timeseries_values;

namespace gen_timeseries {

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

    struct location_id {
        struct _alias_t {
            static constexpr const char _literal [] = "location_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T location_id;
                T& operator()(){ return location_id; }
                const T& operator()() const { return location_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct parameter_id {
        struct _alias_t {
            static constexpr const char _literal [] = "parameter_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T parameter_id;
                T& operator()(){ return parameter_id; }
                const T& operator()() const { return parameter_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct type_id {
        struct _alias_t {
            static constexpr const char _literal [] = "type_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T type_id;
                T& operator()(){ return type_id; }
                const T& operator()() const { return type_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct interval_id {
        struct _alias_t {
            static constexpr const char _literal [] = "interval_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T interval_id;
                T& operator()(){ return interval_id; }
                const T& operator()() const { return interval_id;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::integral>;        
    };

    struct duration_id {
        struct _alias_t {
            static constexpr const char _literal [] = "duration_id";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T duration_id;
                T& operator()(){ return duration_id; }
                const T& operator()() const { return duration_id;}
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

    struct interval_offset {
        struct _alias_t {
            static constexpr const char _literal [] = "interval_offset";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T interval_offset;
                T& operator()(){ return interval_offset; }
                const T& operator()() const { return interval_offset;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct timeseries : public sqlpp::table_t<timeseries,id,location_id,parameter_id,type_id,interval_id,duration_id,version,interval_offset> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb.timeseries";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T timeseries;
                T& operator()(){ return timeseries; }
                const T& operator()() const { return timeseries; }
            };
        };
    };

}
constexpr gen_timeseries::timeseries timeseries;

namespace gen_conversions {

    struct unit_from {
        struct _alias_t {
            static constexpr const char _literal [] = "unit_from";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T unit_from;
                T& operator()(){ return unit_from; }
                const T& operator()() const { return unit_from;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct unit_to {
        struct _alias_t {
            static constexpr const char _literal [] = "unit_to";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T unit_to;
                T& operator()(){ return unit_to; }
                const T& operator()() const { return unit_to;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };

    struct postfix_func {
        struct _alias_t {
            static constexpr const char _literal [] = "postfix_func";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T postfix_func;
                T& operator()(){ return postfix_func; }
                const T& operator()() const { return postfix_func;}
            };
        };
        using _traits = sqlpp::make_traits<sqlpp::text>;        
    };


    struct conversions : public sqlpp::table_t<conversions,unit_from,unit_to,postfix_func> {
        struct _alias_t {
            static constexpr const char _literal [] = "housedb_units.conversions";
            using _name_t = sqlpp::make_char_sequence<sizeof(_literal),_literal>;
            template<typename T>
            struct _member_t {
                T conversions;
                T& operator()(){ return conversions; }
                const T& operator()() const { return conversions; }
            };
        };
    };

}
constexpr gen_conversions::conversions conversions;
	 }
/* routines */
} } 

