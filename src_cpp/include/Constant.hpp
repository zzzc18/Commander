/**
 * @file Constant.hpp
 *
 * @brief C++ 使用的各类常量的定义
 */

#pragma once

#ifndef Constant_hpp
#define Constant_hpp

inline constexpr int SERVER = 0;  //服务端的军队编号

// GameMap 模块的常量
namespace GameMap {
inline constexpr int MAX_GRAPH_SIZE = 50;  //地图最大行、列数
inline constexpr int MAX_ARMY_CNT = 8;  //地图最多军队数（除服务端外）
}  // namespace GameMap

#endif  // Constant_hpp
