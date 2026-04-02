# QHotkey.cmake - qhotkey dependency detection and configuration
#
# Features:
#   - Detect platform-specific dependencies
#   - Set QHOTKEY_AVAILABLE variable
#   - Set QHOTKEY_SOURCES variable (source files to compile)
#   - Set QHOTKEY_LINK_LIBRARIES variable (libraries to link)
#
# Supported Platforms:
#   - Windows: Supported
#   - macOS: Supported (requires Carbon framework)
#   - Linux: Supported (requires X11, Wayland is not supported)
#   - Android/iOS/WebOS etc: Not supported
#
# Usage:
#   include(QHotkey)
#   list(APPEND sources_files ${QHOTKEY_SOURCES})
#   target_link_libraries(${PROJECT_NAME} PRIVATE ${QHOTKEY_LINK_LIBRARIES})
#   if(QHOTKEY_AVAILABLE)
#       target_compile_definitions(${PROJECT_NAME} PRIVATE QHOTKEY_AVAILABLE)
#   endif()

set(QHOTKEY_AVAILABLE ON)
set(QHOTKEY_SOURCES "")
set(QHOTKEY_LINK_LIBRARIES "")

if(ANDROID)
    # Android does not support global hotkey
    message(STATUS "qhotkey: Android platform does not support global hotkey, feature disabled")
    set(QHOTKEY_AVAILABLE OFF)

elseif(IOS)
    # iOS does not support global hotkey
    message(STATUS "qhotkey: iOS platform does not support global hotkey, feature disabled")
    set(QHOTKEY_AVAILABLE OFF)

elseif(WIN32)
    # Windows: user32 is a system library, always available
    message(STATUS "qhotkey: Windows platform detected, user32 is available")
    list(APPEND QHOTKEY_SOURCES qhotkey/qhotkey_win.cpp)
    list(APPEND QHOTKEY_LINK_LIBRARIES user32)

elseif(APPLE)
    # macOS: detect Carbon framework
    find_library(CARBON_LIBRARY Carbon)
    if(CARBON_LIBRARY)
        message(STATUS "qhotkey: Carbon framework found")
        list(APPEND QHOTKEY_SOURCES qhotkey/qhotkey_mac.cpp)
        list(APPEND QHOTKEY_LINK_LIBRARIES ${CARBON_LIBRARY})
    else()
        message(WARNING "qhotkey: Carbon framework not found, hotkey feature will be disabled")
        set(QHOTKEY_AVAILABLE OFF)
    endif()

elseif(UNIX)
    # Linux: detect X11 (Wayland is not supported)
    find_package(X11 QUIET)
    if(X11_FOUND)
        message(STATUS "qhotkey: X11 found")
        list(APPEND QHOTKEY_SOURCES qhotkey/qhotkey_x11.cpp)
        list(APPEND QHOTKEY_LINK_LIBRARIES X11::X11)
        # Qt5 requires X11Extras
        if(QT_VERSION_MAJOR LESS 6)
            find_package(Qt5 COMPONENTS X11Extras QUIET)
            if(Qt5X11Extras_FOUND)
                list(APPEND QHOTKEY_LINK_LIBRARIES Qt5::X11Extras)
            else()
                message(WARNING "qhotkey: Qt5::X11Extras not found, hotkey feature will be disabled")
                set(QHOTKEY_AVAILABLE OFF)
            endif()
        endif()
    else()
        message(WARNING "qhotkey: X11 not found (Wayland is not supported), hotkey feature will be disabled")
        set(QHOTKEY_AVAILABLE OFF)
    endif()

else()
    message(STATUS "qhotkey: Unsupported platform, hotkey feature will be disabled")
    set(QHOTKEY_AVAILABLE OFF)
endif()

if(QHOTKEY_AVAILABLE)
    message(STATUS "qhotkey: Enabled")
else()
    message(STATUS "qhotkey: Disabled")
endif()
