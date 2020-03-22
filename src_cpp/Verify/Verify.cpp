#include "Verify.h"

VERIFY* verify = NULL;

int Register(int armyID, int privilege) {
    if (verify != NULL) return 1;
    VERIFY* tmp = NULL;
    try {
        tmp = new VERIFY(armyID, privilege);
    } catch (int err) {
        return err;
    }
    verify = tmp;
    return 0;
}

int GetArmyID() { return verify->GetArmyID(); }