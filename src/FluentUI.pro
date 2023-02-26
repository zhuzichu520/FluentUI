QT          += qml quick svg
CONFIG      += plugin c++11
TEMPLATE    = lib
TARGET      = FluentUI
TARGET      = $$qtLibraryTarget($$TARGET)
uri         = FluentUI

##########################################
CONFIG += staticlib  # staticlib or sharedlib
#** 多次切换编译构建模式，建议先清理缓存。项目右键->清理

#*[staticlib] 构建静态库.a
#需要修改example.pro，请打开后按说明操作

#*[sharedlib] 构建动态库 .dll .so .dylib
#会自动安装到Qt qmlplugin目录中
#无需其它配置即可运行demo以及其它项目中使用
#发布目标平台前必须每个平台都要构建一次。
##########################################

RESOURCES += \
    res.qrc


# Input
HEADERS += \
    Def.h \
    FluApp.h \
    Fluent.h \
    FluentUI.h \
    FramelessView.h \
    qml_plugin.h \
    stdafx.h


SOURCES += \
    Def.cpp \
    FluApp.cpp \
    Fluent.cpp \
    FluentUI.cpp \
    qml_plugin.cpp \

win32 {
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
