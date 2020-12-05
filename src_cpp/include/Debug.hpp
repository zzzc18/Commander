#pragma once

#ifdef DEBUG
#ifndef Debug_hpp
#define Debug_hpp

#include "GameMap.hpp"
#include "ostream"
using std::cerr;
using std::endl;
using std::ostream;

ostream& operator<<(ostream& os, VECTOR vec) {
    os << "{ ";
    os << vec.x << ' ';
    os << vec.y << ' ';
    os << "}";
    return os;
}

#endif
#endif