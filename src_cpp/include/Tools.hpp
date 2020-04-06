#pragma once

#ifndef Tools_hpp
#define Tools_hpp

#include <istream>
#include <random>
#include <type_traits>

// returns a random number in [l,r]
template <typename type>
auto Random(type l, type r) -> std::enable_if_t<std::is_integral_v<type>, type>;
template <typename type>
auto Random(type l, type r)
    -> std::enable_if_t<std::is_floating_point_v<type>, type>;

// extracts and discards characters until and including delim.
// example: cin>>skip('\n')>>arg1>>arg2...
class skip final {
   public:
    explicit skip(char delim);
    friend std::istream& operator>>(std::istream& is, skip skipper);

   private:
    char _delim;
};

#include "detail/Tools.hpp"

#endif  // Tools_hpp
