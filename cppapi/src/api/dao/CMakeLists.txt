add_library(dao sqlpp/housedb.h locations_dao.cpp timeseries_dao.cpp user_dao.cpp)

target_link_libraries(dao PRIVATE sqlpp11::postgresql PUBLIC crow::crow Boost::system)