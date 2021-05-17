/**
 * @file API.cpp
 *
 * @brief @c GameMap 模块对 Lua 提供的 API
 */

#include "GameMap.hpp"
#include "LuaAPI.hpp"

/**
 * @brief 随机生成地图
 *
 * @param @c void
 * @return @c void
 */
static int RandomGenMap(lua_State *luaState) {
    int armyCnt, sizeX, sizeY;
    std::string mapName;
    APIparam(luaState, armyCnt, sizeX, sizeY, mapName);
    MAP::Singleton().RandomGen(armyCnt, sizeX, sizeY, mapName,
                               0);  // FIXME magic numbers
    return APIreturn(luaState);
}
/**
 * @brief 加载地图
 *
 * @param @c void
 * @return @c void
 */
static int LoadMap(lua_State *luaState) {
    std::string dict, name;
    int armyNum = 0;
    APIparam(luaState, dict, name);
    if (dict == "default")
        armyNum = MAP::Singleton().LoadMap();
    else if (name == "default")
        armyNum = MAP::Singleton().LoadMap(dict);
    else
        armyNum = MAP::Singleton().LoadMap(dict, name);
    return APIreturn(luaState, armyNum);
}
/**
 * @brief 加载回放文件
 *
 * @param @c void
 * @return @c void
 */
static int LoadReplayFile(lua_State *luaState) {
    std::string ReplayFile;
    APIparam(luaState, ReplayFile);
    return APIreturn(luaState, MAP::Singleton().LoadReplayFile(ReplayFile));
}
/**
 * @brief 读取上一个/下一个检查点的回放地图文件
 * 如果变更了设置会导致出错
 *
 * @param int 0上一个，1下一个
 * @return @c void
 */
static int LoadCheckPoint(lua_State *lua_State) {
    int dst;
    APIparam(lua_State, dst);
    if (dst == 0) MAP::Singleton().ReplayOver = false;
    int target =
        ((MAP::Singleton().step - 1) / SaveMapStep + dst) * SaveMapStep;
    return APIreturn(lua_State, MAP::Singleton().LoadReplayFile(
                                    MAP::Singleton().ReplayFile, target));
}
/**
 * @brief 获取回放状态
 *
 * @return @c bool 真为回放已结束
 */
static int GetReplayStatus(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().ReplayOver);
}
/**
 * @brief 初始化存档文件
 */
static int InitSavedata(lua_State *luaState) {
    std::string name, dict;
    APIparam(luaState, name, dict);
    if (name == "default")
        MAP::Singleton().InitSavedata();
    else if (dict == "default")
        MAP::Singleton().InitSavedata(name);
    else
        MAP::Singleton().InitSavedata(name, dict);
    return APIreturn(luaState);
}
/**
 * @brief 向存档文件保存游戏结束声明与获胜者
 *
 * @param @c int 获胜军队编号
 * @return @c void
 */
static int SaveGameOver(lua_State *luaState) {
    int armyID;
    APIparam(luaState, armyID);
    MAP::Singleton().SaveGameOver(armyID);
    return APIreturn(luaState);
}
/**
 * @brief 编辑器：保存生成的地图
 *
 * @param @c void
 * @return @c void
 */
static int SaveEdit(lua_State *luaState) {
    MAP::Singleton().SaveEdit();
    return APIreturn(luaState);
}
/**
 * @brief 保存地图至文件
 *
 * @param @c void
 * @return @c void
 */
static int WriteMap(lua_State *luaState) {
    MAP::Singleton().SaveMap();
    return APIreturn(luaState);
}

/**
 * @brief 获取地图大小
 *
 * @param @c void
 * @return @c int sizeX 行数
 * @return @c int sizeY 列数
 */
static int GetSize(lua_State *luaState) {
    auto [sizeX, sizeY] = MAP::Singleton().GetSize();
    return APIreturn(luaState, sizeX, sizeY);
}

/**
 * @brief 判断当前军队是否能看到给定点
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c bool 是否可见
 */
static int GetVision(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().IsViewable({x, y}));
}
/**
 * @brief 当前军队所看到的给定点类型
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c const-char* 类型对应字符串
 */
static int GetNodeType(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState,
                     NodeTypeToStr(MAP::Singleton().GetType({x, y})).c_str());
}
/**
 * @brief 当前军队所看到的给定点兵数
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c int 军队看到的兵数
 */
static int GetUnitNum(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetUnitNum({x, y}));
}
/**
 * @brief 当前军队所看到的给定点所属军队编号
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c int 军队看到的该点所属军队编号
 */
