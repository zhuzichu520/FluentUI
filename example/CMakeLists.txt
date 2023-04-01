cmake_minimum_required(VERSION 3.16)
project(example)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 COMPONENTS Core Quick QuickControls2 Concurrent Network Multimedia REQUIRED)

set(SOURCES
    ChatController.cpp
    main.cpp
)

set(HEADERS
    ChatController.h
)

set(RESOURCES
    qml.qrc
)

set(RC_ICONS
    favicon.ico
)

qt_add_resources(QT_RESOURCES ${RESOURCES})

if(WIN32)
    if(QT_ARCH EQUAL 32)
        set(COPYDLL ${CMAKE_CURRENT_SOURCE_DIR}/../third/Win_x86/*.dll ${DESTDIR})
    else()
        set(COPYDLL ${CMAKE_CURRENT_SOURCE_DIR}/../third/Win_x64/*.dll ${DESTDIR})
    endif()
    if(QMAKE_CC STREQUAL "cl")
        set(QMAKE_PRE_LINK "${QMAKE_COPY} ${COPYDLL}")
    else()
        set(QMAKE_PRE_LINK "${QMAKE_COPY} ${COPYDLL}")
    endif()
endif()

add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${QT_RESOURCES} ${RC_ICONS})

target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_DEPRECATED_WARNINGS
    QT_NO_WARNING_OUTPUT
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Concurrent
    Qt6::Network
    Qt6::Multimedia
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
