#include "config.h"

#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <algorithm>
#include <optionparser.h>

using namespace std;

void Config::load_file(const std::string &filename) {
    ifstream file(filename);
    stringstream tmp;
    tmp << file.rdbuf();    
    auto config = crow::json::load(tmp.str());
     
    db_config->host=config["host"].s();
    db_config->port=config["port"].i();
    db_config->dbname=config["dbname"].s();
    db_config->user=config["user"].s();
    db_config->password=config["password"].s();
    db_config->debug=config["db_debug"].i();
    if( config.has("server_name") ){
        this->server_name=config["server_name"].s();
    }
    
    if( config.has("log_level") ){
        this->log_level = log_level_str_to_enum(config["log_level"].s());
    }

    if( config.has("threads") ) {
        this->threads = config["threads"].i();
    }


}
void Config::load_env(const std::string &prefix) {    
    db_config->host=getenv(string(prefix+"HOST").c_str());
    db_config->port=atoi(getenv(string(prefix+"PORT").c_str()));
    db_config->dbname=getenv(string(prefix+"DBNAME").c_str());
    db_config->user=getenv(string(prefix+"USER").c_str());
    db_config->password=getenv(string(prefix+"PASSWORD").c_str());
    db_config->debug=atoi(getenv(string(prefix+"DB_DEBUG").c_str()));
    std::string tmp_server_name( getenv(string(prefix+"SERVER_NAME").c_str()));
    std::string loglevel( getenv(string(prefix+"_LOG_LEVEL").c_str()));
    std::string tmp_threads( getenv(string(prefix+"_THREADS").c_str()));

    if( tmp_server_name != "" ) {
        this->server_name = tmp_server_name;
    }

    if( loglevel != "" ) {
        this->log_level = log_level_str_to_enum(loglevel);
    }

    if( tmp_threads != "" ) {
        this->threads = atoi(tmp_threads.c_str());
    }
}

crow::LogLevel Config::log_level_str_to_enum(const std::string& log_level) {        
    std::string ll(log_level);
    transform(ll.begin(),ll.end(),ll.begin(),::toupper);
    if( ll == "DEBUG" ) {
        return crow::LogLevel::DEBUG;
    } else if( ll == "INFO" ) {
        return crow::LogLevel::INFO;
    } else if( ll == "WARNING" ) {
        return crow::LogLevel::WARNING;
    } else if( ll == "ERROR" ) {
        return crow::LogLevel::ERROR;
    } else if( ll == "CRITICAL" ) {
        return crow::LogLevel::CRITICAL;
    } else {
        throw runtime_error("Invalid log level requested.");
    }
}

struct Arg : public option::Arg {
  static option::ArgStatus Required(const option::Option& option, bool msg)
  {
    if (option.arg != 0)
      return option::ARG_OK;
    if (msg) cerr << "Option '" << option << "' requires an argument" << endl;
    return option::ARG_ILLEGAL;
  }
};

enum optionIndex {UNKNOWN, HELP, FILE_CONFIG, ENV};
const option::Descriptor usage[] = {
    { UNKNOWN,    0,"", "",        option::Arg::None, "USAGE: example_arg [options]\n\n"
                                                   "Options:" },
    { HELP,       0,"h", "help",   option::Arg::None, "  \t-h,--help  \tPrint usage and exit." },
    { FILE_CONFIG,0,"f","file", Arg::Required,  "  \t-f,--file=<file>  \tconfig file to use"},
    { ENV,        0,"e","env", option::Arg::Optional,"   \t-e,--env[=prefix]  \tenvironment variable prefix. defaults to GARDENDB_"},
    { 0, 0, 0, 0, 0, 0 }
};


//    public:

Config::Config(int argc, char **argv){    
    argc -= (argc>0);
    argv += (argv>0);
    option::Stats stats(usage, argc,argv);
    option::Option options[stats.options_max], buffer[stats.buffer_max];
    option::Parser parser(usage,argc,argv,options,buffer);

    if( parser.error() ) {
        throw runtime_error("Bad parameters");
    }

    if( options[HELP].count() == 1 ){
        cout << "help called" << endl;
    }

    db_config = std::make_shared<sqlpp::postgresql::connection_config>();
    if( options[FILE_CONFIG ]) {
        cout << "looking up in file" << endl;
        load_file(options[FILE_CONFIG].arg );
    } else if( options[ENV] ) {
        cout << "using env config" << endl;
        string prefix( options[ENV].arg == nullptr ? "GARDENDB_" : options[ENV].arg );
        load_env(prefix);
    } else {
        cerr << "must specify either a file or to use the environment" << endl;
        exit(1);
    }

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
