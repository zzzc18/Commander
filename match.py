from AutoMatch.MultiTest import MultiTest
import AutoMatch.autoEvaluation
import os
import sys
import platform
from multiprocessing import Pool


def PrintHelp():
    print("python match.py OPTIONS")
    print("OPTIONS:")
    print("    -h/--help: 查看帮助信息")
    print("    -m/--multi process: 多进程评测，同时进行process个")
    print("    -c/--cross: 跨文件夹评测")
    print("    -g/--gen: 拷贝生成多文件夹评测目录(Linux Shell)")
    print("例如 4进程评测 python match.py -m 4")


def _GenFolder(index):
    print("rm -rf Commander_"+str(index))
    os.system("rm -rf Commander_"+str(index))
    print("cp -r Dev Commander_"+str(index))
    os.system("cp -r Dev Commander_"+str(index))


def GenFolder(teamNum=8):
    os.system("cp -r ../Dev ../Commander/")
    os.chdir("../Commander")
    os.system("rm -rf ./Dev/.git")

    indexes = []
    for i in range(teamNum+1):
        indexes.append(i)
    with Pool(processes=teamNum+1) as pool:
        pool.map(_GenFolder, indexes)
    os.system("rm -rf Dev")


if __name__ == "__main__":
    if platform.system() == "Windows":
        os.system("chcp 65001")  # 切换中文编码
    if len(sys.argv) < 2:
        PrintHelp()
    elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
        PrintHelp()
    elif sys.argv[1] == "--multi" or sys.argv[1] == "-m":
        MultiTest(_processes=int(sys.argv[2]))
    elif sys.argv[1] == "--cross" or sys.argv[1] == "-c":
        AutoMatch.autoEvaluation.main()
    elif sys.argv[1] == "--gen" or sys.argv[1] == "-g":
        GenFolder(teamNum=8)
