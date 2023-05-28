QT += qml core quick
CONFIG += plugin c++11
TEMPLATE = lib

QML_IMPORT_NAME = FluentUI

DESTDIR = $$[QT_INSTALL_QML]/$$QML_IMPORT_NAME
TARGET = fluentuiplugin
TARGET = $$qtLibraryTarget($$TARGET)

DEFINES += VERSION=1,3,1,0

SOURCES += \
    Def.cpp \
    FluApp.cpp \
    FluColors.cpp \
    FluColorSet.cpp \
    FluRegister.cpp \
    FluTextStyle.cpp \
    FluTheme.cpp \
    FluTools.cpp \
    WindowHelper.cpp \
    fluentuiplugin.cpp

HEADERS += \
    Def.h \
    FluApp.h \
    FluColors.h \
    FluColorSet.h \
    FluRegister.h \
    FluTextStyle.h \
    FluTheme.h \
    FluTools.h \
    fluentuiplugin.h \
    stdafx.h \
    WindowHelper.h

win32 {
RC_FILE += fluentui.rc
}

PLUGIN_FILES = $$files(imports/$$QML_IMPORT_NAME/*,true)
OTHER_FILES += $$PLUGIN_FILES

COPY_PLUGIN = $$absolute_path($${_PRO_FILE_PWD_}/imports/$$QML_IMPORT_NAME/**) $$DESTDIR
QMAKE_PRE_LINK += $$QMAKE_COPY_DIR $$replace(COPY_PLUGIN, /, $$QMAKE_DIR_SEP)

CONFIG += install_ok
