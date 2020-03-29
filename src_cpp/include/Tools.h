#ifndef Tools_H
#define Tools_H

#include <iostream>
#include <utility>

inline std::pair<int, int> operator+(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first + y.first, x.second + y.second};
}

inline std::pair<int, int> operator-(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first - y.first, x.second - y.second};
}

/**
 * @brief 六边形相邻格数组，偶数行是direct[0][]，奇数行是是direct[1][]
 *
 * 从右上开始为0，顺时针递增编号
 */
inline std::pair<int, int> direct[2][6] = {
    {{-1, 0}, {0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}},
    {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {0, -1}, {-1, 0}}};

#endif
