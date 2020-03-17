#ifndef System_H
#define System_H

#include <string>
#include <vector>
#include "LuaAPI.h"

class SCENE_TREE {
   public:
    void SwitchTo(std::string name);
    void AddEdge(std::string father, std::string son);
    std::string GetCurrentScene();

   protected:
    struct SCENE_TREE_NODE {
        std::string name;
        int id;
        // TODO: some scene class here(ptr is good)
        std::vector<int> child;
        SCENE_TREE_NODE(std::string);
    };
    std::vector<SCENE_TREE_NODE> nodeArray;
    int nowPos;
};

#endif  // System_H