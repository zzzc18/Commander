import os


def main():
    sizeX, sizeY = 24, 24
    if not os.path.exists("./map"):
        os.mkdir("./map")
    with open("./map/blankMap.map", "w") as map:
        map.write("army : 0\n")
        map.write("size : "+str(sizeX)+" "+str(sizeY)+"\n")
        for i in range(24):
            for j in range(24):
                map.write(str(i)+" "+str(j)+" : { NODE_TYPE_BLANK 0 0 }\n")


if __name__ == "__main__":
    main()
