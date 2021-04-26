#include <Python.h>

#include <ctime>
#include <iostream>
#include <random>
#include <string>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verification.hpp"

static PyObject* moudulePtr = NULL;
static PyObject* mainFuncPtr = NULL;

void Init(lua_State* luaState) {
    static bool initialized = false;
    if (initialized) return;
    initialized = true;
    UserAPI& tmp = UserAPI::Singleton(luaState);

    Py_Initialize();  //初始化，创建一个Python虚拟环境
    if (Py_IsInitialized()) {
        PyRun_SimpleString("import sys,os");
        PyRun_SimpleString("sys.path.append(os.getcwd()+'\\AI')");

        moudulePtr = PyImport_ImportModule("Core");  //参数为Python脚本的文件名
        if (moudulePtr) {
            mainFuncPtr = PyObject_GetAttrString(moudulePtr, "Load");
            PyObject_CallObject(mainFuncPtr, NULL);
            Py_XDECREF(mainFuncPtr);
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
    Init(luaState);

    if (PyErr_Occurred()) {
        PyErr_PrintEx(0);
        PyErr_Clear();
    }
    //调用Python的用户主函数
    mainFuncPtr = PyObject_GetAttrString(moudulePtr, "Main");
    PyObject_CallObject(mainFuncPtr, NULL);
    Py_XDECREF(mainFuncPtr);
    return 0;
}

LUA_REG_FUNC(PythonAPI, C_API(userMain))