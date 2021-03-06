/**
 * @file GameMap.hpp
 *
 * @brief @c GameMap 模块非 API 部分的声明
 */

#pragma once

#ifndef GameMap_hpp
#define GameMap_hpp

#include <iostream>
#include <optional>
#include <queue>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "Constant.hpp"
#include "LuaAPI.hpp"

using namespace GameMap;  //导入 Constant.hpp 中的常量

/**
 * @brief 描述地图中点的坐标，用大括号可以将int转换为VECTOR
 */
struct VECTOR {
    int x, y;  //行号、列号

    //可以视作向量，支持反向、加减、数乘、判断相等
    VECTOR operator-() const;
    VECTOR& operator+=(VECTOR other);
    friend VECTOR operator+(VECTOR lhs, VECTOR rhs);
    VECTOR& operator-=(VECTOR other);
    friend VECTOR operator-(VECTOR lhs, VECTOR rhs);
    VECTOR& operator*=(int c);
    friend VECTOR operator*(VECTOR v, int c);
    friend VECTOR operator*(int c, VECTOR v);
    friend bool operator==(VECTOR lhs, VECTOR rhs);
    friend bool operator!=(VECTOR lhs, VECTOR rhs);
};  // struct VECTOR

/**
 * @brief 六边形相邻格数组，偶数行是 @c DIR[0][] 奇数行是 @c DIR[1][]
 *  从右上开始为 0，顺时针递增编号
 */
inline constexpr VECTOR DIR[2][6] = {
    {{-1, 0}, {0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}},
    {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {0, -1}, {-1, 0}}};

///////////////////////////////////////////////////////////////////////////////

/**
 * @brief 描述点的类型
 */
enum class NODE_TYPE { BLANK, HILL, FORT, KING, OBSTACLE, MARSH };

/**
 * @brief 地图
 *
 * @note 这是一个单例类，因为每个军队只需要一个地图
 */
class MAP final {
   public:
    MAP(const MAP&) = delete;
    MAP& operator=(const MAP&) = delete;
    //获得单例实例
    static MAP& Singleton();

    friend std::istream& operator>>(std::istream& is, MAP& map);
    friend std::ostream& operator<<(std::ostream& os, const MAP& map);

    //地图每 TroopsUpdateStep 步的兵力更新
    void TroopsUpdate();
    //地图每 BigUpdateStep 步的兵力大更新
    void BigUpdate();
    //地图每 MoveUpdateStep 步的移动兵力操作更新
    bool MoveUpdate();
    //地图的步长更新
    void Update();
    //地图步数
    int step = 0;
    //从上一步到现在的秒数
    double timeFromLastStep = 0;
    //判断胜负
    int Judge(int);
    //玩家被击败后改变军队归属
    int Surrender(int, int);

    /**
     * @brief 将指令加入 moveCommands
     *
     * @param armyID 军队编号
     * @param src 起始格
     * @param dst 目标格
     * @return true
     */
    //添加军队 armyID 从 src 的兵移动到相邻点 dst的指令
    bool PushMove(int armyID, VECTOR src, VECTOR dst, double num);

    /**
     * @brief 编辑器：令fort的兵数加一或减一，禁止用户调用！！！
     *
     * @param aim 目标fort
     * @param mode 1为加，2为减
     * @return true
     */
    bool IncreaseOrDecrease(VECTOR aim, int mode);
    //编辑器：改变格点类型， 禁止用户调用！！！
    bool ChangeType(VECTOR aim, int type);
    //编辑器：改变格点归属，禁止用户调用！！！
    bool ChangeBelong(VECTOR aim);

    //回放器：从回放文件读取当前步添加到命令队列的命令
    void ReadMove(int ReplayStep);
    //回放器：加载回放文件
    int LoadReplayFile(std::string_view file, int loadstep = 0);
    //回放器：回放结束
    bool ReplayOver = false;
    //回放器：回放文件目录
    std::string ReplayFile;

    //以 level 为参数随机生成有armyCnt个军队的地图
    void RandomGen(int armyCnt, int sizeX = 24, int sizeY = 24,
                   std::string mapName = "map", int level = 0);

    //初始化存档文件夹，默认以游戏开始时间命名
    void InitSavedata(std::string name = "", std::string dict = "Savedata");
    //游戏存档保存路径
    std::string SaveDict;
    //从dict目录下读取地图name
    int LoadMap(std::string dict = "Data", std::string name = "default.map");
    //将地图保存至SaveDict文件夹(未设置则为开始时间)，以步数命名
    void SaveMap();
    //向SaveDict文件夹中的steps.txt保存当前步数的操作
    void SaveStep(int armyID, VECTOR src, VECTOR dst, double num);
    //向steps.txt保存游戏结束声明
    void SaveGameOver(int armyID);
    //保存生成的地图
    void SaveEdit(std::string_view dict = "../Output/");

    //获取地图大小 (行数，列数)
    std::pair<int, int> GetSize() const;

    //判断 pos 是否在地图内
    bool InMap(VECTOR pos) const;
    //判断当前军队是否可看见 pos
    bool IsViewable(VECTOR pos) const;
    //当前军队看到 pos 的类型
    NODE_TYPE GetType(VECTOR pos) const;
    //当前军队看到 pos 的兵数
    int GetUnitNum(VECTOR pos) const;
    //当前军队看到 pos 的所属军队
    int GetBelong(VECTOR pos) const;
    //当前军队看到pos的计划路径
    std::pair<VECTOR, VECTOR> GetArmyPath(int armyID, int step) const;
    //当前对局的文件夹
    const char* GetFolder();

    //当前军队的王的位置
    std::pair<int, int> GetKingPos(int armyID) const;

    //获取当前军队从KING到当前位置的路径
    const std::vector<std::pair<VECTOR, VECTOR>>& GetMoveCommands();

   private:
    MAP() = default;
    ~MAP() = default;

    int _sizeX = 0, _sizeY = 0;  //地图行数、列数
    int _armyCnt = 0;            //地图军队数
    int kingNum = 0;             //王的数量
    //暂存的移动操作，(src,dst)
    std::vector<std::pair<VECTOR, VECTOR>> moveCommands[MAX_ARMY_CNT + 1];
    std::vector<double> moveNumCmd[MAX_ARMY_CNT + 1];
    struct KINGSTATE {
        VECTOR kingPos[MAX_ARMY_CNT + 1];  //每个王所在的位置
        int kingBelong[MAX_ARMY_CNT + 1];  //该位置的王的归属
    } kingState;
    //描述地图中的点
    struct NODE {
        NODE_TYPE type = NODE_TYPE::BLANK;  //点的类型
        int unitNum = 0;                    //兵数
        int belong = SERVER;                //所属军队
        //国王处兵力增长
        void Update();
        //空白格兵力增长，沼泽兵力减少
        void BigUpdate();
    } _mat[MAX_GRAPH_SIZE][MAX_GRAPH_SIZE];

    friend std::istream& operator>>(std::istream& is, NODE& node);
    friend std::ostream& operator<<(std::ostream& os, NODE node);
};  // class MAP

//字符串转点类型
NODE_TYPE StrToNodeType(std::string_view str);
//点类型转字符串
std::string NodeTypeToStr(NODE_TYPE type);
//以 level 为参数随机生成一个点类型
NODE_TYPE RandomNodeType(int level);

#endif  // GameMap_hpp
