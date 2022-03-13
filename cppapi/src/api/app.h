#pragma once
#include "database.h"
#include "request_logger.h"

using ApiApp = crow::App<DatabaseSession,RequestLogger>;