static int GetBelong(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetBelong({x, y}));
}
/**
 * @brief 某只军队的计划路径
 *
 * @param armyID @c int 军队ID
 * @param step @c int 军队路径步数
 * @return @c int 某一步的开始坐标，结束坐标
 */
static int GetArmyPath(lua_State *luaState) {
    int armyID, step;
    APIparam(luaState, armyID, step);
    std::pair<VECTOR, VECTOR> data = MAP::Singleton().GetArmyPath(armyID, step);
    int srcX = data.first.x;
    int srcY = data.first.y;
    int dstX = data.second.x;
    int dstY = data.second.y;
    return APIreturn(luaState, srcX, srcY, dstX, dstY);
}
/**
 * @brief 当前对局保存的文件夹
 *
 * @return @c const char* 当前对局文件夹的相对路径
 */
static int GetFolder(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().GetFolder());
}
/**
 * @brief 某位玩家的王的位置
 *
 * @param x @c int 王所在行号
 * @param y @c int 王所在列号
 * @return @c int int 王所在行号与列号
 */
static int GetKingPos(lua_State *luaState) {
    int armyID;
    APIparam(luaState, armyID);
    std::pair<int, int> data = MAP::Singleton().GetKingPos(armyID);
    int x = data.first;
    int y = data.second;
    return APIreturn(luaState, x, y);
}
/**
 * @brief 将给定军队给定点的兵移至相邻点
 *
 * @param armyID @c int 操作的军队编号
 * @param srcX @c int 给定点所在行号
 * @param srcY @c int 给定点所在列号
 * @param dstX @c int 目标点所在行号
 * @param dstY @c int 目标点所在列号
 * @param num @c int
 * 移动数量，为0时移动全部军队，介于0与1之间时按百分比移动，大于1时移动相应数量
 * @return @c bool 操作是否合法
 */
static int PushMove(lua_State *luaState) {
    int armyID, srcX, srcY, dstX, dstY;
    double num;
    APIparam(luaState, armyID, srcX, srcY, dstX, dstY, num);
    return APIreturn(luaState, MAP::Singleton().PushMove(armyID, {srcX, srcY},
                                                         {dstX, dstY}, num));
}
/**
 * @brief 将目标点的兵数加一或减一
 *
 * @param aimX @c int 目标点所在行号
 * @param aimY @c int 目标点所在列号
 * @param mode @c int 1为加，2为减
 */
static int IncreaseOrDecrease(lua_State *luaState) {
    int aimX, aimY, mode;
    APIparam(luaState, aimX, aimY, mode);
    return APIreturn(luaState,
                     MAP::Singleton().IncreaseOrDecrease({aimX, aimY}, mode));
    // return APIreturn(luaState, true);
}
/**
 * @brief 改变目标格点的类型
 *
 * @param aimX @c int 目标点所在行号
 * @param aimY @c int 目标点所在列号
 * @param type @c char 要转换成的类型
 */
static int ChangeType(lua_State *luaState) {
    int aimX, aimY;
    int type;
    APIparam(luaState, aimX, aimY, type);
    return APIreturn(luaState, MAP::Singleton().ChangeType({aimX, aimY}, type));
}
/**
 * @brief 改变目标格点的归属
 *
 * @param aimX @c int 目标点所在行号
 * @param aimY @c int 目标点所在列号
 */
static int ChangeBelong(lua_State *luaState) {
    int aimX, aimY;
    APIparam(luaState, aimX, aimY);
    return APIreturn(luaState, MAP::Singleton().ChangeBelong({aimX, aimY}));
}
static int Judge(lua_State *luaState) {
    int armyID;
    APIparam(luaState, armyID);
    return APIreturn(luaState, MAP::Singleton().Judge(armyID));
}
static int Surrender(lua_State *luaState) {
    int armyID, vanquisherID;
    APIparam(luaState, armyID, vanquisherID);
    return APIreturn(luaState,
                     MAP::Singleton().Surrender(armyID, vanquisherID));
}

/**
 * @brief 向 Lua 注册 API，模块名为 lib/GameMap.dll
 */
LUA_REG_FUNC(GameMap, C_API(RandomGenMap), C_API(InitSavedata),
             C_API(SaveGameOver), C_API(LoadMap), C_API(LoadReplayFile),
             C_API(LoadCheckPoint), C_API(GetReplayStatus), C_API(SaveEdit),
             C_API(WriteMap), C_API(GetSize), C_API(GetVision),
             C_API(GetNodeType), C_API(GetUnitNum), C_API(GetBelong),
             C_API(GetArmyPath), C_API(GetFolder), C_API(GetKingPos),
             C_API(PushMove), C_API(Judge), C_API(Surrender),
             C_API(IncreaseOrDecrease), C_API(ChangeType), C_API(ChangeBelong))
