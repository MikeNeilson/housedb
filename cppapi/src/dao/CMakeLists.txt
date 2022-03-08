add_library(dao sqlpp/housedb.h locations_dao.cpp timeseries_dao.cpp)

target_link_libraries(dao PRIVATE sqlpp11::sqlpp11 PostgreSQL::PostgreSQL)