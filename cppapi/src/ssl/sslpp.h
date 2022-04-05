#pragma once
#include <openssl/evp.h>
#include <string>
#include <sstream>
#include <vector>
#include <functional>
#include <string_encoding.h>
#include <cmath>

namespace openssl {    
        
    std::string pkcs5_pbkdf2_hmac(const std::array<unsigned char,32> &salt, int iter, const std::string &password, const EVP_MD* md= EVP_sha256());

    std::vector<unsigned char> b64decode(const std::string& encoded);
    
    
    template<typename T, int N>
    inline std::string b64encode(const std::array<T,N>& bytes){
        std::array<T,static_cast<int>(4*std::ceil((N/3.0)))> buffer;
        EVP_EncodeBlock(buffer.data(), bytes.data(), N);
        return std::string(reinterpret_cast<const char*>(buffer.data()));
    }
}