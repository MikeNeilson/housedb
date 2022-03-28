add_executable(auth
               ../ssl/sslpp.cpp
               config.cpp
               database.cpp
               main.cpp
               static/main.css)

target_link_libraries(auth
                      PRIVATE sqlpp11::postgresql
                      PUBLIC crow::crow
                      PUBLIC Boost::system
                      PUBLIC jwt-cpp::jwt-cpp
                      pthread
                     )

add_custom_command(TARGET auth PRE_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_if_different
                   ${CMAKE_CURRENT_SOURCE_DIR}/templates/* $<TARGET_FILE_DIR:auth>/templates/                   
                   COMMENT "Updating templates."
                   DEPENDS force_run
                   )
add_custom_command(TARGET auth PRE_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_if_different
                   ${CMAKE_CURRENT_SOURCE_DIR}/static/* $<TARGET_FILE_DIR:auth>/static/
                   COMMENT "Updating static files."
                   DEPENDS force_run
                   )          
                   
add_custom_command(OUTPUT force_run COMMAND cmake -E echo)
#file(COPY static DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
#configure_file(templates ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)
#install(DIRECTORY templates DESTINATION templates)