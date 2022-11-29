// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
// Except portions incidated
#include "sslpp.h"

namespace openssl {

    std::string pkcs5_pbkdf2_hmac(const std::array<unsigned char, 32> &salt, int iter,
                                  const std::string &password, const EVP_MD* md) {
        std::array<unsigned char, 512> buffer = {0};
        int result = PKCS5_PBKDF2_HMAC(password.c_str(),
                                       password.size(),
                                       salt.data(),
                                       salt.size(),
                                       iter,
                                       md,
                                       EVP_MD_meth_get_result_size(md),
                                       buffer.data());

        return b64encode<unsigned char, 512>(buffer);
    }
}  // namespace openssl
