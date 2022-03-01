#pragma once
#include <string>
#include "crow_all.h"

namespace gardendb {
    namespace dto {
        class LocationDto {
            private:
                std::string name;
                std::string parent;
                double latitude;
                double longitude;
                std::string horizontal_datum;
                double elevation;
                std::string vertical_datum;
            public:

                LocationDto() {}
                LocationDto(const std::string& name, 
                            const std::string& parent,
                            double latitude, 
                            double longitude,
                            const std::string& horizontal_datum,
                            double elevation,
                            const std::string& vertical_datum );
                LocationDto( const crow::json::rvalue &data);

                const std::string& get_name() const;
                const std::string& get_parent() const;
                double get_latitude() const;
                double get_longitude() const;
                const std::string& get_horizontal_datum() const;      
                double get_elevation() const;
                const std::string& get_vertical_datum() const;

                operator crow::json::wvalue();
        };
    }
}