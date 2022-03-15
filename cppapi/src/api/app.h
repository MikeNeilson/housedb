#pragma once
#include <request_logger.h>
#include "auth.h"
#include "database.h"


using ApiApp = crow::App<Auth,DatabaseSession,RequestLogger>;