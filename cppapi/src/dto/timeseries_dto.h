#pragma once
#include <string>
#include "crow_all.h"

namespace gardendb {
    namespace dto {
        class TimeseriesDto {
            private:
                std::string name;
                std::string units;
                std::string interval_offset;      

            public:
                TimeseriesDto(const TimeseriesDto& other);
                TimeseriesDto(TimeseriesDto&& other);
                TimeseriesDto(const std::string &name, const std::string &interval);
                TimeseriesDto(const crow::json::rvalue &data);

                const std::string get_name() const;
                const std::string get_units() const;
                const std::string get_interval_offset() const;

                operator crow::json::wvalue();
        };
    }
}