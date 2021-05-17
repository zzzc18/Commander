from multiprocessing import Pool
from AutoMatch.autoMatch import autoMatch, Match
import time


def MultiTest(_processes=1):
    startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
    with Pool(processes=_processes) as pool:         # start 4 worker processes
        args = []  # [[port,index],...]
        for i in range(100):
            args.append([22122+i, i])

        pool.starmap(Match, args)

    # 统计结果
    am = autoMatch()
    am.countMatchResult()
    endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
    print(startTime, endTime)


if __name__ == '__main__':
    MultiTest(_processes=12)
