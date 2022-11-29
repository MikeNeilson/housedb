// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
// Except portions incidated
#pragma once
#include <string>
#include <sstream>
#include <array>
#include <vector>
#include <iomanip>

template<typename T, int N>
inline std::string to_hex(const std::array<T, N> &input) {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for (auto c : input) {
        ss << std::setw(2) << static_cast<int>(c);
    }
    return ss.str();
}

template<typename T>
inline std::vector<T> from_hex(const std::string &hex_str) {
    std::stringstream ss(hex_str);
    std::vector<T> output;
    output.resize(hex_str.size()/2);
    char buff[3] = {0};
    while (!ss.eof()) {
        ss.read(buff, 2);
        output.push_back(static_cast<T>(std::stoi(std::string(buff), nullptr, 16)) );
    }
    return output;
}
