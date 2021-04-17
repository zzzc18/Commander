/**
 * @file Tools.hpp
 *
 * @brief ../Tools.hpp 中的一些细节实现
 *  @c detail 中的都是一些外部不应该使用的内容
 */

#pragma once

#ifndef detail_Tools_hpp
#define detail_Tools_hpp

#include <istream>
#include <limits>
#include <random>
#include <type_traits>

#include "Tools.hpp"

namespace detail {
inline std::mt19937_64& RandomEngine() {
    static std::mt19937_64 engine(std::random_device{}());
    return engine;
}
}  // namespace detail
template <typename type>
auto Random(type l, type r)
    -> std::enable_if_t<std::is_integral_v<type>, type> {
    return std::uniform_int_distribution<type>(l, r)(detail::RandomEngine());
}
template <typename type>
auto Random(type l, type r)
    -> std::enable_if_t<std::is_floating_point_v<type>, type> {
    return std::uniform_real_distribution<type>(l, r)(detail::RandomEngine());
}

///////////////////////////////////////////////////////////////////////////////

inline skip::skip(char delim) : _delim(delim) {}
inline std::istream& operator>>(std::istream& is, skip skipper) {
    return is.ignore(std::numeric_limits<std::streamsize>::max(),
                     skipper._delim);
}

#endif  // detail_Tools_hpp
