cmake_minimum_required(VERSION 3.16)
project(FluentUI)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 COMPONENTS Core Quick Svg REQUIRED)
set(QT_INSTALL_QML ${Qt6Core_DIR}/../../../qml)
set(TARGET_TYPE SHARED)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/FluentUI)

set(TARGET_RESOURCES res.qrc)
set(TARGET_SOURCES
    Def.cpp
    FluApp.cpp
    FluColorSet.cpp
    FluColors.cpp
    FluRegister.cpp
    FluTheme.cpp
    Fluent.cpp
    FluentUI.cpp
    WindowHelper.cpp
    qml_plugin.cpp
)

set(TARGET_HEADERS
    Def.h
    FluApp.h
    FluColorSet.h
    FluColors.h
    FluRegister.h
    FluTheme.h
    Fluent.h
    FluentUI.h
    FramelessView.h
    WindowHelper.h
    qml_plugin.h
    stdafx.h
)

if(WIN32)
    set(TARGET_SOURCES ${TARGET_SOURCES} FramelessView_win.cpp)
else()
    set(TARGET_SOURCES ${TARGET_SOURCES} FramelessView_unix.cpp)
endif()

add_library(${PROJECT_NAME} ${TARGET_TYPE} ${TARGET_SOURCES} ${TARGET_HEADERS} ${TARGET_RESOURCES})

set_target_properties(${PROJECT_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/FluentUI)

target_compile_definitions(${PROJECT_NAME} PRIVATE VERSION_IN=\\\"1.0.0\\\" URI_STR=\\\"FluentUI\\\")

if(WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE dwmapi user32)
else()
endif()

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Quick Qt6::Svg)

if(WIN32)
    include(build_windows.cmake)
else()
    include(build_macos.cmake)
endif()
