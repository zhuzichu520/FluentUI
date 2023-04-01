set(OUTP ${CMAKE_BINARY_DIR}/bin/FluentUI/)

add_definitions(-DMACOS)

set(CMAKE_INSTALL_PREFIX ${OUTP})
set(CMAKE_INSTALL_DESTDIR ${OUTP})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

set(QMAKE_MOC_OPTIONS -Muri=${uri})

add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND chmod -R 777 ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh
)

add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh PRESET ${CMAKE_CURRENT_SOURCE_DIR}/ ${OUTP}
)



if(${TARGET_TYPE} STREQUAL "SHARED")

    set(INST_QMLPATH ${QT_INSTALL_QML}/FluentUI)
    add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/macos_install.sh INSTALL ${CMAKE_CURRENT_SOURCE_DIR}/ ${OUTP} ${INST_QMLPATH}
    )

endif()
