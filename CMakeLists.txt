cmake_minimum_required(VERSION 3.20)

project(FluentUI VERSION 0.1 LANGUAGES CXX)

option(FLUENTUI_BUILD_EXAMPLES "Build FluentUI demo applications." ON)
option(FLUENTUI_BUILD_FRAMELESSHEPLER "Build FramelessHelper." ON)
option(FLUENTUI_BUILD_STATIC_LIB "Build static library." OFF)

add_subdirectory(src)

if (FLUENTUI_BUILD_EXAMPLES)
    add_subdirectory(example)
endif ()

if (FLUENTUI_BUILD_FRAMELESSHEPLER)
    add_definitions(-DFRAMELESSHELPER_CORE_NO_DEBUG_OUTPUT)
    add_definitions(-DFRAMELESSHELPER_QUICK_NO_DEBUG_OUTPUT)
    add_subdirectory(framelesshelper)
endif ()

message("------------------------ FluentUI ------------------------")
message("Build FluentUI demo applications.: ${FLUENTUI_BUILD_EXAMPLES}")
message("Build FramelessHelper.: ${FLUENTUI_BUILD_FRAMELESSHEPLER}")
message("Build static library.: ${FLUENTUI_BUILD_STATIC_LIB}")
