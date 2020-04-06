#include <memory>

#include "Constant.hpp"
#include "Verify.hpp"

int VERIFY::Register(int armyID, int privilege) {  // FIXME magic numbers
    if (singleton_) return 1;
    try {
        singleton_ = std::make_unique<VERIFY>(armyID, privilege);
    } catch (int error) {
        return error;
    }
    return 0;
}
VERIFY& VERIFY::Singleton() { return *singleton_; }

int VERIFY::GetArmyID() const { return _armyID; }

VERIFY::VERIFY(int armyID, int privilege) {  // FIXME magic numbers
    switch (privilege) {
        case 0:  // army commander
            if (armyID == SERVER) throw -2;
            _armyID = armyID;
            break;
        case 1:  // army leader
            break;
        case 2:  // replay mode
            [[fallthrough]];
        case 3:  // server
            _armyID = SERVER;
            break;
        default:  // invalid
            throw -1;
    }
    _privilege = privilege;
}
