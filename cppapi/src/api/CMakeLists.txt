include_directories(headers)
add_executable(api main.cpp locations.cpp)
#target_link_libraries(api  )
target_link_libraries(api PRIVATE sqlpp11::sqlpp11 pthread)