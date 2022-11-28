// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "location_dto.h"
#include "api_exception.h"
#include <boost/optional.hpp>



namespace gardendb {
    namespace dto {
        using namespace gardendb::exceptions;

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

        LocationDto::LocationDto(const crow::json::rvalue &data ) {
            this->name = data["name"].s();
            std::string column;
            try {
                column = "parent";
                if (data.has(column) && data[column].t() != crow::json::type::Null) {
                    this->parent = data[column].s();
                }
                column = "latitude";
                if (data.has(column)) {
                    this->latitude = data[column].d();
                }
                column = "longitude";
                if (data.has(column)) {
                    this->longitude = data[column].d();
                }
                column = "horizontal_datum";
                if (data.has(column)) {
                    this->horizontal_datum = data[column].s();
                }
                column = "elevation";
                if (data.has(column)) {
                    this->elevation = data[column].d();
                }
                column = "vertical_datum";
                if (data.has(column)) {
                    this->vertical_datum = data[column].s();
                }
            }
            catch(const std::runtime_error& e)
            {
                std::stringstream ss;
                ss << "On Column '" << column << "':" << e.what();
                throw_with_trace(input_error(ss.str()));
            }
            
            
        }

        const std::string& LocationDto::get_name() const {
            return this->name;
        }

        const boost::optional<std::string>& LocationDto::get_parent() const {
            return this->parent;
        }

        const boost::optional<double>& LocationDto::get_latitude() const {
            return this->latitude;
        }

        const boost::optional<double>& LocationDto::get_longitude() const {
            return this->longitude;
        }

        const boost::optional<std::string>& LocationDto::get_horizontal_datum() const {
            return this->horizontal_datum;
        }

        const boost::optional<double>& LocationDto::get_elevation() const {
            return this->elevation;
        }

        const boost::optional<std::string>& LocationDto::get_vertical_datum() const {
            return this->vertical_datum;
        }

        LocationDto::operator crow::json::wvalue() {
            auto val = crow::json::wvalue();
            val["name"] = this->name;
            if (this->parent.has_value()) {
                val["parent"] = this->parent.get();
            }
            if (this->latitude.has_value()) {
                val["latitude"] = this->latitude.get();
            }
            if (this->longitude.has_value()) {
                val["longitude"] = this->longitude.get();
            }
            if (this->horizontal_datum.has_value()) {
                val["horizontal_datum"] = this->horizontal_datum.get();    
            }
            if (this->elevation.has_value()) {
                val["elevation"] = this->elevation.get();
            }
            if( this->vertical_datum.has_value()) {
                val["vertical_datum"] = this->vertical_datum.get();
            }
            return val;
        }
    }
}