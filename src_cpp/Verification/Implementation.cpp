/**
 * @file Implementation.cpp
 *
 * @brief @c Verification 模块类相关函数的定义
 */

#include <windows.h>

#include <cstdlib>
#include <ctime>
#include <fstream>

#include "Constant.hpp"
#include "Debug.hpp"
#include "Verification.hpp"

int VERIFICATION::Register(int armyID, int privilege) {  // FIXME magic numbers
    if (singletonPtr_) delete singletonPtr_;
    try {
        singletonPtr_ = new VERIFICATION(armyID, privilege);
    } catch (int error) {
        return error;
    }
    return 0;
}
VERIFICATION& VERIFICATION::Singleton() { return *singletonPtr_; }

int VERIFICATION::GetArmyID() const { return _armyID; }
int VERIFICATION::GetPrivilege() const { return _privilege; }

VERIFICATION::VERIFICATION(int armyID, int privilege) {  // FIXME magic numbers
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
VERIFICATION::DELETER VERIFICATION::deleter_;
VERIFICATION::DELETER::~DELETER() { delete singletonPtr_; }

Debug& Debug::Singleton() {
    static Debug singleton;
    return singleton;
}

bool Debug::DirExist(const std::string& dirName_in) {
    DWORD ftyp = GetFileAttributesA(dirName_in.c_str());
    if (ftyp == INVALID_FILE_ATTRIBUTES) return false;  // 调用参数错误
    if (ftyp & FILE_ATTRIBUTE_DIRECTORY) return true;
    return false;
}

void Debug::InitDebugLog() {
    std::time_t t = std::time(&t) + 28800;  //转换到东八区
    struct tm* gmt = gmtime(&t);
    char cst[80];
    strftime(cst, 80, "%Y-%m-%d_%H.%M.%S", gmt);
    LogTime = cst;
    system("cd ..&mkdir GameLog");
    while (DirExist("../GameLog/" + LogTime + "_" + std::to_string(LogIndex))) {
        LogIndex++;
    }
    system(("cd ../GameLog&mkdir " + LogTime + "_" + std::to_string(LogIndex))
               .c_str());
    return;
}

void Debug::Log(std::string priority, std::string text) {
    std::ofstream logfile;
    logfile.open("../GameLog/" + LogTime + "_" + std::to_string(LogIndex) +
                     "/Running.log",
                 std::ios::app);
    if (logfile.is_open()) {
        logfile << "[" << priority << "] " << text << std::endl;
        logfile.close();
    }
    return;
}