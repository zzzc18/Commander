cmake_minimum_required(VERSION 3.0)
project(cpp_for_lua)

# target path
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/../libraries)
# source path
aux_source_directory(operators OPERATORS)
# generate target as dll
add_library(operators SHARED ${OPERATORS})
# link OpenSSL lib
find_package(OpenSSL REQUIRED)
include_directories(include ${OPENSSL_INCLUDE_DIR})
target_link_libraries(operators ${OPENSSL_LIBRARIES})
# link a Lua lib
find_package(Lua51 REQUIRED)
include_directories(include ${LUA51_INCLUDE_DIR})
target_link_libraries(operators ${LUA_LIBRARIES})
# change name: eg. libmat.so -> mat.so
set_target_properties(operators PROPERTIES PREFIX "")