#include "GameMap.hpp"

#include <stdexcept>
#include <string>
#include <string_view>

#include "Tools.hpp"

NODE_TYPE StrToNodeType(std::string_view str) {
    switch (str[10]) {  // NODE_TYPE_*
        case 'B':
            return NODE_TYPE::BLANK;
        case 'H':
            return NODE_TYPE::HILL;
        case 'F':
            return NODE_TYPE::FORT;
        case 'K':
            return NODE_TYPE::KING;
        case 'O':
            return NODE_TYPE::OBSTACLE;
        case 'M':
            return NODE_TYPE::MARSH;
        default:
            [[unlikely]] throw std::invalid_argument(str.data());
    }
}
std::string NodeTypeToStr(NODE_TYPE type) {
    switch (std::string prefix = "NODE_TYPE_"; type) {
        case NODE_TYPE::BLANK:
            return prefix + "BLANK";
        case NODE_TYPE::HILL:
            return prefix + "HILL";
        case NODE_TYPE::FORT:
            return prefix + "FORT";
        case NODE_TYPE::KING:
            return prefix + "KING";
        case NODE_TYPE::OBSTACLE:
            return prefix + "OBSTACLE";
        case NODE_TYPE::MARSH:
            return prefix + "MARSH";
        default:
            [[unlikely]] throw std::invalid_argument(
                std::to_string(static_cast<int>(type)));
    }
}
NODE_TYPE RandomNodeType(int level) {  // FIXME full of magic numbers
    double ratio = Random(0.0, 1.0);
    if (level == 0) {
        if (ratio < 0.7)
            [[likely]] return NODE_TYPE::BLANK;
        else if (0.7 <= ratio && ratio < 0.8)
            return NODE_TYPE::FORT;
        else
            return NODE_TYPE::HILL;
    } else if (level == 1) {
        if (ratio < 0.6)
            [[likely]] return NODE_TYPE::BLANK;
        else if (0.6 <= ratio && ratio < 0.65)
            return NODE_TYPE::FORT;
        else if (0.65 <= ratio && ratio < 0.85)
            return NODE_TYPE::HILL;
        else if (0.85 <= ratio && ratio < 0.95)
            return NODE_TYPE::OBSTACLE;
        else
            return NODE_TYPE::MARSH;
    } else
        [[unlikely]] throw std::invalid_argument(std::to_string(level));
}
