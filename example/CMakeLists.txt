cmake_minimum_required(VERSION 3.20)

project(example VERSION 1.0)

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#导入exmaple的QML位置，不然import example有时候会爆红
set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/example CACHE STRING "Qt Creator extra QML import paths" FORCE)

#判断FluentUI库类型
if(FLUENTUI_BUILD_STATIC_LIB)
    add_definitions(-DFLUENTUI_BUILD_STATIC_LIB)
endif()

#设置可执行文件输出目录
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY $<1:${FLUENTUI_DIRECTORY}/bin/debug>)
else()
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY $<1:${FLUENTUI_DIRECTORY}/bin/release>)
endif()

#获取文件路径分隔符（解决执行命令的时候有些平台会报错）
file(TO_CMAKE_PATH "/" PATH_SEPARATOR)

#导入Qt相关依赖包
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Svg Network)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Svg Network)

if(QT_VERSION VERSION_GREATER_EQUAL "6.3")
    qt_standard_project_setup()
else()
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
endif()

##生成版本信息头文件
set(HEADER_FILE_VERSION_PATH ${FLUENTUI_DIRECTORY}/example/Version.h)
configure_file(
    ${FLUENTUI_DIRECTORY}/.cmake/Version.h.in
    ${HEADER_FILE_VERSION_PATH}
)

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #遍历所有qml文件
    file(GLOB_RECURSE QML_PATHS *.qml qmldir)
    foreach(filepath ${QML_PATHS})
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        if(${filepath} MATCHES "qml-Qt6")
            string(REPLACE "qml-Qt6" "qml" filealias ${filename})
            set_source_files_properties(${filename} PROPERTIES QT_RESOURCE_ALIAS ${filealias})
            if(${filename} MATCHES "qmldir")
                list(APPEND resource_files ${filename})
            else()
                list(APPEND qml_files ${filename})
            endif()
        endif()
    endforeach(filepath)

    #遍历所有资源文件
    file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.obj)
    foreach(filepath ${RES_PATHS})
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        message(${filename})
        list(APPEND resource_files ${filename})
    endforeach(filepath)

endif()

#如果是Windows平台，则生成rc文件，还有inno setup脚本文件
set(EXAMPLE_VERSION_RC_PATH "")
if(WIN32)
    set(EXAMPLE_VERSION_RC_PATH ${CMAKE_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
        ${FLUENTUI_DIRECTORY}/.cmake/version_exe.rc.in
        ${EXAMPLE_VERSION_RC_PATH}
    )
configure_file(
    ${FLUENTUI_DIRECTORY}/.cmake/InstallerScript.iss.in
    ${FLUENTUI_DIRECTORY}/action-cli/InstallerScript.iss
)
endif()

#添加可执行文件
if (WIN32)
    add_executable(example
        ${sources_files}
        ${EXAMPLE_VERSION_RC_PATH}
    )
else ()
    add_executable(example
        ${sources_files}
    )
endif ()

#复制程序运行所需要的动态库
if(WIN32)
    if(MSVC)
        if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            set(3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x86/*.dll)
        elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            set(3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x64/*.dll)
        endif()
    elseif(MINGW)
        set(3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mingw/*.dll)
    endif()
    string(REPLACE "/" ${PATH_SEPARATOR} 3RDPARTY_DLL_DIR "${3RDPARTY_DLL_DIR}")
    file(GLOB DLL_FILES ${3RDPARTY_DLL_DIR})
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${DLL_FILES}
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #如果是Qt6.2以上，则使用qt_add_qml_module添加资源文件
    qt_add_qml_module(example
        URI "example"
        VERSION 1.0
        QML_FILES ${qml_files}
        RESOURCES ${resource_files}
        RESOURCE_PREFIX "/"
    )
else()
    #如果是Qt6.2以下，则使用qrc添加资源文件
    target_include_directories(example PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
    )
    target_sources(example PRIVATE example.qrc)
endif()

#导入component头文件,不然通过QML_NAMED_ELEMENT生成的c++类会找不到头文件报错
target_include_directories(example PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/component
)

#如果是静态库则需要手动注册插件，导入FluentUI.h头文件
if(FLUENTUI_BUILD_STATIC_LIB)
    target_include_directories(example PRIVATE
        ${CMAKE_SOURCE_DIR}/src
    )
endif()

#设置属性
set_target_properties(example PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

#Release也支持日志打印代码位置
target_compile_definitions(example
    PRIVATE
    QT_MESSAGELOGCONTEXT
)

#目标文件链接库
target_link_libraries(example PRIVATE
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Svg
    Qt${QT_VERSION_MAJOR}::Network
    fluentuiplugin
)

#安装
install(TARGETS example
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
