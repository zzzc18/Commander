#include <Python.h>

#include <ctime>
#include <iostream>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verification.hpp"

static PyObject* moudulePtr = NULL;
static PyObject* mainFuncPtr = NULL;

void Init() {
    static bool initialized = false;
    if (initialized) return;
    initialized = true;

    Py_Initialize();  //初始化，创建一个Python虚拟环境
    if (Py_IsInitialized()) {
        char* _path = "../Client/AI/";
        wchar_t path[50] = {0};
        mbstowcs(path, _path, strlen(_path));
        PySys_SetPath(path);

        moudulePtr = PyImport_ImportModule("Core");  //参数为Python脚本的文件名
        if (moudulePtr) {
            mainFuncPtr =
                PyObject_GetAttrString(moudulePtr, "Main");  //获取函数
        } else {
            printf("导入Python模块失败...\n");
        }
    } else {
        printf("Python环境初始化失败...\n");
    }
    // Py_Finalize();
}

static int userMain(lua_State* luaState) {
    //初始化
    Init();
    UserAPI& tmp = UserAPI::Singleton(luaState);

    //调用Python的用户主函数
    PyEval_CallObject(mainFuncPtr, NULL);  //执行函数
    return 0;
}

LUA_REG_FUNC(PythonAPI, C_API(userMain))