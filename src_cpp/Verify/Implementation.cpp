/**
 * @file Implementation.cpp
 *
 * @brief @c Verify 模块类相关函数的定义
 */

#include "Constant.hpp"
#include "Verify.hpp"

int VERIFY::Register(int armyID, int privilege) {  // FIXME magic numbers
    if (singletonPtr_) delete singletonPtr_;
    try {
        singletonPtr_ = new VERIFY(armyID, privilege);
    } catch (int error) {
        return error;
    }
    return 0;
}
VERIFY& VERIFY::Singleton() { return *singletonPtr_; }

int VERIFY::GetArmyID() const { return _armyID; }
int VERIFY::GetPrivilege() const { return _privilege; }

VERIFY::VERIFY(int armyID, int privilege) {  // FIXME magic numbers
    switch (privilege) {
        case 0:  // army commander
            if (armyID == SERVER) throw -2;
            _armyID = armyID;
            break;
        case 1:  // army leader
            break;
        case 2:  // replay mode
            _armyID = SERVER;
            //获取全图视野
            break;
        case 3:  // server
            _armyID = SERVER;
            break;
        default:  // invalid
            throw -1;
    }
    _privilege = privilege;
}

// FIXME
// 如果是inline在hpp里好像会在GameMap.dll也有一个？然后delete两次，需要研究一下这个问题
VERIFY::DELETER VERIFY::deleter_;
VERIFY::DELETER::~DELETER() { delete singletonPtr_; }
