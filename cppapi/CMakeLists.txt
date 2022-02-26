cmake_minimum_required(VERSION 3.0)
project(cppapi VERSION 1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(PostgreSQL_TYPE_INCLUDE_DIR "/usr/include/postgresql/")
find_package(PostgreSQL REQUIRED)

add_subdirectory(src/deps)
add_subdirectory(src/dao)
add_subdirectory(src/api)