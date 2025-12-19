# FindQtLinguistTools.cmake - 查找Qt Linguist工具 (lupdate, lrelease)

if (NOT QT_LRELEASE OR NOT QT_LUPDATE)
    find_package(Qt${QT_VERSION_MAJOR}LinguistTools QUIET)

    if (NOT Qt${QT_VERSION_MAJOR}_LRELEASE_EXECUTABLE)
        if (UNIX)
            find_program(QT_LUPDATE NAMES lupdate PATHS
                "/lib/qt${QT_VERSION_MAJOR}/bin" NO_DEFAULT_PATH)
            find_program(QT_LRELEASE NAMES lrelease PATHS
                "/lib/qt${QT_VERSION_MAJOR}/bin" NO_DEFAULT_PATH)
        endif()
        if (NOT QT_LUPDATE)
            find_program(QT_LUPDATE NAMES lupdate lupdate-qt${QT_VERSION_MAJOR})
            message(STATUS "Found lupdate in sys path = ${QT_LUPDATE}")
        endif()
        if (NOT QT_LRELEASE)
            find_program(QT_LRELEASE NAMES lrelease lrelease-qt${QT_VERSION_MAJOR})
            message(STATUS "Found lrelease in sys path = ${QT_LRELEASE}")
        endif()
    else()
        set(QT_LUPDATE "${Qt${QT_VERSION_MAJOR}_LUPDATE_EXECUTABLE}")
        set(QT_LRELEASE "${Qt${QT_VERSION_MAJOR}_LRELEASE_EXECUTABLE}")
    endif()

    message("Find and set QT_LRELEASE = ${QT_LRELEASE}")
else()
    # 如果找到， 直接使用
    message("Use found QT_LUPDATE = ${QT_LUPDATE}, QT_LRELEASE = ${QT_LRELEASE}")
endif()

# 检查是否找到必要的工具
if(NOT QT_LUPDATE)
    message(WARNING "Could not find lupdate tool")
endif()

if(NOT QT_LRELEASE)
    message(WARNING "Could not find lrelease tool")
endif()