include_directories(dao)
include_directories(dto)
add_subdirectory(dao)
add_subdirectory(dto)
add_executable(api                             
               locations.cpp    
               database.cpp           
               config.cpp
               timeseries.cpp
               main.cpp)

target_link_libraries(api 
                      PRIVATE sqlpp11::postgresql
                      PUBLIC crow::crow
                      PUBLIC Boost::system
                      PUBLIC jwt-cpp::jwt-cpp
                      pthread                      
                      dao
                      dto
                     )
