cmake_minimum_required(VERSION 3.16)

if(APPLE)
#配置通用编译
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif()

project(FluentUI VERSION 0.1 LANGUAGES CXX)

add_subdirectory(src)
add_subdirectory(example)
