include_directories(headers)
add_executable(api main.cpp)
target_link_libraries(api pthread )
target_link_libraries(api PRIVATE sqlpp11::sqlpp11)