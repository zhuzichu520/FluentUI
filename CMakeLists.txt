cmake_minimum_required(VERSION 3.20)

project(FluentUI VERSION 0.1 LANGUAGES CXX)

add_subdirectory(src)
add_subdirectory(example)

add_definitions(-DFRAMELESSHELPER_CORE_NO_DEBUG_OUTPUT)
add_definitions(-DFRAMELESSHELPER_QUICK_NO_DEBUG_OUTPUT)
add_subdirectory(framelesshelper)
