#include "location_dto.h"

namespace gardendb {
    namespace dto {
        LocationDto::LocationDto(const crow::json::rvalue &data ){
            this->name = data["name"].s();
        }

        const std::string& LocationDto::get_name() const {
            return this->name;
        }
    }
}