#include "location_dto.h"

namespace gardendb {
    namespace dto {

        LocationDto::LocationDto(const std::string& name, 
                                 const std::string& parent,
                                 double latitude, 
                                 double longitude,
                                 const std::string& horizontal_datum,
                                 double elevation,
                                 const std::string& vertical_datum)
            : name(name), 
              parent(parent),
              latitude(latitude),
              longitude(longitude),
              horizontal_datum(horizontal_datum),
              elevation(elevation),
              vertical_datum(vertical_datum) {

            }

        LocationDto::LocationDto(const crow::json::rvalue &data ){
            this->name = data["name"].s();
            this->parent = data["parent"].s();
            this->latitude = data["latitude"].d();
            this->longitude = data["longitude"].d();
            this->horizontal_datum = data["horizontal_datum"].s();
            this->elevation = data["elevation"].d();
            this->vertical_datum = data["vertical_datum"].s();
        }

        const std::string& LocationDto::get_name() const {
            return this->name;
        }

        const std::string & LocationDto::get_parent() const {
            return this->parent;
        }

        double LocationDto::get_latitude() const {
            return this->latitude;
        }

        double LocationDto::get_longitude() const {
            return this->longitude;
        }

        const std::string& LocationDto::get_horizontal_datum() const {
            return this->horizontal_datum;
        }

        double LocationDto::get_elevation() const {
            return this->elevation;
        }

        const std::string& LocationDto::get_vertical_datum() const {
            return this->vertical_datum;
        }

        LocationDto::operator crow::json::wvalue() {
                    auto val = crow::json::wvalue();
                    val["name"] = this->name;
                    val["parent"] = this->parent;
                    val["latitude"] = this->latitude;
                    val["longitude"] = this->longitude;
                    val["horizontal_datum"] = this->horizontal_datum;
                    val["elevation"] = this->elevation;
                    val["vertical_datum"] = this->vertical_datum;
                    return val;
        }
    }
}