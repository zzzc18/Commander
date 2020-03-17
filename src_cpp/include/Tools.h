#ifndef Tools_H
#define Tools_H

#include <utility>

inline std::pair<int, int> operator+(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first + y.first, x.second + y.second};
}

inline std::pair<int, int> operator-(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first - y.first, x.second - y.second};
}

#endif