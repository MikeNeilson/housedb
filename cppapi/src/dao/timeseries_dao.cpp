#include "timeseries_dao.h"
#include <sqlpp11/sqlpp11.h>
#include <crow_all.h>
#include <sqlpp11/postgresql/connection.h>

namespace gardendb {
    namespace sql {
         std::vector<TimeseriesDto> TimeseriesDao::get_all(){
                
                std::vector<TimeseriesDto> list;
                auto query = sqlpp::select(views::catalog.timeseries_name,tables::timeseries.interval_offset)
                                          .from(views::catalog.join(tables::timeseries).on(views::catalog.id == tables::timeseries.id))
                                          
                                          .unconditionally();
                auto result = db(query);
                for(const auto &row : result){
                    TimeseriesDto ts(
                                    row.timeseries_name,
                                    row.interval_offset
                                    );
                    
                    list.push_back(ts);
                }
                return list;
            }

        bool TimeseriesDao::save( const gardendb::dto::TimeseriesDto &ts) {
            /*auto update = sqlpp::insert_into(views::view_timeseries)
                                .set(views::view_timeseries.name = name.get_name())
                                ;*/
            CROW_LOG_DEBUG << "inserting";
            //db.update(update);
            CROW_LOG_DEBUG << "inserted";
            return false;
        }


        TimeseriesDto TimeseriesDao::get(const std::string &name, const std::string start_time, const std::string &end_time, const std::string &units){
            return TimeseriesDto(name,"");
        }
    }
}