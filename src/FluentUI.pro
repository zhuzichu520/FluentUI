TEMPLATE = lib
CONFIG += plugin
QT += qml core quick

QML_IMPORT_NAME = FluentUI

DESTDIR = $$[QT_INSTALL_QML]/$$QML_IMPORT_NAME
TARGET  = fluentuiplugin

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

target.path = imports/$$QML_IMPORT_NAME

PLUGIN_FILES = $$files(imports/$$QML_IMPORT_NAME/qmldir)
plugin_files.files = $$PLUGIN_FILES
plugin_files.path = $$DESTDIR

CONTROLS_FILES = $$files(imports/$$QML_IMPORT_NAME/Controls/*.qml)
controls_files.files = $$CONTROLS_FILES
controls_files.path = $$DESTDIR/Controls

CONTROLS_COLORPICKER_FILES = $$files(imports/$$QML_IMPORT_NAME/Controls/ColorPicker/*.qml)
controls_colorpicker_files.files = $$CONTROLS_COLORPICKER_FILES
controls_colorpicker_files.path = $$DESTDIR/Controls/ColorPicker

CONTROLS_COLORPICKER_CONTENT_FILES = $$files(imports/$$QML_IMPORT_NAME/Controls/ColorPicker/Content/*.qml)
controls_colorpicker_content_files.files = $$CONTROLS_COLORPICKER_CONTENT_FILES
controls_colorpicker_content_files.path = $$DESTDIR/Controls/ColorPicker/Content

CONTROLS_FONT_FILES = $$files(imports/$$QML_IMPORT_NAME/Font/*.ttf)
controls_font_files.files = $$CONTROLS_FONT_FILES
controls_font_files.path = $$DESTDIR/Font

pluginfiles_install.files = $$OUT_PWD/import/FluentUI/plugin.qmltypes
pluginfiles_install.path = $$DESTDIR

INSTALLS += target pluginfiles_install controls_font_files

COPIES += controls_files controls_colorpicker_files controls_colorpicker_content_files controls_font_files plugin_files

OTHER_FILES += $$PLUGIN_FILES $$CONTROLS_FILES $$CONTROLS_COLORPICKER_FILES $$CONTROLS_COLORPICKER_CONTENT_FILES $$CONTROLS_FONT_FILES

CONFIG += install_ok  # Do not cargo-cult this!
