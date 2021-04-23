tar --exclude .gitignore --exclude QuickClean.bat --exclude QuickRun_2Player.bat --exclude QuickRun_4Player.bat --exclude QuickRun.sh --exclude QuickRunEditor.bat --exclude compressFiles.bat -cvf test.tar *
tar -rf test.tar Client Data lib MapEditor Server spec System TestData
tar -rf test.tar src_cpp/include src_cpp/UserAPI src_cpp/UserImplementation src_cpp/build.bat src_cpp/build.sh src_cpp/clean.bat src_cpp/clean.sh src_cpp/CMakeLists.txt
ren test.tar Commander.tar