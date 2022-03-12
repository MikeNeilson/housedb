#include "timeseries_dao.h"
#include <sqlpp11/sqlpp11.h>
#include <crow/json.h>
#include <crow/logging.h>
#include <chrono>
#include <sqlpp11/postgresql/connection.h>
#include "api_exception.h"

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

        void TimeseriesDao::save( const gardendb::dto::TimeseriesDto &ts) {
            /*auto update = sqlpp::insert_into(views::view_timeseries)
                                .set(views::view_timeseries.name = name.get_name())
                                ;*/
            auto insert_raw = sqlpp::insert_into(views::timeseries_values)
                                                    .columns(
                                                        views::timeseries_values.name /*= parameter(views::timeseries_values.name)*/,
                                                        views::timeseries_values.units /*= parameter(views::timeseries_values.units)*/,
                                                        views::timeseries_values.date_time /*= parameter(views::timeseries_values.date_time)*/,
                                                        views::timeseries_values.value /*= parameter(views::timeseries_values.value)*/,
                                                        views::timeseries_values.quality /*= parameter(views::timeseries_values.quality)*/
                                                    );
            //auto prepared_insert = db.prepare(insert_raw);
            const auto &tsv = views::timeseries_values;
            CROW_LOG_DEBUG << "inserting";
            for( auto tr: ts.get_values()){
                std::string tr_s = tr;
                CROW_LOG_DEBUG << "using " << tr_s;
                //sqlpp::time_point t = std::chrono::time_point_cast<std::chrono::microseconds>(tr.date_time);                
                
                insert_raw.values.add(tsv.name = ts.get_name(),
                                      tsv.units = ts.get_units(),
                                      tsv.date_time = std::chrono::time_point_cast<std::chrono::microseconds>(tr.date_time),
                                      tsv.value = tr.value,
                                      tsv.quality = tr.quality);
            }
                        
            CROW_LOG_DEBUG << "inserting";
            try{
                db(insert_raw);
                CROW_LOG_DEBUG << "inserted";                
            } catch( const sqlpp::postgresql::sql_user_error& err ){
                CROW_LOG_WARNING << err.what() << err.code();
                CROW_LOG_WARNING << "rethrowing as input_error";
                if (err.code() == "ZX082") {
                    throw input_error(err.what());
                }                
            }                    
        }


        TimeseriesDto TimeseriesDao::get(const std::string &name, const std::string start_time, const std::string &end_time, const std::string &units){
            return TimeseriesDto(name,"");
        }
    }
}