cmake_minimum_required(VERSION 3.20)

if (FLUENTUI_BUILD_STATIC_LIB AND (QT_VERSION VERSION_GREATER_EQUAL "6.2"))
    project(fluentui VERSION 1.0)
else ()
    project(fluentuiplugin VERSION 1.0)
endif ()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/)

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if (QT_VERSION VERSION_GREATER_EQUAL "6.3")
    qt_standard_project_setup()
else ()
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif ()

#设置版本号
add_definitions(-DFLUENTUI_VERSION=1,7,7,0)

if (FLUENTUI_BUILD_STATIC_LIB)
    add_definitions(-DFLUENTUI_BUILD_STATIC_LIB)
endif ()

#编译参数设置
option(FLUENTUI_BUILD_STATIC_LIB "Build static library." OFF)

#导入Qt相关依赖包
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Qml Widgets PrintSupport)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Widgets PrintSupport)

set(QT_SDK_DIR "${Qt${QT_VERSION_MAJOR}_DIR}/../../..")
cmake_path(SET QT_SDK_DIR NORMALIZE ${QT_SDK_DIR})

#设置QML插件输出目录，可以通过外部设置，如果外部没有设置就默认到<QT_SDK_DIR_PATH>\qml\FluentUI目录下
set(FLUENTUI_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to FluentUI plugin")
if (NOT FLUENTUI_QML_PLUGIN_DIRECTORY)
    set(FLUENTUI_QML_PLUGIN_DIRECTORY ${QT_SDK_DIR}/qml/FluentUI)
endif ()

#国际化
find_program(QT_LUPDATE NAMES lupdate)
find_program(QT_LRELEASE NAMES lrelease)
if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/fluentui_en_US.qm)
    execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts fluentui_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    execute_process(COMMAND ${QT_LRELEASE} fluentui_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
endif ()
if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/fluentui_zh_CN.qm)
    execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts fluentui_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    execute_process(COMMAND ${QT_LRELEASE} fluentui_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
endif ()

file(GLOB QM_FILE_PATHS ${CMAKE_CURRENT_LIST_DIR}/ *.qm)
file(COPY ${QM_FILE_PATHS} DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}/imports/FluentUI/i18n")

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h *.cxx)
foreach (filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    message(${filename})
    list(APPEND sources_files ${filename})
endforeach (filepath)

list(REMOVE_ITEM sources_files qhotkey/qhotkey_mac.cpp qhotkey/qhotkey_win.cpp qhotkey/qhotkey_x11.cpp)

if (WIN32)
    list(APPEND sources_files qhotkey/qhotkey_win.cpp)
elseif (APPLE)
    list(APPEND sources_files qhotkey/qhotkey_mac.cpp)
elseif (UNIX)
    list(APPEND sources_files qhotkey/qhotkey_x11.cpp)
endif()

if (WIN32)
    set(FLUENTUI_VERSION_RC_PATH ${CMAKE_CURRENT_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/version_dll.rc.in
            ${FLUENTUI_VERSION_RC_PATH}
    )
endif ()

if (QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #删除fluentuiplugin.cpp与fluentuiplugin.h，这些只要Qt5使用，Qt6不需要
    list(REMOVE_ITEM sources_files fluentuiplugin.h fluentuiplugin.cpp)
    if (NOT FLUENTUI_BUILD_STATIC_LIB)
        list(REMOVE_ITEM sources_files FluentUI.h FluentUI.cpp)
    endif ()

    #遍历所有qml文件
    file(GLOB_RECURSE QML_PATHS *.qml qmldir)
    foreach (filepath ${QML_PATHS})
        if (${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            if (${filename} MATCHES "qmldir")
                list(APPEND resource_files ${filename})
            else ()
                list(APPEND qml_files ${filename})
            endif ()
        endif ()
    endforeach (filepath)

    #遍历所有资源文件
    file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm)
    foreach (filepath ${RES_PATHS})
        if (${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND resource_files ${filename})
        endif ()
    endforeach (filepath)

    #修改资源文件导出路径
    foreach (filepath IN LISTS qml_files resource_files)
        string(REPLACE "Qt${QT_VERSION_MAJOR}/imports/FluentUI/" "" filename ${filepath})
        set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
    endforeach ()
endif ()

if (FLUENTUI_BUILD_STATIC_LIB)
    set(LIB_TYPE "STATIC")
else ()
    set(LIB_TYPE "SHARED")
endif ()

if (FLUENTUI_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else ()
    #如果是动态库，则使用插件目标作为其自己的支持目标来定义 QML 模块，在这种情况下，模块必须在运行时动态加载，并且不能由其他目标直接链接到
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif ()

#如果是Windows平台，则生成rc文件
set(FLUENTUI_VERSION_RC_PATH "")
if (WIN32)
    set(FLUENTUI_VERSION_RC_PATH ${CMAKE_CURRENT_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/version_dll.rc.in
            ${FLUENTUI_VERSION_RC_PATH}
    )
endif ()

if (QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #如果是Qt6.2版本以上，则使用qt_add_library，qt_add_qml_module函数添加资源文件
    if (FLUENTUI_BUILD_STATIC_LIB)
        set(FLUENTUI_QML_PLUGIN_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/FluentUI)
    endif ()
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
else ()
    qt_add_resources(QRC_RESOURCES Qt5/imports/fluentui.qrc)
    #如果是Qt6.2版本以下，则使用add_qmlplugin函数添加资源文件，这是个自定义的函数，详情见.cmake/QmlPlugin.cmake
    include(QmlPlugin)
    add_qmlplugin(${PROJECT_NAME}
            URI "FluentUI"
            VERSION 1.0
            SOURCES ${sources_files} ${FLUENTUI_VERSION_RC_PATH} ${QRC_RESOURCES}
            QMLFILES ${qml_files}
            QMLDIR imports/FluentUI
            BINARY_DIR ${FLUENTUI_QML_PLUGIN_DIRECTORY}
            LIBTYPE ${LIB_TYPE}
    )
endif ()

target_compile_definitions(${PROJECT_NAME}
        PRIVATE
        #导入qrcode配置文件
        HAVE_CONFIG_H
)

#去掉mingw生成的动态库libxxx前缀lib，不去掉前缀会导致 module "FluentUI" plugin "fluentuiplugin" not found
if (MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    #解决编译器报 too many sections的问题
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
endif ()

#MSVC Debug 添加后缀d，与Qt插件风格保持一致
if (MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
endif ()

#链接库
target_link_libraries(${PROJECT_NAME} PUBLIC
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::Widgets
        Qt${QT_VERSION_MAJOR}::PrintSupport
)
if(APPLE)
    find_library(CARBON_LIBRARY Carbon)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${CARBON_LIBRARY})
elseif(WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE user32)
elseif(UNIX)
    if(QT_VERSION_MAJOR STREQUAL "6")
        if(QT_VERSION VERSION_LESS "6.2.0")
            message(FATAL_ERROR "Qt 6.2.0 or greater is required when using Qt6")
        endif()
    else()
        if(QT_VERSION_MAJOR LESS "6")
            find_package(Qt5 REQUIRED COMPONENTS X11Extras)
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::X11Extras)
        endif()
    endif()
    target_link_libraries(${PROJECT_NAME} PRIVATE X11)
endif()

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/qmlcustomplot
)

if ((${QT_VERSION_MAJOR} LESS_EQUAL 6) AND (CMAKE_BUILD_TYPE MATCHES "Release"))
    find_program(QML_PLUGIN_DUMP NAMES qmlplugindump)
    add_custom_target(Script-Generate-QmlTypes
            COMMAND ${QML_PLUGIN_DUMP} -nonrelocatable -noinstantiate FluentUI 1.0 ${CMAKE_CURRENT_BINARY_DIR} > ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/imports/FluentUI/plugins.qmltypes
            COMMENT "Generate qmltypes........."
            SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/imports/FluentUI/plugins.qmltypes
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endif()
    
#安装
install(DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
