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

add_custom_command(TARGET auth POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_if_different
                   ${CMAKE_CURRENT_SOURCE_DIR}/templates/* $<TARGET_FILE_DIR:auth>/templates/
                   )
#file(COPY static DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
#configure_file(templates ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)
#install(DIRECTORY templates DESTINATION templates)