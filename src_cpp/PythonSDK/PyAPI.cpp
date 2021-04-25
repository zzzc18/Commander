#include <pybind11/pybind11.h>

#include <tuple>
#include <utility>

#include "GameMap.hpp"
#include "UserAPI.hpp"
#include "Verification.hpp"

namespace py = pybind11;

// 便于python调用对UserAPI进行封装
class PythonAI_SDK {
   public:
    void MoveTo(int x, int y, double moveNum) {
        UserAPI::Singleton().move_to({x, y}, moveNum);
    }

    void MoveByDirection(int x, int y, double moveNum, int direction) {
        UserAPI::Singleton().move_by_direction({x, y}, moveNum, direction);
    }

    void MoveByCoordinates(int srcX, int srcY, int destX, int destY,
                           double moveNum) {
        UserAPI::Singleton().move_by_coordinates({srcX, srcY}, {destX, destY},
                                                 moveNum);
    }

    void SetSelectedPos(int x, int y) {
        UserAPI::Singleton().setSelectedPos({x, y});
    }

    std::tuple<int, int> GetSelectedPos() {
        VECTOR pos = UserAPI::Singleton().getSelectedPos();
        return {pos.x, pos.y};
    }

    bool IsConnected(int srcX, int srcY, int destX, int destY) {
        return UserAPI::Singleton().is_connected(srcX, srcY, destX, destY);
    }

    std::tuple<int, int> GetKingPos() {
        VECTOR pos = UserAPI::Singleton().king_pos();
        return {pos.x, pos.y};
    }

    int GetCurrentStep() { return UserAPI::Singleton().get_current_step(); }
};

// 便于python调用对GameMap进行封装
class PythonGameMap {
   public:
    //获取地图大小 (行数，列数)
    std::tuple<int, int> GetSize() { return MAP::Singleton().GetSize(); }

    //判断 pos 是否在地图内
    bool InMap(int x, int y) { return MAP::Singleton().InMap({x, y}); }
    //判断当前军队是否可看见 pos
    bool IsViewable(int x, int y) {
        return MAP::Singleton().IsViewable({x, y});
    }
    //当前军队看到 pos 的类型
    NODE_TYPE GetType(int x, int y) { return MAP::Singleton().GetType({x, y}); }
    //当前军队看到 pos 的兵数
    int GetUnitNum(int x, int y) { return MAP::Singleton().GetUnitNum({x, y}); }
    //当前军队看到 pos 的所属军队
    int GetBelong(int x, int y) { return MAP::Singleton().GetBelong({x, y}); }
    //当前军队的王的位置
    std::pair<int, int> GetKingPos(int armyID) {
        return MAP::Singleton().GetKingPos(armyID);
    }
};

// 上面两个类封装不一定有必要，可以直接lambda
PYBIND11_MODULE(Commander, m) {
    py::module_ AI_SDK =
        m.def_submodule("AI_SDK", "Python AI_SDK for Commander");
    AI_SDK.def("MoveTo", &PythonAI_SDK::MoveTo)
        .def("MoveByDirection", &PythonAI_SDK::MoveByDirection)
        .def("MoveByCoordinates", &PythonAI_SDK::MoveByCoordinates)
        .def("IsConnected", &PythonAI_SDK::IsConnected)
        .def("SetSelectedPos", &PythonAI_SDK::SetSelectedPos)
        .def("GetSelectedPos", &PythonAI_SDK::GetSelectedPos)
        .def("GetCurrentStep", &PythonAI_SDK::GetCurrentStep)
        .def("GetKingPos", &PythonAI_SDK::GetKingPos);

    py::enum_<NODE_TYPE>(m, "NODE_TYPE")
        .value("BLANK", NODE_TYPE::BLANK)
        .value("HILL", NODE_TYPE::HILL)
        .value("FORT", NODE_TYPE::FORT)
        .value("KING", NODE_TYPE::KING)
        .value("OBSTACLE", NODE_TYPE::OBSTACLE)
        .value("MARSH", NODE_TYPE::MARSH)
        .export_values();

    py::module_ GameMap = m.def_submodule("GameMap", "GameMap for Commander");
    GameMap.def("GetSize", &PythonGameMap::GetSize)
        .def("InMap", &PythonGameMap::InMap)
        .def("IsViewable", &PythonGameMap::IsViewable)
        .def("GetType", &PythonGameMap::GetType)
        .def("GetUnitNum", &PythonGameMap::GetUnitNum)
        .def("GetBelong", &PythonGameMap::GetBelong)
        .def("GetKingPos", &PythonGameMap::GetKingPos);

    py::module_ Verification =
        m.def_submodule("Verification", "Verification for Commander");
    Verification.def("GetArmyID",
                     []() { VERIFICATION::Singleton().GetArmyID(); });
}
