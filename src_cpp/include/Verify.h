#ifndef Verify_H
#define Verify_H

#include <cstdlib>
#include <iostream>
#include <string>
#include <utility>

#include "luaapi.h"
using namespace std;

class VERIFY {
   private:
    int privilege = -1, armyID = -1;

   public:
    VERIFY(int _armyID, int _privilege);
    int GetArmyID();
};

int Register(int armyID, int privilege = 0);
int GetArmyID();

extern VERIFY* verify;

#endif  // Verify_H