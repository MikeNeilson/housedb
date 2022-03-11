include_directories(../dao)
add_executable(api main.cpp locations.cpp database.cpp config.cpp timeseries.cpp)

target_link_libraries(api 
                      PRIVATE sqlpp11::postgresql
                      pthread                       
                      dao
                      dto
                     )
