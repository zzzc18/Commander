#ifndef GameMap_H
#define GameMap_H

#include <utility>
#include "LuaAPI.h"

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
    void ModifyBelong(int id);
    NODE(NODE_TYPE _type = NODE_TYPE_BLANK, int _unitNum = 0, int _belong = 0);

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

    void InitNode(int x, int y, NODE_TYPE type);
    void SetKingPos(int id, std::pair<int, int> pos);
    bool InMap(int x, int y);
    bool InMap(std::pair<int, int> pos);
    std::pair<int, int> GetSize();
    MAP(int x, int y);

   private:
    NODE mat[50][50];
    int sizeX, sizeY;
};

void LoadMap();
void RandomGenMap(int playerNum = 0, int level = 0);
void WriteMap();

extern MAP* MainMap;

#endif  // GameMap_H