include(CMakeParseArguments)
find_package(Qt5 REQUIRED COMPONENTS Core)
### Finds where to qmlplugindump binary is installed
### Requires that 'qmake' directory is in PATH
function(FindQmlPluginDump)
    get_target_property (QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
    execute_process(
            COMMAND ${QT_QMAKE_EXECUTABLE} -query QT_INSTALL_BINS
            OUTPUT_VARIABLE QT_BIN_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    set(QMLPLUGINDUMP_BIN ${QT_BIN_DIR}/qmlplugindump PARENT_SCOPE)
endfunction()

### Sets QT_INSTALL_QML to the directory where QML Plugins should be installed
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
    set(oneValueArgs URI VERSION BINARY_DIR QMLDIR)
    set(multiValueArgs SOURCES QMLFILES QMLFILESALIAS)
    cmake_parse_arguments(QMLPLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    ### At least TARGET, URI and VERSION must be specified
    if(NOT QMLPLUGIN_URI OR NOT QMLPLUGIN_VERSION OR NOT QMLPLUGIN_QMLDIR)
        message(WARNING "TARGET, URI、VERSION and qmldir must be set, no files generated")
        return()
    endif()

    ### Depending on project hierarchy, one might want to specify a custom binary dir
    if(NOT QMLPLUGIN_BINARY_DIR)
        set(QMLPLUGIN_BINARY_DIR ${CMAKE_BINARY_DIR}/${QMLPLUGIN_URI})
    endif()

    ### Source files
    add_library(${TARGET} SHARED
        ${QMLPLUGIN_SOURCES}
    )
    set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/lib)
    ### QML files, just to make them visible in the editor
    add_custom_target("${TARGET}-qmlfiles" SOURCES ${QMLPLUGIN_QMLFILES})

    ### No AutoMOC or AutoRCC
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

    ### Find location of qmlplugindump (stored in QMLPLUGINDUMP_BIN)
    FindQmlPluginDump()
    ### Find where to install QML Plugins (stored in QT_INSTALL_QML)
    FindQtInstallQml()

    if(QMLPLUGIN_BINARY_DIR)
        set(MAKE_QMLPLUGINDIR_COMMAND ${CMAKE_COMMAND} -E make_directory ${QMLPLUGIN_BINARY_DIR})
    endif()
    set(COPY_QMLDIR_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/${QMLPLUGIN_QMLDIR}/qmldir $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI}/qmldir)
    set(INSTALL_QMLDIR_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/${QMLPLUGIN_QMLDIR}/qmldir ${QMLPLUGIN_BINARY_DIR}/qmldir)
    set(COPY_LIBRARY_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_FILE_NAME:${TARGET}> $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    set(INSTALL_LIBRARY_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_FILE_NAME:${TARGET}> ${QMLPLUGIN_BINARY_DIR})
    if(QMLPLUGIN_QMLDIR)
        set(COPY_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_LIST_DIR}/${QMLPLUGIN_QMLDIR} $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    else()
        set(COPY_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/${QMLPLUGIN_QMLFILES} $<TARGET_FILE_DIR:${TARGET}>/${QMLPLUGIN_URI})
    endif()
    set(INSTALL_QMLFILES_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_LIST_DIR}/${QMLPLUGIN_QMLDIR} ${QMLPLUGIN_BINARY_DIR})
    set(GENERATE_QMLTYPES_COMMAND ${QMLPLUGINDUMP_BIN} -nonrelocatable ${QMLPLUGIN_URI} ${QMLPLUGIN_VERSION} ${CMAKE_CURRENT_BINARY_DIR} > ${CMAKE_CURRENT_BINARY_DIR}/${QMLPLUGIN_URI}/plugins.qmltypes)
    set(INSTALL_QMLTYPES_COMMAND ${QMLPLUGINDUMP_BIN} -nonrelocatable ${QMLPLUGIN_URI} ${QMLPLUGIN_VERSION} ${CMAKE_CURRENT_BINARY_DIR} > ${QMLPLUGIN_BINARY_DIR}/plugins.qmltypes)
    ### Copy qmldir from project source to binary dir
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

    ### Copy lib from binary dir to binary plugin dir
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${COPY_LIBRARY_COMMAND}
        COMMENT "Copying Lib to binary plugin directory"
    )

    ### Copy QML-files from project source to binary dir
    if(QMLPLUGIN_QMLFILES)
        add_custom_command(
            TARGET ${TARGET}
            POST_BUILD
            COMMAND ${COPY_QMLFILES_COMMAND}
            COMMENT "Copying QML files to binary directory"
        )
    endif()

    ### Create command to generate plugin.qmltypes after build
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${GENERATE_QMLTYPES_COMMAND}
        COMMENT "Generating plugin.qmltypes"
    )

    string(REPLACE "." "/" QMLPLUGIN_INSTALL_URI ${QMLPLUGIN_URI})

    ### Install library
    add_custom_command(
        TARGET ${TARGET}
        POST_BUILD
        COMMAND ${INSTALL_QMLDIR_COMMAND}
        COMMAND ${INSTALL_LIBRARY_COMMAND}
        COMMAND ${INSTALL_QMLFILES_COMMAND}
        COMMAND ${INSTALL_QMLTYPES_COMMAND}
        COMMENT "Install library and aditional files"
    )
endfunction()
