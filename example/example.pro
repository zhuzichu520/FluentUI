QT += quick concurrent network multimedia
CONFIG += c++17
DEFINES += QT_DEPRECATED_WARNINGS QT_NO_WARNING_OUTPUT QUICK_USE_QMAKE

DEFINES += VERSION=1,3,1,0

HEADERS += \
    src/lang/En.h \
    src/lang/Lang.h \
    src/lang/Zh.h \
    src/stdafx.h \
    src/AppInfo.h \
    src/tool/IPC.h

SOURCES += \
    src/AppInfo.cpp \
    src/lang/En.cpp \
    src/lang/Lang.cpp \
    src/lang/Zh.cpp \
    src/main.cpp \
    src/tool/IPC.cpp

RESOURCES += example.qrc

RC_ICONS = favicon.ico

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

CONFIG(debug,debug|release) {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/debug)
} else {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/release)
}

win32 {
RC_FILE += example.rc
contains(QMAKE_CC, cl) {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../3rdparty/msvc/*.dll) $$DESTDIR
    QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, $$QMAKE_DIR_SEP)
} else {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../3rdparty/mingw/*.dll) $$DESTDIR
    QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, $$QMAKE_DIR_SEP)
}
}

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
