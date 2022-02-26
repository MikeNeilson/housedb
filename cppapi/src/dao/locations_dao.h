#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <vector>
#include "sqlpp/locations_tab.h"

namespace gardendb {
    namespace sql {
        class LocationDao {
            public:
                std::vector<std::string> get_all(sqlpp::postgresql::connection &db);
        };
    }
}