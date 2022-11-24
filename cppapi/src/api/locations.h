/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once

#include <sqlpp11/sqlpp11.h>
#include <sqlpp11/postgresql/connection.h>
#include <crow.h>
#include "app.h"

class LocationHandler {
    private:
        //sqlpp::postgresql::connection &db;

    public:
        LocationHandler();
        void routes(ApiApp &app);
};