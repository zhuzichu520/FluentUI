cmake_minimum_required(VERSION 3.20)

if (FLUENTUI_BUILD_STATIC_LIB AND (QT_VERSION VERSION_GREATER_EQUAL "6.2"))
    project(fluentui LANGUAGES CXX)
else()
    project(fluentuiplugin LANGUAGES CXX)
endif()

#配置通用编译
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif()

if (FLUENTUI_BUILD_STATIC_LIB)
    add_definitions(-DFLUENTUI_BUILD_STATIC_LIB)
endif()

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
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #删除fluentuiplugin.cpp与fluentuiplugin.h，这些只要Qt5使用，Qt6不需要
    list(REMOVE_ITEM sources_files fluentuiplugin.h fluentuiplugin.cpp)

    #遍历所有qml文件
    file(GLOB_RECURSE QML_PATHS *.qml)
    foreach(filepath ${QML_PATHS})
        if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND qml_files ${filename})
        endif()
    endforeach(filepath)

    #遍历所有资源文件
    file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js)
    foreach(filepath ${RES_PATHS})
        if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND resource_files ${filename})
        endif()
    endforeach(filepath)

    #修改资源文件导出路径
    foreach(filepath IN LISTS qml_files resource_files)
        string(REPLACE "Qt${QT_VERSION_MAJOR}/imports/FluentUI/" "" filename ${filepath})
        set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
    endforeach()
endif()

#添加qml模块
if (FLUENTUI_BUILD_STATIC_LIB)
    set(LIB_TYPE "STATIC")
else()
    set(LIB_TYPE "SHARED")
    list(REMOVE_ITEM sources_files FluentUI.h FluentUI.cpp)
endif()

if (FLUENTUI_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else()
    #如果是动态库，则使用插件目标作为其自己的支持目标来定义 QML 模块，在这种情况下，模块必须在运行时动态加载，并且不能由其他目标直接链接到
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif()

#如果是Windows平台，则生成rc文件
set(FLUENTUI_VERSION_RC_PATH "")
if(WIN32)
    set(FLUENTUI_VERSION_RC_PATH ${CMAKE_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
        ${FLUENTUI_DIRECTORY}/.cmake/version_dll.rc.in
        ${FLUENTUI_VERSION_RC_PATH}
    )
endif()

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    if(FLUENTUI_BUILD_STATIC_LIB)
        set(FLUENTUI_QML_PLUGIN_DIRECTORY ${CMAKE_BINARY_DIR}/FluentUI)
    endif()
    qt_add_library(${PROJECT_NAME} ${LIB_TYPE})
    qt_add_qml_module(${PROJECT_NAME}
        PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
        OUTPUT_DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY}
        VERSION 1.0
        URI "FluentUI"
        #修改qmltypes文件名称。默认fluentuiplugin.qmltypes，使用默认名称有时候import FluentUI 1.0会爆红，所以修改成plugins.qmltypes
        TYPEINFO "plugins.qmltypes"
        SOURCES ${sources_files} ${FLUENTUI_VERSION_RC_PATH}
        QML_FILES ${qml_files}
        RESOURCES ${resource_files}
        RESOURCE_PREFIX "/qt/qml"
    )
else()
    include(QmlPlugin)
    add_qmlplugin(${PROJECT_NAME}
        URI "FluentUI"
        VERSION 1.0
        SOURCES ${sources_files} ${FLUENTUI_VERSION_RC_PATH} Qt5/imports/fluentui.qrc
        QMLFILES ${qml_files}
        QMLDIR imports/FluentUI
        BINARY_DIR ${FLUENTUI_QML_PLUGIN_DIRECTORY}
        LIBTYPE ${LIB_TYPE}
    )
endif()

#去掉mingw生成的动态库libxxx前缀lib，不去掉前缀会导致 module "FluentUI" plugin "fluentuiplugin" not found
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")

#链接库
target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::CorePrivate
    Qt${QT_VERSION_MAJOR}::QuickPrivate
    Qt${QT_VERSION_MAJOR}::QmlPrivate
    ZXing
)

#安装
install(DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
