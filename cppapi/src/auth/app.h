#pragma once
#include <request_logger.h>
#include "auth.h"
#include "database.h"
#include <crow/middlewares/cookie_parser.h>


using ApiApp = crow::App<crow::CookieParser,Auth,DatabaseSession,RequestLogger>;