@echo off
mkdir Build
cd Build
cmake -G "MinGW Makefiles" ..
mingw32-make -j7