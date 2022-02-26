add_library(dao sqlpp/locations_tab.h locations_dao.cpp)

target_link_libraries(dao PRIVATE sqlpp11::sqlpp11 PostgreSQL::PostgreSQL)