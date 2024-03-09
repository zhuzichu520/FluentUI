include(CMakeParseArguments)
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)
function(FindQmlPluginDump)
    get_target_property (QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
    execute_process(
        COMMAND ${QT_QMAKE_EXECUTABLE} -query QT_INSTALL_BINS
        OUTPUT_VARIABLE QT_BIN_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endfunction()
function(FindQtInstallQml)
    execute_process(
        COMMAND ${QT_QMAKE_EXECUTABLE} -query QT_INSTALL_QML
        OUTPUT_VARIABLE PROC_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
set(QT_INSTALL_QML ${PROC_RESULT} PARENT_SCOPE)
endfunction()
function(add_qmlplugin TARGET)
    set(options NO_AUTORCC NO_AUTOMOC)
    set(oneValueArgs URI VERSION BINARY_DIR QMLDIR LIBTYPE)
    set(multiValueArgs SOURCES QMLFILES QMLFILESALIAS)
    cmake_parse_arguments(QMLPLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(NOT QMLPLUGIN_URI OR NOT QMLPLUGIN_VERSION OR NOT QMLPLUGIN_QMLDIR OR NOT QMLPLUGIN_LIBTYPE)
        message(WARNING "TARGET,URI,VERSION,qmldir and LIBTYPE must be set, no files generated")
        return()
    endif()
    if(NOT QMLPLUGIN_BINARY_DIR)
        set(QMLPLUGIN_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${QMLPLUGIN_URI})
    endif()
    add_library(${TARGET} ${QMLPLUGIN_LIBTYPE}
        ${QMLPLUGIN_SOURCES}
    )
set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/lib)
if(QMLPLUGIN_NO_AUTORCC)
    set_target_properties(${TARGET} PROPERTIES AUTOMOC OFF)
else()
    set_target_properties(${TARGET} PROPERTIES AUTOMOC ON)
endif()
if(QMLPLUGIN_NO_AUTOMOC)
    set_target_properties(${TARGET} PROPERTIES AUTOMOC OFF)
else()
    set_target_properties(${TARGET} PROPERTIES AUTOMOC ON)
endif()
if (${QMLPLUGIN_LIBTYPE} MATCHES "SHARED")
    FindQmlPluginDump()
    FindQtInstallQml()
    if(QMLPLUGIN_BINARY_DIR)
        set(MAKE_QMLPLUGINDIR_COMMAND ${CMAKE_COMMAND} -E make_directory ${QMLPLUGIN_BINARY_DIR})
    endif()
    set(COPY_QMLDIR_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR}/qmldir $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI}/qmldir)
    set(INSTALL_QMLDIR_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR}/qmldir ${QMLPLUGIN_BINARY_DIR}/qmldir)
    set(COPY_QMLTYPES_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR}/plugins.qmltypes $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI}/plugins.qmltypes)
    set(INSTALL_QMLTYPES_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR}/plugins.qmltypes ${QMLPLUGIN_BINARY_DIR}/plugins.qmltypes)
    set(COPY_LIBRARY_COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${TARGET}>/$<TARGET_FILE_NAME:${TARGET}> $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    set(INSTALL_LIBRARY_COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${TARGET}>/$<TARGET_FILE_NAME:${TARGET}> ${QMLPLUGIN_BINARY_DIR})
    if(QMLPLUGIN_QMLDIR)
        set(COPY_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR} $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    else()
        set(COPY_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${QMLPLUGIN_QMLFILES} $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    endif()
    set(INSTALL_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/${QMLPLUGIN_QMLDIR} ${QMLPLUGIN_BINARY_DIR})
    if(QMLPLUGIN_BINARY_DIR)
        add_custom_command(
            TARGET ${TARGET}
            POST_BUILD
            COMMAND ${MAKE_QMLPLUGINDIR_COMMAND}
            COMMAND ${COPY_QMLDIR_COMMAND}
            COMMENT "Copying qmldir to binary directory"
        )
else()
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${COPY_QMLDIR_COMMAND}
        COMMENT "Copying qmldir to binary directory"
    )
endif()
if(QMLPLUGIN_BINARY_DIR)
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${MAKE_QMLPLUGINDIR_COMMAND}
        COMMAND ${COPY_QMLTYPES_COMMAND}
        COMMENT "Copying qmltypes to binary directory"
    )
else()
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${COPY_QMLTYPES_COMMAND}
        COMMENT "Copying qmltypes to binary directory"
    )
endif()
add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${COPY_LIBRARY_COMMAND}
    COMMENT "Copying Lib to binary plugin directory"
)
if(QMLPLUGIN_QMLFILES)
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${COPY_QMLFILES_COMMAND}
        COMMENT "Copying QML files to binary directory"
    )
endif()
add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${GENERATE_QMLTYPES_COMMAND}
    COMMENT "Generating plugin.qmltypes"
)
string(REPLACE "." "/" QMLPLUGIN_INSTALL_URI ${QMLPLUGIN_URI})
add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${INSTALL_QMLTYPES_COMMAND}
    COMMAND ${INSTALL_QMLDIR_COMMAND}
    COMMAND ${INSTALL_LIBRARY_COMMAND}
    COMMAND ${INSTALL_QMLFILES_COMMAND}
    COMMAND ${INSTALL_QMLTYPES_COMMAND}
    COMMENT "Install library and aditional files"
)
endif()
endfunction()
