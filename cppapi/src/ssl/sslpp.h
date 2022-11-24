#pragma once
#include <openssl/evp.h>
#include <string>
#include <sstream>
#include <vector>
#include <functional>
#include <string_encoding.h>
#include <cmath>
#include <iostream>

namespace openssl {    
        
    std::string pkcs5_pbkdf2_hmac(const std::array<unsigned char,32> &salt, int iter, const std::string &password, const EVP_MD* md= EVP_sha256());

    std::vector<unsigned char> b64decode(const std::string& encoded);
    template<typename T, int N>
    std::array<unsigned char,N> b64decode(const std::string &encoded) {
        std::array<unsigned char,N> output = {0};
        std::cout << "Decoded " << EVP_DecodeBlock(output.data(),reinterpret_cast<const unsigned char*>(encoded.c_str()),encoded.size());
        return output;
    }
    
    
    template<typename T, int N>
    inline std::string b64encode(const std::array<T,N>& bytes){
        std::array<T,static_cast<int>(4*std::ceil((N/3.0)))> buffer = {0};
        EVP_EncodeBlock(buffer.data(), bytes.data(), N);
        return std::string(reinterpret_cast<const char*>(buffer.data()));
    }
}