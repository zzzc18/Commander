#ifndef GameMap_H
#define GameMap_H

#include <fstream>
#include <iostream>
#include <string>
#include <utility>

#include "LuaAPI.h"
#include "Verify.h"

enum NODE_TYPE {
    NODE_TYPE_BLANK,
    NODE_TYPE_HILL,
    NODE_TYPE_FORT,
    NODE_TYPE_KING,
    NODE_TYPE_OBSTACLE,
    NODE_TYPE_MARSH
};

class NODE {
   public:
    // 每秒更新一次兵力
    void Update();
    // 每25秒大更新
    void BigUpdate();

    std::string GetType() const;
    int GetUnitNum() const;
    int GetBelong() const;

    void ModifyUnitNum(int _unitNum);
    void ModifyBelong(int id);
    void ModifyType(std::string _type);
    void ModifyType(NODE_TYPE _type);
    NODE(NODE_TYPE _type = NODE_TYPE_BLANK, int _unitNum = 0, int _belong = 0);
    NODE_TYPE Type() const;

   protected:
    NODE_TYPE type;
    int unitNum;
    int belong;
};

class MAP {
   public:
    // 每秒更新一次兵力
    void Update();
    // 每25秒大更新
    void BigUpdate();

    std::string GetNodeType(int x, int y) const;
    void InitNode(int x, int y, NODE_TYPE type);
    void SetKingPos(int id, std::pair<int, int> pos);
    bool InMap(int x, int y);
    bool InMap(std::pair<int, int> pos);
    std::pair<int, int> GetSize() const;
    MAP(int x, int y);

    NODE GetNode(int x, int y) const;
    int GetBelong(int x, int y) const;
    int GetUnitNum(int x, int y) const;

    void ModifyNode(int x, int y, NODE node);

   private:
    NODE mat[50][50];
    int sizeX, sizeY;
};

void LoadMap();
void RandomGenMap(int playerNum = 0, int level = 0);
void WriteMap();

bool GetVision(std::pair<int, int> node, int armyID = GetArmyID());
int GetBelong(int x, int y);
std::string GetNodeType(int x, int y);
int GetUnitNum(int x, int y);

std::ifstream& operator>>(std::ifstream& _ifstream, NODE& node);
std::ofstream& operator<<(std::ofstream& _ofstream, const NODE& node);
std::ifstream& operator>>(std::ifstream& _ifstream, MAP*& mapPtr);
std::ofstream& operator<<(std::ofstream& _ofstream, const MAP* mapPtr);

extern MAP* MainMap;

#endif  // GameMap_H
