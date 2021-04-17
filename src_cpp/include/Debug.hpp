#pragma once

#ifndef Debug_hpp
#define Debug_hpp

#include "GameMap.hpp"
#include "ostream"

class Debug final {
   public:
    Debug(const Debug&) = delete;
    Debug& operator=(const Debug&) = delete;
    static Debug& Singleton();

    //判断文件目录是否存在
    bool DirExist(const std::string& dirName_in);
    //初始化日志文件夹，以程序开始运行时间命名
    void InitDebugLog();
    //添加一条类型为priority，内容为text的记录
    void Log(std::string priority, std::string text);

    std::string LogTime;  //日志开始时间
    int LogIndex = 0;     //用于区分同一时间开始运行的程序日志

   private:
    Debug() = default;
    ~Debug() = default;
};

#endif