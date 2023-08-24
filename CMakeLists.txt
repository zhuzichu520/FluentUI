cmake_minimum_required(VERSION 3.20)

project(FluentUI VERSION 0.1 LANGUAGES CXX)

set(FLUENTUI_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
list(APPEND CMAKE_MODULE_PATH ${FLUENTUI_DIRECTORY}/.cmake/)

include(GetGitRevisionDescription)

option(FLUENTUI_BUILD_EXAMPLES "Build FluentUI demo applications." ON)
option(FLUENTUI_BUILD_FRAMELESSHEPLER "Build FramelessHelper." ON)
option(FLUENTUI_BUILD_STATIC_LIB "Build static library." OFF)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

set(QT_SDK_DIR "${Qt${QT_VERSION_MAJOR}_DIR}")
cmake_path(GET QT_SDK_DIR PARENT_PATH QT_SDK_DIR)
cmake_path(GET QT_SDK_DIR PARENT_PATH QT_SDK_DIR)
cmake_path(GET QT_SDK_DIR PARENT_PATH QT_SDK_DIR)

#设置QML插件输出目录，可以通过外部设置，如果外部没有设置就默认到<QT_SDK_DIR_PATH>\qml\FluentUI目录下
set(FLUENTUI_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to FluentUI plugin")
if(NOT FLUENTUI_QML_PLUGIN_DIRECTORY)
    set(FLUENTUI_QML_PLUGIN_DIRECTORY ${QT_SDK_DIR}/qml/FluentUI)
endif()

add_subdirectory(src)
add_subdirectory(zxing-cpp)

if (FLUENTUI_BUILD_EXAMPLES)
    add_subdirectory(example)
endif ()

if (FLUENTUI_BUILD_FRAMELESSHEPLER)
    set(FRAMELESSHELPER_BUILD_STATIC ON)
    set(FRAMELESSHELPER_NO_DEBUG_OUTPUT ON)
    add_subdirectory(framelesshelper)
endif ()

message("------------------------ FluentUI ------------------------")
message("Build FluentUI demo applications.: ${FLUENTUI_BUILD_EXAMPLES}")
message("Build FramelessHelper.: ${FLUENTUI_BUILD_FRAMELESSHEPLER}")
message("Build static library.: ${FLUENTUI_BUILD_STATIC_LIB}")
message("Path to FluentUI plugin.: ${FLUENTUI_QML_PLUGIN_DIRECTORY}")
