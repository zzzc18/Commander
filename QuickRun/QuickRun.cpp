#include <unistd.h>
#include <windows.h>

#include <iostream>
#include <string>
using namespace std;

int ClientNum = 3;
string CommandName = "love";
string HelpInfo =
    "该程序用于以指定方式和数量自动启动相应数目服务端和客户端\n"
    "QuickRun.exe [-n/--number ClientNumber] [-c/--command CommandName]\n"
    "参数说明:\n"
    "    -h/--help: 显示本段帮助文字\n"
    "    -n/--number: 启动的客户端数目，默认为3\n"
    "    -c/--command: love启动方式，可选love或lovec，默认为love\n"
    "例如以带终端方式启动8个客户端(需将/Data/default.map替换为8人地图):\n"
    "    QuickRun.exe -n 8 -c lovec  [CMD窗口]\n"
    "    .\\QuickRun.exe -n 8 -c lovec  [PowerShell窗口]\n";
string ErrorMissingArgs = "缺少参数\n";
string HelpOfHelp = "请输入 -h 或 --help 参数查看帮助\n";
string ErrorArgs = "参数错误\n";

void StartGame() {
    string command = string("start ") + CommandName + " .";
    string rootDir(getcwd(NULL, NULL));
    cout << rootDir;
    string serverDir = rootDir + "/Server";
    string clientDir = rootDir + "/Client";
    chdir(serverDir.c_str());
    system(command.c_str());

    chdir(clientDir.c_str());
    for (int i = 0; i < ClientNum; i++) {
        system(command.c_str());
    }
}

int main(int argc, char** argv) {
    system("chcp 65001");
    if (argc == 1) {
        cout << HelpOfHelp;
    }
    for (int idx = 1; idx < argc; idx += 2) {
        string commandType(argv[idx]);
        string commandInfo("");
        if (idx + 1 < argc) {
            commandInfo = string(argv[idx + 1]);
        }
        if (commandType == "-h" || commandType == "--help") {
            cout << HelpInfo;
            system("pause");
            return 0;
        } else if (commandType == "-n" || commandType == "--number") {
            if (commandInfo == "") {
                cout << ErrorMissingArgs;
                cout << HelpOfHelp;
                system("pause");
                return 0;
            }
            ClientNum = stoi(commandInfo);
        } else if (commandType == "-c" || commandType == "--command") {
            if (commandInfo == "") {
                cout << ErrorMissingArgs;
                cout << HelpOfHelp;
                system("pause");
                return 0;
            }
            if (commandInfo != "love" && commandInfo != "lovec") {
                cout << ErrorArgs;
                cout << HelpOfHelp;
                system("pause");
                return 0;
            }
            CommandName = commandInfo;
        }
    }
    StartGame();
    return 0;
}