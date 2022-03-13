#pragma once
#include "auth.h"
#include "database.h"
#include "request_logger.h"

using ApiApp = crow::App<Auth,DatabaseSession,RequestLogger>;