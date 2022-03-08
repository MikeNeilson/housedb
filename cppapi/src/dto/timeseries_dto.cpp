#include "timeseries_dto.h"

using namespace std;
using namespace crow::json;
namespace gardendb {
    namespace dto {
        TimeseriesDto::TimeseriesDto(const TimeseriesDto &other){
            this->name = other.name;
            this->units = other.units;
            this->interval_offset = other.interval_offset;
        }

        TimeseriesDto::TimeseriesDto(TimeseriesDto&& other){
            this->name = ::move(other.name);
            this->units = ::move(other.units);
            this->interval_offset = ::move(other.interval_offset);
        }

        TimeseriesDto::TimeseriesDto(const string &name, const string &interval_offset){
            this->name = name;
            this->interval_offset = interval_offset;
        }
        TimeseriesDto::TimeseriesDto(const rvalue &data){
            this->name = data["name"].s();
            this->units = data["units"].s();
            this->interval_offset = data["interval_offset"].s();
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

        TimeseriesDto::operator crow::json::wvalue(){
            auto val = crow::json::wvalue();
            val["name"] = this->name;
            val["units"] = this->units;
            val["interval_offset"] = this->interval_offset;
            return val;
        }
    }
}