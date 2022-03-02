#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include "crow_all.h"
#include "database.h"

class LocationHandler {
    private:
        //sqlpp::postgresql::connection &db;

    public:
        LocationHandler();
        void routes(ApiApp &app);
};