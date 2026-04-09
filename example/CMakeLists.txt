cmake_minimum_required(VERSION 3.20)

project(example VERSION 1.0)

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#判断FluentUI库类型
if (FLUENTUI_BUILD_STATIC_LIB)
    add_definitions(-DFLUENTUI_BUILD_STATIC_LIB)
endif ()

#设置可执行文件输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

if (APPLE)
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}.app/Contents/MacOS)
else ()
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif ()

#导入Qt相关依赖包
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Svg Network Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Svg Network Widgets)

# 查找Qt Linguist工具
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/FindQtLinguistTools.cmake)

# 获取 translations 目录下的所有 .ts 文件
file(GLOB_RECURSE TS_FILES "${CMAKE_CURRENT_LIST_DIR}/translations/*.ts")

# 构建命令列表
set(UPDATE_TRANSLATION_COMMANDS)
set(LRELEASE_COMMANDS)
set(QM_FILES)

foreach(TSFIL ${TS_FILES})
    get_filename_component(FIL_WE ${TSFIL} NAME_WE)
    set(QMFIL ${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.qm)

    # 添加 lupdate 命令
    list(APPEND UPDATE_TRANSLATION_COMMANDS COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${TSFIL} WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

    # 添加 lrelease 命令
    list(APPEND LRELEASE_COMMANDS COMMAND ${QT_LRELEASE} ${TSFIL} -qm ${QMFIL})

    # 记录生成的 qm 文件
    list(APPEND QM_FILES ${QMFIL})
endforeach()

# 构建复制命令
set(COPY_COMMANDS COMMAND ${CMAKE_COMMAND} -E make_directory ${APPLICATION_DIR_PATH}/i18n)

if(QM_FILES)
    list(APPEND COPY_COMMANDS COMMAND ${CMAKE_COMMAND} -E copy)
    foreach(QMFIL ${QM_FILES})
        list(APPEND COPY_COMMANDS ${QMFIL})
    endforeach()
    list(APPEND COPY_COMMANDS ${APPLICATION_DIR_PATH}/i18n)
endif()

add_custom_target(Script-UpdateTranslations
    ${UPDATE_TRANSLATION_COMMANDS}
    ${LRELEASE_COMMANDS}
    ${COPY_COMMANDS}
    DEPENDS ${TS_FILES}
)

##生成版本信息头文件
set(HEADER_FILE_VERSION_PATH ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}/Version.h)
configure_file(
        ${CMAKE_SOURCE_DIR}/.cmake/Version.h.in
        ${HEADER_FILE_VERSION_PATH}
)

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach (filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach (filepath)

if (WIN32)
    list(APPEND sources_files "src/app_dmp.h")
endif ()

#如果是Windows平台，则生成rc文件，还有inno setup脚本文件
set(EXAMPLE_VERSION_RC_PATH "")
if (WIN32)
    set(EXAMPLE_VERSION_RC_PATH ${CMAKE_CURRENT_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
            ${CMAKE_SOURCE_DIR}/.cmake/version_exe.rc.in
            ${EXAMPLE_VERSION_RC_PATH}
    )
    configure_file(
            ${CMAKE_SOURCE_DIR}/.cmake/InstallerScript.iss.in
            ${CMAKE_SOURCE_DIR}/package/InstallerScript.iss
    )
endif ()

list(APPEND sources_files ${PROJECT_NAME}.qrc)

#添加可执行文件
if (WIN32)
    list(APPEND sources_files ${EXAMPLE_VERSION_RC_PATH})
endif ()
if (${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
            MANUAL_FINALIZATION
            ${sources_files}
    )
else ()
    add_executable(${PROJECT_NAME}
            ${sources_files}
    )
endif ()
add_dependencies(${PROJECT_NAME} Script-UpdateTranslations)

#复制程序运行所需要的动态库
if (WIN32)
    if (MSVC)
        if (CMAKE_SIZEOF_VOID_P EQUAL 4)
            file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x86/*.dll)
        elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
            file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x64/*.dll)
        endif ()
    elseif (MINGW)
        file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mingw/*.dll)
    endif ()
    file(COPY ${3RDPARTY_DLL_DIR} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif ()

#复制FluentUI源码到运行目录下，用于脚手架生成
file(MAKE_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/source/)
file(COPY ${CMAKE_SOURCE_DIR}/src/ DESTINATION ${APPLICATION_DIR_PATH}/source/)

#导入component头文件,不然通过QML_NAMED_ELEMENT生成的c++类会找不到头文件报错
target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/component
)

#如果是静态库则需要手动注册插件，导入FluentUI.h头文件
if (FLUENTUI_BUILD_STATIC_LIB)
    target_include_directories(${PROJECT_NAME} PRIVATE
            ${CMAKE_SOURCE_DIR}/src
    )
endif ()

#设置属性
set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER my.${PROJECT_NAME}.com
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

#Release也支持日志打印代码位置
target_compile_definitions(${PROJECT_NAME}
        PRIVATE
        QT_MESSAGELOGCONTEXT
)

#目标文件链接库
target_link_libraries(${PROJECT_NAME} PRIVATE
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Svg
        Qt${QT_VERSION_MAJOR}::Network
	Qt${QT_VERSION_MAJOR}::Widgets
        fluentuiplugin
)

#添加部署脚本
if (CMAKE_BUILD_TYPE MATCHES "Release")
    if (APPLE)
        find_program(QT_DEPLOY_QT NAMES macdeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/dist
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/dist
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/dist/${PROJECT_NAME}.app -qmldir=${CMAKE_CURRENT_LIST_DIR}
                COMMENT "MacOs Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endif ()
    if (WIN32)
        find_program(QT_DEPLOY_QT NAMES windeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/dist
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/dist
                COMMAND ${QT_DEPLOY_QT} --qmldir=${CMAKE_CURRENT_LIST_DIR} --plugindir ${CMAKE_SOURCE_DIR}/dist/plugins --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/dist/${PROJECT_NAME}.exe
                COMMENT "Windows Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endif ()
endif ()
