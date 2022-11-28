/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */


#pragma once
#include <string>
#include <vector>
#include <chrono>
#include <crow/json.h>

namespace gardendb {
    namespace dto {
        class TimeseriesDto {
            public :
                struct triple {
                    using time_point_ms = std::chrono::time_point<std::chrono::system_clock,std::chrono::milliseconds>;

                    time_point_ms date_time;
                    double value;
                    int quality;

                    triple(const crow::json::rvalue &data){                        
                        date_time = time_point_ms(std::chrono::milliseconds(data[0].i()));
                        value = data[1].d();
                        quality = data[2].d();
                    }
                    
                    operator crow::json::wvalue() const {
                        crow::json::wvalue v;
                        v[0] = date_time.time_since_epoch().count();
                        v[1] = value;
                        v[2] = quality;
                        return v;
                    }
                    operator std::string() const {
                        std::stringstream ss;
                        ss << "(" << date_time.time_since_epoch().count() << " ms" << "," << value << "," << quality;
                        return ss.str();
                    }
                };

            private:
                std::string name;
                std::string units;
                std::string interval_offset;
                std::vector<triple> values;

            public:
                TimeseriesDto(const TimeseriesDto& other);
                TimeseriesDto(TimeseriesDto&& other);
                TimeseriesDto(const std::string &name, const std::string &interval);
                TimeseriesDto(const std::string &name, const std::string &interval, const std::vector<triple> &values);
                TimeseriesDto(const std::string &name, const std::string &interval, std::vector<triple>&& values);
                TimeseriesDto(const crow::json::rvalue &data);

                const std::string get_name() const;
                const std::string get_units() const;
                const std::string get_interval_offset() const;
                const std::vector<triple>& get_values() const;

                operator crow::json::wvalue() const;
                operator std::string() const;
        };
    }
}