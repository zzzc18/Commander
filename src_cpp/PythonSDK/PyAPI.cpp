#include <pybind11/pybind11.h>

#include <tuple>
#include <utility>

#include "GameMap.hpp"
#include "UserAPI.hpp"
#include "Verification.hpp"

namespace py = pybind11;

PYBIND11_MODULE(Commander, m) {
    py::module_ AI_SDK =
        m.def_submodule("AI_SDK", "Python AI_SDK for Commander");
    AI_SDK
        .def("MoveTo",
             [](int x, int y, double moveNum) {
                 UserAPI::Singleton().move_to({x, y}, moveNum);
             })
        .def("MoveByDirection",
             [](int x, int y, double moveNum, int direction) {
                 UserAPI::Singleton().move_by_direction({x, y}, moveNum,
                                                        direction);
             })
        .def("MoveByCoordinates",
             [](int srcX, int srcY, int destX, int destY, double moveNum) {
                 UserAPI::Singleton().move_by_coordinates(
                     {srcX, srcY}, {destX, destY}, moveNum);
             })
        .def("IsConnected",
             [](int srcX, int srcY, int destX, int destY) {
                 return UserAPI::Singleton().is_connected(srcX, srcY, destX,
                                                          destY);
             })
        .def("SetSelectedPos",
             [](int x, int y) {
                 UserAPI::Singleton().setSelectedPos({x, y});
             })
        .def("GetSelectedPos",
             []() -> std::pair<int, int> {
                 VECTOR pos = UserAPI::Singleton().getSelectedPos();
                 return {pos.x, pos.y};
             })
        .def("GetCurrentStep",
             []() { return UserAPI::Singleton().get_current_step(); })
        .def("GetKingPos", []() -> std::pair<int, int> {
            VECTOR pos = UserAPI::Singleton().king_pos();
            return {pos.x, pos.y};
        });

    py::enum_<NODE_TYPE>(m, "NODE_TYPE")
        .value("BLANK", NODE_TYPE::BLANK)
        .value("HILL", NODE_TYPE::HILL)
        .value("FORT", NODE_TYPE::FORT)
        .value("KING", NODE_TYPE::KING)
        .value("OBSTACLE", NODE_TYPE::OBSTACLE)
        .value("MARSH", NODE_TYPE::MARSH)
        .export_values();

    py::module_ GameMap = m.def_submodule("GameMap", "GameMap for Commander");
    GameMap.def("GetSize", []() { return MAP::Singleton().GetSize(); })
        .def("InMap",
             [](int x, int y) {
                 return MAP::Singleton().InMap({x, y});
             })
        .def("IsViewable",
             [](int x, int y) {
                 return MAP::Singleton().IsViewable({x, y});
             })
        .def("GetType",
             [](int x, int y) {
                 return MAP::Singleton().GetType({x, y});
             })
        .def("GetUnitNum",
             [](int x, int y) {
                 return MAP::Singleton().GetUnitNum({x, y});
             })
        .def("GetBelong",
             [](int x, int y) {
                 return MAP::Singleton().GetBelong({x, y});
             })
        .def("GetKingPos",
             [](int armyID) { return MAP::Singleton().GetKingPos(armyID); });

    py::module_ Verification =
        m.def_submodule("Verification", "Verification for Commander");
    Verification.def("GetArmyID",
                     []() { return VERIFICATION::Singleton().GetArmyID(); });
}
