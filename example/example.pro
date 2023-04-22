QT += quick concurrent network multimedia
CONFIG += c++17
DEFINES += QT_DEPRECATED_WARNINGS QT_NO_WARNING_OUTPUT

HEADERS += \
    src/lang/En.h \
    src/lang/Lang.h \
    src/lang/Zh.h \
    src/stdafx.h \
    src/controller/ChatController.h \
    src/AppInfo.h \
    src/tool/IPC.h

SOURCES += \
        src/controller/ChatController.cpp \
        src/AppInfo.cpp \
        src/lang/En.cpp \
        src/lang/Lang.cpp \
        src/lang/Zh.cpp \
        src/main.cpp \
        src/tool/IPC.cpp

RESOURCES += qml.qrc

RC_ICONS = favicon.ico

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

CONFIG(debug,debug|release) {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/debug)
} else {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/release)
}

win32 {

contains(QMAKE_CC, cl) {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../third/msvc/*.dll) $$DESTDIR
    QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, $$QMAKE_DIR_SEP)
} else {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../third/mingw/*.dll) $$DESTDIR
    QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, $$QMAKE_DIR_SEP)
}

}

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

mac: {
    QMAKE_INFO_PLIST = Info.plist
}

#### 如果你正在使用静态库，请将将下面的配置注释取消掉。
#DEFINES += STATICLIB
#INCLUDEPATH += $$OUT_PWD/../bin/FluentUI/
#LIBS += -L$$OUT_PWD/../bin/FluentUI/ -lFluentUI
