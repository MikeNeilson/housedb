cmake_minimum_required(VERSION 3.0)
project(cppapi VERSION 1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(BUILD_STATIC_API "Wether not the final build should be Static or Dynamically linked" OFF)

if( BUILD_STATIC_API)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" )
    set(Boost_USE_STATIC_LIBS ON)
else (BUILD_STATIC_API)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a" )
    set(Boost_USE_STATIC_LIBS OFF)
endif()
set(BUILD_SHARED_LIBS OFF)

#set(PostgreSQL_TYPE_INCLUDE_DIR "/usr/include/postgresql/")
find_package(OpenSSL REQUIRED)
find_package(Boost COMPONENTS system REQUIRED)

add_subdirectory(src)
