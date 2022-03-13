include_directories(../dao)
add_executable(api main.cpp locations.cpp database.cpp config.cpp timeseries.cpp)

target_link_libraries(api 
                      PRIVATE sqlpp11::postgresql
                      PUBLIC crow::crow
                      PUBLIC Boost::system
                      pthread                       
                      dao
                      dto
                     )
