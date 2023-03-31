QT          += qml quick svg
CONFIG      += plugin c++17
TEMPLATE    = lib
TARGET      = FluentUI
TARGET      = $$qtLibraryTarget($$TARGET)
uri         = FluentUI

CONFIG += sharedlib  # staticlib or sharedlib

RESOURCES += \
    res.qrc

HEADERS += \
    Def.h \
    FluApp.h \
    FluColorSet.h \
    FluColors.h \
    FluRegister.h \
    FluTheme.h \
    Fluent.h \
    FluentUI.h \
    FramelessView.h \
    WindowHelper.h \
    qml_plugin.h \
    stdafx.h

SOURCES += \
    Def.cpp \
    FluApp.cpp \
    FluColorSet.cpp \
    FluColors.cpp \
    FluRegister.cpp \
    FluTheme.cpp \
    Fluent.cpp \
    FluentUI.cpp \
    WindowHelper.cpp \
    qml_plugin.cpp \

win32 {
    LIBS += -ldwmapi -luser32
    SOURCES += \
        FramelessView_win.cpp
} else {
    SOURCES += \
        FramelessView_unix.cpp
}

DEFINES += VERSION_IN=\\\"1.0.0\\\"
DEFINES += URI_STR=\\\"$$uri\\\"

contains(QMAKE_HOST.os,Windows) {
    include(./build_windows.pri)
}else{
    include(./build_macos.pri)
}
