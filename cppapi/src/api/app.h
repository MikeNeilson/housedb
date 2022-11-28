#pragma once
#include <request_logger.h>
#include <crow.h>
#include "auth.h"
#include "database.h"


using ApiApp = crow::App<RequestLogger,DatabaseSession,Auth>;


void error_wrapper( std::function<void(void)> func, crow::response &res);