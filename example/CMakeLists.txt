cmake_minimum_required(VERSION 3.16)
project(example)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 17)

file(TO_CMAKE_PATH "/" PATH_SEPARATOR)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(platform 64)
else()
  set(platform 32)
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin/debug)
else()
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin/release)
endif()

find_package(Qt5 COMPONENTS Core Quick QuickControls2 Concurrent Network Multimedia REQUIRED)

set(SOURCES
    ChatController.cpp
    AppInfo.cpp
    main.cpp
    lang/Lang.cpp
    lang/En.cpp
    lang/Zh.cpp
)

set(HEADERS
    ChatController.h
    AppInfo.h
    stdafx.h
    lang/Lang.h
    lang/En.h
    lang/Zh.h
)

set(RESOURCES
    qml.qrc
)

set(RC_ICONS
    favicon.ico
)

qt_add_resources(QT_RESOURCES ${RESOURCES})

add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${QT_RESOURCES} ${RC_ICONS})

if(WIN32)
    if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        set(DLLPATH ${CMAKE_CURRENT_SOURCE_DIR}/../third/msvc/*.dll)
    else()
        set(DLLPATH ${CMAKE_CURRENT_SOURCE_DIR}/../third/mingw/*.dll)
    endif()
    string(REPLACE "/" ${PATH_SEPARATOR} DLLPATH "${DLLPATH}")
    file(GLOB DLL_FILES ${DLLPATH})
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${DLL_FILES}
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_DEPRECATED_WARNINGS
    QT_NO_WARNING_OUTPUT
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Concurrent
    Qt5::Network
    Qt5::Multimedia
)

if(WIN32)
    target_compile_definitions(${PROJECT_NAME} PRIVATE UNICODE WIN32 _WINDOWS)
    target_link_libraries(${PROJECT_NAME} PRIVATE dwmapi user32)
endif()

if(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST Info.plist
    )
endif()
