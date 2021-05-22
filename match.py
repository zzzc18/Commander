from AutoMatch.MultiTest import MultiTest
import AutoMatch.autoEvaluation
import os
import sys


def PrintHelp():
    print("python match.py OPTIONS")
    print("OPTIONS:")
    print("    -h/--help: 查看帮助信息")
    print("    -m/--multi process: 多进程评测，同时进行process个")
    print("    -c/--cross: 跨文件夹评测")
    print("例如 4进程评测 python match.py -m 4")


if __name__ == "__main__":
    os.system("chcp 65001")  # 切换中文编码
    if len(sys.argv) < 2:
        PrintHelp()
    elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
        PrintHelp()
    elif sys.argv[1] == "--multi" or sys.argv[1] == "-m":
        MultiTest(_processes=int(sys.argv[2]))
    elif sys.argv[1] == "--cross" or sys.argv[1] == "-c":
        AutoMatch.autoEvaluation.main()
