# 地图编辑器说明

在MapEditor文件夹下是地图编辑器的源码。运行./MapEditor.bat启动地图编辑器。

## 大体结构

MapEditor的主要逻辑部分与Client相同（删去通信部分）。

运行后，main.lua获取鼠标和键盘事件，通过调用c++接口方法修改地图，实现地图编缉。

## 说明

所有保存的地图文件的命名格式为：年-月-日_时.分.秒.map

## 使用方法

### 开始编辑

进入地图编辑器后，默认打开./Data/Default.map地图。

在Windows资源管理器中选中并拖动.map地图文件到游戏窗口，可自动打开并编辑它，注意文件的全路径中不能含有中文。原来编辑的那个地图会被自动保存。

选中要修改的格点：

### 增减兵数

鼠标左键兵数加1，右键减1。

按住**ctrl**后，鼠标左键兵数加10，右键减10。

选中一个格点后，鼠标滚轮也可增减兵数。

注意对hill无效。

### 改变类型

按'**b**','**h**','**f**','**k**','**m**','**o**'键改变格点类型，六者分别对应：

'b':blank     <img src="Photo/MapEditor/NODE_TYPE_BLANK.png" alt="NODE_TYPE_BLANK" style="zoom:50%;" />

'h':hill        <img src="Photo/MapEditor/NODE_TYPE_HILL.png" alt="NODE_TYPE_HILL" style="zoom:50%;" />

'f':fort         <img src="Photo/MapEditor/NODE_TYPE_FORT.png" alt="NODE_TYPE_FORT" style="zoom:50%;" />

'k':king       <img src="Photo/MapEditor/NODE_TYPE_KING.png" alt="NODE_TYPE_KING" style="zoom:50%;" />

'm':marsh   <img src="Photo/MapEditor/NODE_TYPE_MARSH.png" alt="NODE_TYPE_MARSH" style="zoom:50%;" />

'o':obstacle <img src="Photo/MapEditor/NODE_TYPE_OBSTACLE.png" alt="NODE_TYPE_OBSTACLE" style="zoom:50%;" />

其中obstacle在本次比赛中不会出现。

由其它类型变为hill会将兵数置0，变为fort、obstacle或marsh会将兵数置1。

### 改变归属

按空格键**space**改变格点归属，共有9个归属类型：8个玩家对应8种颜色；还有1个SERVER表示不属于任何一个玩家，显示为无色。

注意第8种颜色为蓝色(0,0,255)，可能会使king和blank的图标不易分辨。

为防止出现无归属的king，若将king所在格点变为属于SERVER，则会将king变成blank并将兵数置0。

### 修改地图大小

**alt+w/s/a/d**分别在地图上下左右增加一排格点。

**shift+w/s/a/d**分别在地图上下左右减少一排格点。

注意在上方增减奇数排格点，可能会使整个地图各格点的相对位置错位。

### 保存

按**ctrl+s**键保存已修改的地图，保存路径为./Output。