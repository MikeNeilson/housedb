/*
 * Copyright 2022 Michael Neilson
 * Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
 */

#pragma once
#include <exception>
#include <string>
#include <boost/stacktrace.hpp>
#include <boost/exception/all.hpp>

namespace gardendb {
namespace exceptions {
typedef boost::error_info<struct tag_stacktrace, boost::stacktrace::stacktrace> traced;

template<class E>
void throw_with_trace(const E& e) {
    throw boost::enable_error_info(e) << traced(boost::stacktrace::stacktrace());
}


class input_error : public std::runtime_error {
 public:
    explicit input_error(std::string msg) noexcept : runtime_error(msg) {}
};
}  // namespace exceptions
}  // namespace gardendb
