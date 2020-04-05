#include "GameMap.hpp"
#include "LuaAPI.hpp"

static int RandomGenMap(lua_State *luaState) {
    MAP::Singleton().RandomGen(2, 0);  // FIXME magic numbers
    return APIreturn(luaState);
}
static int LoadMap(lua_State *luaState) {
    MAP::Singleton().Load();
    return APIreturn(luaState);
}
static int WriteMap(lua_State *luaState) {
    MAP::Singleton().Save();
    return APIreturn(luaState);
}

static int GetSize(lua_State *luaState) {
    auto [sizeX, sizeY] = MAP::Singleton().GetSize();
    return APIreturn(luaState, sizeX, sizeY);
}

static int GetVision(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().IsViewable({x, y}));
}
static int GetNodeType(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState,
                     NodeTypeToStr(MAP::Singleton().GetType({x, y})).c_str());
}
static int GetUnitNum(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetUnitNum({x, y}));
}
static int GetBelong(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetBelong({x, y}));
}

static int Update(lua_State *luaState) {
    MAP::Singleton().Update();
    return APIreturn(luaState);
}
static int BigUpdate(lua_State *luaState) {
    MAP::Singleton().BigUpdate();
    return APIreturn(luaState);
}

static int Move(lua_State *luaState) {
    int id, srcX, srcY, dstX, dstY;
    APIparam(luaState, id, srcX, srcY, dstX, dstY);
    return APIreturn(luaState,
                     MAP::Singleton().MoveNode(id, {srcX, srcY}, {dstX, dstY}));
}
static int MoveUpdate(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().MoveUpdate());
}

LUA_REG_FUNC(GameMap, C_API(RandomGenMap), C_API(LoadMap), C_API(WriteMap),
             C_API(GetSize), C_API(GetVision), C_API(GetNodeType),
             C_API(GetUnitNum), C_API(GetBelong), C_API(Update),
             C_API(BigUpdate), C_API(Move), C_API(MoveUpdate))
