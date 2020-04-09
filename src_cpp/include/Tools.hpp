/**
 * @file Tools.hpp
 *
 * @brief 一些通用的小工具
 */

#pragma once

#ifndef Tools_hpp
#define Tools_hpp

#include <istream>
#include <random>
#include <type_traits>

/**
 * @brief 生成整数类型随机数
 *
 * @tparam type 自动推断，无需考虑
 * @pre type 需要是整数类型
 * @param l 随机数下确界
 * @param r 随机数上确界
 * @return @c type [l,r] 上的整数类型随机数
 */
template <typename type>
auto Random(type l, type r) -> std::enable_if_t<std::is_integral_v<type>, type>;
/**
 * @brief 生成浮点类型随机数
 *
 * @tparam type 自动推断，无需考虑
 * @pre type 需要是浮点类型
 * @param l 随机数下确界
 * @param r 随机数上确界
 * @return @c type [l,r] 上的浮点类型随机数
 */
template <typename type>
auto Random(type l, type r)
    -> std::enable_if_t<std::is_floating_point_v<type>, type>;

/**
 * @brief 跳过输入流中的字符直至第一次跳过给定字符或至文件末尾
 *  用于 @c std::istream
 *
 * @example std::cin>>arg1>>skip('\n')>>arg2;
 */
class skip final {
   public:
    explicit skip(char delim);
    friend std::istream& operator>>(std::istream& is, skip skipper);

   private:
    char _delim;  //给定的字符
};

#include "detail/Tools.hpp"

#endif  // Tools_hpp
