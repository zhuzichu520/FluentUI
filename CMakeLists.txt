cmake_minimum_required(VERSION 3.20)

project(FluentUI VERSION 1.0)

if(MSVC)
    #让Release也生成pdb文件
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
endif()

set(FLUENTUI_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
list(APPEND CMAKE_MODULE_PATH ${FLUENTUI_DIRECTORY}/.cmake/)

include(GetGitRevisionDescription)

option(FLUENTUI_BUILD_EXAMPLES "Build FluentUI demo applications." ON)
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

#Release也支持日志打印代码位置
target_compile_definitions(fluentuiplugin
    PRIVATE
    QT_MESSAGELOGCONTEXT
)

if (FLUENTUI_BUILD_EXAMPLES)
    add_subdirectory(example)
endif ()

message("------------------------ FluentUI ------------------------")
message("Build FluentUI demo applications.: ${FLUENTUI_BUILD_EXAMPLES}")
message("Build static library.: ${FLUENTUI_BUILD_STATIC_LIB}")
message("Path to FluentUI plugin.: ${FLUENTUI_QML_PLUGIN_DIRECTORY}")
