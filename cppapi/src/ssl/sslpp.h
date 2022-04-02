#pragma once
#include <openssl/evp.h>
#include <string>
#include <sstream>
#include <vector>
#include <functional>

namespace openssl {    
        
    std::string pkcs5_pbkdf2_hmac(const std::array<unsigned char,32> &salt, int iter, const std::string &password, const EVP_MD* md= EVP_sha256());

    std::vector<unsigned char> b64decode(const std::string& encoded);
    
    template<typename T>
    std::string b64encode(const T& bytes){
        return "";
    }
}