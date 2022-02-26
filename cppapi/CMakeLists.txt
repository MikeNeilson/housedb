cmake_minimum_required(VERSION 3.0)
project(cppapi VERSION 1)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_subdirectory(src/deps)
add_subdirectory(src/api)