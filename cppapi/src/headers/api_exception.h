#pragma once
#include <exception>

class input_error : public std::runtime_error {
    public:
        input_error(std::string what) noexcept : runtime_error(what)  {

        }
};