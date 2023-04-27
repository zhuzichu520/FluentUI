cmake_minimum_required(VERSION 3.16)
project(fluentui LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/debug)
else()
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/release)
endif()

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

file(GLOB_RECURSE QML_PATHS *.qml)
foreach(filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND qml_files ${filename})
endforeach(filepath)

file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp)
foreach(filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND resource_files ${filename})
endforeach(filepath)

foreach(filepath IN LISTS qml_files resource_files)
    string(REPLACE "imports/FluentUI/" "" filename ${filepath})
    set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
endforeach()

qt_add_qml_module(fluentui
    OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/FluentUI
    VERSION 1.0
    URI "FluentUI"
    SOURCES ${sources_files}
    QML_FILES ${qml_files}
    RESOURCES ${resource_files}
)

set_target_properties(fluentui PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(fluentui PUBLIC
    Qt::Core
    Qt::Quick
    Qt::Qml
)

if(WIN32)
    target_link_libraries(fluentui PRIVATE dwmapi user32)
endif()
