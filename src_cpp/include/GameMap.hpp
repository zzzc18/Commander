#pragma once

#ifndef GameMap_hpp
#define GameMap_hpp

#include <iostream>
#include <optional>
#include <string>
#include <string_view>
#include <utility>

#include "Constant.hpp"

using namespace GameMap;

struct VECTOR {
    int x, y;
    VECTOR operator-() const;
    VECTOR& operator+=(VECTOR other);
    friend VECTOR operator+(VECTOR lhs, VECTOR rhs);
    VECTOR& operator-=(VECTOR other);
    friend VECTOR operator-(VECTOR lhs, VECTOR rhs);
    VECTOR& operator*=(int c);
    friend VECTOR operator*(VECTOR v, int c);
    friend VECTOR operator*(int c, VECTOR v);
    friend bool operator==(VECTOR lhs, VECTOR rhs);
    friend bool operator!=(VECTOR lhs, VECTOR rhs);
};

/**
 * @brief 六边形相邻格数组，偶数行是DIR[0][]，奇数行是是DIR[1][]
 *
 * 从右上开始为0，顺时针递增编号
 */
inline constexpr VECTOR DIR[2][6] = {
    {{-1, 0}, {0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}},
    {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {0, -1}, {-1, 0}}};

///////////////////////////////////////////////////////////////////////////////

enum class NODE_TYPE { BLANK, HILL, FORT, KING, OBSTACLE, MARSH };

class MAP final {
   public:
    MAP(const MAP&) = delete;
    MAP& operator=(const MAP&) = delete;
    static MAP& Singleton();

    friend std::istream& operator>>(std::istream& is, MAP& map);
    friend std::ostream& operator<<(std::ostream& os, const MAP& map);

    void Update();      //每秒更新一次兵力
    void BigUpdate();   //每25秒大更新
    bool MoveUpdate();  //每半秒更新一次移动操作

    bool MoveNode(int armyID, VECTOR src, VECTOR dst);

    void RandomGen(int armyCnt, int level);
    void Load(std::string_view file = "Input/map.map");
    void Save(std::string_view file = "Output/map.map");

    std::pair<int, int> GetSize() const;

    bool InMap(VECTOR pos) const;
    bool IsViewable(VECTOR pos) const;
    NODE_TYPE GetType(VECTOR pos) const;
    int GetUnitNum(VECTOR pos) const;
    int GetBelong(VECTOR pos) const;

   private:
    MAP() = default;

    int _sizeX = 0, _sizeY = 0;
    int _armyCnt = 0;
    //(source,target)
    std::optional<std::pair<VECTOR, VECTOR>> _moveCommands[MAX_ARMY_CNT + 1];
    struct NODE {
        NODE_TYPE type = NODE_TYPE::BLANK;
        int unitNum = 0;
        int belong = SERVER;
        void Update();     //每秒更新一次兵力
        void BigUpdate();  //每25秒大更新
    } _mat[MAX_GRAPH_SIZE][MAX_GRAPH_SIZE];

    friend std::istream& operator>>(std::istream& is, NODE& node);
    friend std::ostream& operator<<(std::ostream& os, NODE node);
};  // class MAP

NODE_TYPE StrToNodeType(std::string_view str);
std::string NodeTypeToStr(NODE_TYPE type);
NODE_TYPE RandomNodeType(int level);

#endif  // GameMap_hpp
