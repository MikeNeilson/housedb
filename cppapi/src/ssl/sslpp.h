#pragma once
#include <openssl/evp.h>
#include <string>
#include <sstream>
#include <functional>

namespace openssl {    
        
    std::string pkcs5_pbkdf2_hmac(const std::string &salt, int iter, const std::string &password, const EVP_MD* md);

}