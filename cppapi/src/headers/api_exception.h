/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <exception>

class input_error : public std::runtime_error {
    public:
        input_error(std::string what) noexcept : runtime_error(what)  {

        }
};