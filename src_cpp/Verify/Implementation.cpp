#include "Verify.h"

VERIFY::VERIFY(int _armyID, int _privilege) {
    switch (_privilege) {
        case 0:  // Army commander
            if (_armyID < 0) throw - 2;
            armyID = _armyID;
            privilege = _privilege;
            break;
        case 1:  // Army higest commander
            break;
        case 2:  // Replay Mode
            privilege = _privilege;
            break;
        case 3:  // Server
            privilege = _privilege;
            break;
        default:
            throw - 1;
            break;
    }
}

int VERIFY::GetArmyID() { return armyID; }