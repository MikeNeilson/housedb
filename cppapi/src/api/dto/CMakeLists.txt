add_library(dto location_dto.cpp timeseries_dto.cpp)
target_link_libraries(dto PUBLIC crow::crow Boost::system)