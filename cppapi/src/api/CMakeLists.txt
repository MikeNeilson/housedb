



include_directories(headers)
#include_directories(${PostgresSQL_INCLUDE_DIRS})
include_directories(../dao)
add_executable(api main.cpp locations.cpp)
#target_link_libraries(api  )

target_link_libraries(api PRIVATE sqlpp11::sqlpp11 pthread dao PostgreSQL::PostgreSQL)