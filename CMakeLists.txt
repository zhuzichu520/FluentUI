cmake_minimum_required(VERSION 3.20)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(FluentUI VERSION 0.1 LANGUAGES CXX)

option(FLUENTUI_BUILD_EXAMPLES "Build FluentUI demo applications." ON)
option(FLUENTUI_BUILD_FRAMELESSHEPLER "Build FramelessHelper." ON)
option(FLUENTUI_BUILD_STATIC_LIB "Build static library." OFF)

#设置QML插件输出目录，可以通过外部设置，如果外部没有设置就默认到<QT_SDK_DIR_PATH>\qml\FluentUI目录下
set(FLUENTUI_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to FluentUI plugin")
if(NOT FLUENTUI_QML_PLUGIN_DIRECTORY)
    set(FLUENTUI_QML_PLUGIN_DIRECTORY ${CMAKE_PREFIX_PATH}/qml/FluentUI)
endif()

add_subdirectory(src)

if (FLUENTUI_BUILD_EXAMPLES)
    add_subdirectory(example)
endif ()

if (FLUENTUI_BUILD_FRAMELESSHEPLER)
    set(FRAMELESSHELPER_BUILD_STATIC ON)
    set(FRAMELESSHELPER_NO_SUMMARY OFF)
    set(FRAMELESSHELPER_NO_DEBUG_OUTPUT OFF)
    set(FRAMELESSHELPER_BUILD_WIDGETS OFF)
    add_subdirectory(framelesshelper)
endif ()

message("------------------------ FluentUI ------------------------")
message("Build FluentUI demo applications.: ${FLUENTUI_BUILD_EXAMPLES}")
message("Build FramelessHelper.: ${FLUENTUI_BUILD_FRAMELESSHEPLER}")
message("Build static library.: ${FLUENTUI_BUILD_STATIC_LIB}")
message("Path to FluentUI plugin.: ${FLUENTUI_QML_PLUGIN_DIRECTORY}")
