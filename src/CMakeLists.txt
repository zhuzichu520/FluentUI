cmake_minimum_required(VERSION 3.20)

if (FLUENTUI_BUILD_STATIC_LIB)
    project(fluentui LANGUAGES CXX)
else()
    project(fluentuiplugin LANGUAGES CXX)
endif()
#配置通用编译
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif()

#设置QML插件输出目录->D:\Qt\6.4.3\msvc2019_64\qml\FluentUI
set(QML_PLUGIN_DIRECTORY ${CMAKE_PREFIX_PATH}/qml/FluentUI)

#设置版本号
add_definitions(-DVERSION=1,3,7,4)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

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

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS *.qml)
foreach(filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND qml_files ${filename})
endforeach(filepath)

#遍历所有资源文件
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp qmldir)
foreach(filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND resource_files ${filename})
endforeach(filepath)

#修改资源文件导出路径
foreach(filepath IN LISTS qml_files resource_files)
    string(REPLACE "imports/FluentUI/" "" filename ${filepath})
    set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
endforeach()

#添加qml模块
if (FLUENTUI_BUILD_STATIC_LIB)
    set(LIB_TYPE "STATIC")
else()
    set(LIB_TYPE "SHARED")
endif()
qt_add_library(${PROJECT_NAME} ${LIB_TYPE})
if (FLUENTUI_BUILD_STATIC_LIB)
    qt_add_qml_module(${PROJECT_NAME}
        #在静态库编译中使用PLUGIN_TARGET会导致链接失败
        OUTPUT_DIRECTORY ${QML_PLUGIN_DIRECTORY}
        VERSION 1.0
        URI "FluentUI"
        TYPEINFO "plugins.qmltypes"
        SOURCES ${sources_files} fluentui.rc
        QML_FILES ${qml_files}
        RESOURCES ${resource_files}
    )
else()
    qt_add_qml_module(${PROJECT_NAME}
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
endif()

#链接库
target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt::CorePrivate
    Qt::QuickPrivate
    Qt::QmlPrivate
)

#安装
install(DIRECTORY ${QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
