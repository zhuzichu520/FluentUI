cmake_minimum_required(VERSION 3.20)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
project(fluentuiplugin LANGUAGES CXX)

#设置QML插件输出目录->D:\Qt\6.4.3\msvc2019_64\qml\FluentUI
set(QML_PLUGIN_DIRECTORY ${CMAKE_PREFIX_PATH}/qml/FluentUI)

#设置版本号
add_definitions(-DVERSION=1,3,7,3)

find_package(Qt5 REQUIRED COMPONENTS Core Quick Qml)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS *.qml)
foreach(filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND qml_files ${filename})
endforeach(filepath)

#遍历所有资源文件
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp)
foreach(filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND resource_files ${filename})
endforeach(filepath)

#添加qml模块
include(cmake/QmlPlugin.cmake)
add_qmlplugin(fluentuiplugin
    URI "FluentUI"
    VERSION 1.0
    SOURCES ${sources_files} fluentui.rc fluentui.qrc
    QMLFILES ${qml_files}
    QMLDIR imports/FluentUI
    BINARY_DIR ${QML_PLUGIN_DIRECTORY}
)

#链接库
target_link_libraries(fluentuiplugin PUBLIC
    Qt::CorePrivate
    Qt::QuickPrivate
    Qt::QmlPrivate
)

#安装
install(DIRECTORY ${QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
