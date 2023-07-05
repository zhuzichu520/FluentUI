cmake_minimum_required(VERSION 3.20)

project(fluentuiplugin LANGUAGES CXX)

#配置通用编译
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(APPLE AND QT_VERSION VERSION_GREATER_EQUAL "6.0")
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif()

#设置QML插件输出目录->D:\Qt\6.4.3\msvc2019_64\qml\FluentUI
set(QML_PLUGIN_DIRECTORY ${CMAKE_PREFIX_PATH}/qml/FluentUI)

#设置版本号
add_definitions(-DVERSION=1,3,7,3)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Qml)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Qml)

if(QT_VERSION VERSION_GREATER_EQUAL "6.3")
    qt_standard_project_setup()
else()
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
endif()

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    if (NOT (${filepath} MATCHES "fluentuiplugin") AND QT_VERSION VERSION_GREATER_EQUAL "6.2")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND sources_files ${filename})
    elseif(QT_VERSION VERSION_LESS "6.0")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND sources_files ${filename})
    endif()
endforeach(filepath)

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS *.qml)
foreach(filepath ${QML_PATHS})
    if (NOT (${filepath} MATCHES "/FluentUI-Qt5/") AND QT_VERSION VERSION_GREATER_EQUAL "6.2")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND qml_files ${filename})
    elseif(NOT (${filepath} MATCHES "/FluentUI-Qt6/") AND QT_VERSION VERSION_LESS "6.0")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND qml_files ${filename})
    endif()
endforeach(filepath)

#遍历所有资源文件
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp)
foreach(filepath ${RES_PATHS})
    if (NOT (${filepath} MATCHES "FluentUI-Qt5/") AND QT_VERSION VERSION_GREATER_EQUAL "6.2")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND resource_files ${filename})
    elseif(NOT (${filepath} MATCHES "FluentUI-Qt6/") AND QT_VERSION VERSION_LESS "6.0")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND resource_files ${filename})
    endif()
endforeach(filepath)

#修改资源文件导出路径
if (QT_VERSION VERSION_GREATER_EQUAL "6.2")
    foreach(filepath IN LISTS qml_files resource_files)
        string(REPLACE "imports/FluentUI-Qt6/" "" filename ${filepath})
        set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
    endforeach()
endif()

#添加qml模块
if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    qt_add_library(fluentuiplugin SHARED)
    qt_add_qml_module(fluentuiplugin
        #没有下面这行代码就会生成fluentuiplugin.dll与fluentuipluginplugin.dll两个动态库
        PLUGIN_TARGET fluentuiplugin
        OUTPUT_DIRECTORY ${QML_PLUGIN_DIRECTORY}
        VERSION 1.0
        URI "FluentUI"
        #修改qmltypes文件名称。默认fluentuiplugin.qmltypes，使用默认名称有时候import FluentUI会爆红，所以修改成plugins.qmltypes
        TYPEINFO "plugins.qmltypes"
        SOURCES ${sources_files} fluentui.rc
        QML_FILES ${qml_files}
        RESOURCES ${resource_files}
    )
else()
    include(../cmake/QmlPlugin.cmake)
    add_qmlplugin(fluentuiplugin
        URI "FluentUI"
        VERSION 1.0
        SOURCES ${sources_files} fluentui.rc fluentui.qrc
        QMLFILES ${qml_files}
        QMLDIR imports/FluentUI-Qt5
        BINARY_DIR ${QML_PLUGIN_DIRECTORY}
    )
endif()

#链接库
target_link_libraries(fluentuiplugin PUBLIC
    Qt::CorePrivate
    Qt::QuickPrivate
    Qt::QmlPrivate
)

#安装
install(DIRECTORY ${QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
