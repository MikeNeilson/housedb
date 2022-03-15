add_executable(auth
               config.cpp
               database.cpp
               main.cpp)

target_link_libraries(auth
                      PRIVATE sqlpp11::postgresql
                      PUBLIC crow::crow
                      PUBLIC Boost::system
                      PUBLIC jwt-cpp::jwt-cpp
                      pthread
                     )
