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
                LocationDto( const crow::json::rvalue &data);

                const std::string& get_name() const;                
        };
    }
}