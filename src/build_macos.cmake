set(OUTP "${CMAKE_CURRENT_BINARY_DIR}/../bin/FluentUI/")

add_definitions(-DMACOS)

# Set DESTDIR to the output directory
set(CMAKE_INSTALL_PREFIX ${OUTP})
set(CMAKE_INSTALL_DESTDIR ${OUTP})

# Add the current source directory to the include path
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Set MOC options
set(QMAKE_MOC_OPTIONS -Muri=${uri})

# Set pre-link commands
add_custom_command(
    TARGET ${PROJECT_NAME} PRE_LINK
    COMMAND chmod -R 777 ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh PRESET ${CMAKE_CURRENT_SOURCE_DIR}/ ${OUTP}
)

# Set post-link commands for shared library
if(BUILD_SHARED_LIBS)
    # Set INST_QMLPATH variable
    set(INST_QMLPATH "${QT_INSTALL_QML}/${uri}" REPLACE "\\" "/")

    # Set post-link command
    add_custom_command(
        TARGET ${PROJECT_NAME} POST_LINK
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh INSTALL ${CMAKE_CURRENT_SOURCE_DIR}/ ${OUTP} ${INST_QMLPATH}
    )

    # Include dev.pri if it exists
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../dev.pri)
        include(${CMAKE_CURRENT_SOURCE_DIR}/../../dev.pri)
    endif()
endif()
