// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

#include "timeseries_dto.h"

using namespace std;
using namespace crow::json;
namespace gardendb {
    namespace dto {
        TimeseriesDto::TimeseriesDto(const TimeseriesDto &other){
            this->name = other.name;
            this->units = other.units;
            this->interval_offset = other.interval_offset;
            this->values = other.values;
        }

        TimeseriesDto::TimeseriesDto(TimeseriesDto&& other){
            this->name = ::move(other.name);
            this->units = ::move(other.units);
            this->interval_offset = ::move(other.interval_offset);
            this->values = ::move(other.values);
        }

        TimeseriesDto::TimeseriesDto(const string &name, const string &interval_offset){
            this->name = name;
            this->interval_offset = interval_offset; 
        }
        TimeseriesDto::TimeseriesDto(const string &name, const string &interval_offset, const vector<TimeseriesDto::triple> &values){
            this->name = name;
            this->interval_offset = interval_offset;
            this->values = values;
        }

        TimeseriesDto::TimeseriesDto(const string &name, const string &interval_offset, vector<TimeseriesDto::triple>&& values){
            this->name = name;
            this->interval_offset = interval_offset;
            this->values = ::move(values);
        }

        TimeseriesDto::TimeseriesDto(const rvalue &data){
            this->name = data["name"].s();
            
            this->interval_offset = data["interval_offset"].s();
            if( data.has("units") ){
                this->units = data["units"].s();
            }
            if( data.has("values")){
                for( const auto &val: data["values"]) {
                    this->values.push_back( triple(val));
                }
            }
        }

        const std::string TimeseriesDto::get_name() const {
            return this->name;
        }
        const std::string TimeseriesDto::get_units() const{
            return this->units;
        }

        const std::string TimeseriesDto::get_interval_offset() const{
            return this->interval_offset;
        }

        const std::vector<TimeseriesDto::triple>& TimeseriesDto::get_values() const {
            return this->values;
        }

        TimeseriesDto::operator crow::json::wvalue(){
            auto val = crow::json::wvalue();
            val["name"] = this->name;
            val["units"] = this->units;
            val["interval_offset"] = this->interval_offset;
            crow::json::wvalue the_values; 
            for( size_t i = 0; i < this->values.size(); i++){
                the_values[i] = (crow::json::wvalue)this->values[i];
            }
            val["values"] = ::move(the_values);
            return val;
        }

        TimeseriesDto::operator std::string() const{
            stringstream ss;
            ss << this->name << "{interval_offset=" << this->interval_offset << ",units=" << this->units << ",# of values=" << this->values.size() << "}";
            return ss.str();
        }
    }
}