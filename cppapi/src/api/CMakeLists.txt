




#include_directories(${PostgresSQL_INCLUDE_DIRS})
include_directories(../dao)
add_executable(api main.cpp locations.cpp database.cpp config.cpp timeseries.cpp)
#target_link_libraries(api  )

target_link_libraries(api PRIVATE sqlpp11::sqlpp11 pthread dao dto PostgreSQL::PostgreSQL )
#add_link_options(api -shared-libpq)