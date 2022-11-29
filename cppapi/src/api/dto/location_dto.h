/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <crow/json.h>
#include <string>
#include <boost/optional.hpp>
#include "api_exception.h"

namespace gardendb {
namespace dto {
class LocationDto {
 private:
    std::string name;
    boost::optional<std::string> parent;
    boost::optional<double> latitude;
    boost::optional<double> longitude;
    boost::optional<std::string> horizontal_datum;
    boost::optional<double> elevation;
    boost::optional<std::string> vertical_datum;

 public:
    LocationDto() {}
    LocationDto(const std::string& name,
                const std::string& parent,
                double latitude,
                double longitude,
                const std::string& horizontal_datum,
                double elevation,
                const std::string& vertical_datum);
    explicit LocationDto(const crow::json::rvalue &data);

    const std::string& get_name() const;
    const boost::optional<std::string>& get_parent() const;
    const boost::optional<double>& get_latitude() const;
    const boost::optional<double>& get_longitude() const;
    const boost::optional<std::string>& get_horizontal_datum() const;
    const boost::optional<double>& get_elevation() const;
    const boost::optional<std::string>& get_vertical_datum() const;

    operator crow::json::wvalue();
};
}  // namespace dto
}  // namespace gardendb
