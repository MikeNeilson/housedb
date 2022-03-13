include_directories(../dao)
add_executable(api 
               database.cpp               
               locations.cpp               
               config.cpp
               timeseries.cpp
               main.cpp)

target_link_libraries(api 
                      PRIVATE sqlpp11::postgresql
                      PUBLIC crow::crow
                      PUBLIC Boost::system
                      pthread                       
                      dao
                      dto
                     )
