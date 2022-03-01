#include "config.h"

void Config::load_file(const std::string &filename) {

}
void Config::load_env() {

}

//    public:

Config::Config(int argc, char **argv){
    db_config = std::make_shared<sqlpp::postgresql::connection_config>();
    db_config->host="localhost";
    db_config->port=5433;
    db_config->dbname="housedb";
    db_config->user="housedb_user";
    db_config->password="testpassword";
    db_config->debug=1;
}
const Config::db_config_ptr Config::get_db_config() const {
    return this->db_config;
}

const crow::LogLevel& Config::get_app_log_level() const {
    return this->log_level;
}
int Config::get_threads() const {
    return this->threads;
}

const std::string& Config::get_server_name() const {
    return this->server_name;
}
