#pragma once

#ifndef System_hpp
#define System_hpp

#include <string>
#include <string_view>
#include <vector>

//可能以后有用的用于界面切换的场景树
class [[deprecated]] SCENE_TREE {
   public:
    void SwitchTo(std::string_view name);
    void AddEdge(std::string_view father, std::string_view son);
    std::string GetCurrentScene() const;

   protected:
    int nowPos;
    struct SCENE_TREE_NODE {
        std::string name;
        int id;
        // TODO: some scene class here(ptr is good)
        std::vector<int> child;
        explicit SCENE_TREE_NODE(std::string_view);
    };
    std::vector<SCENE_TREE_NODE> nodeArray;
};

#endif  // System_hpp
