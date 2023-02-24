OUTP = $$OUT_PWD/../bin/FluentUI
BUILDBIN_PATH = $$replace(OUTP, src/../bin, bin)
QTQMLFLUENT_PATH = $$[QT_INSTALL_QML]/FluentUI
PRESET_PATH = $$PWD/build-preset
SOLIBFILE_PATH = $$OUT_PWD/libFluentUI.so
ANDROID = NO

#QT_BIN_PATH = $$[QT_INSTALL_BINS]
#PLUGIN_NAME = $$uri
#PLUGIN_VERSION  = "1.0"
#PLUGIN_PARENT_PATH   = $$BUILD_ROOT/build-preset/plugins
#PLUGIN_QMLTYPES_PATH = $$BUILD_ROOT/build-preset/plugins/$$uri/plugin.qmltypes

android{
    ANDROID=YES
    QMAKE_PRE_LINK *= md $$replace(OUTP, /, \\)
}else{
    DESTDIR += $$OUTP
}

#QMLTYPESSCRIPT = "$$PWD\create_qmltypes.bat" "$$QT_BIN_PATH" "$$PLUGIN_NAME" "$$PLUGIN_VERSION" "$$PLUGIN_PARENT_PATH" "$$PLUGIN_QMLTYPES_PATH"
SHAREDSCRIPT = "$$PWD\win_install.bat" SHARED "$$PWD" "$$PRESET_PATH" "$$BUILDBIN_PATH" "$$QTQMLFLUENT_PATH" $$ANDROID "$$SOLIBFILE_PATH"
STATICSCRIPT = "$$PWD\win_install.bat" STATIC "$$PWD" "$$PRESET_PATH" "$$BUILDBIN_PATH" "$$QTQMLFLUENT_PATH" $$ANDROID "$$SOLIBFILE_PATH"

#QMAKE_POST_LINK *= $$replace(QMLTYPESSCRIPT, /, \\)

CONFIG(sharedlib){
    QMAKE_POST_LINK *= $$replace(SHAREDSCRIPT, /, \\)
}
else{
    QMAKE_POST_LINK *= $$replace(STATICSCRIPT, /, \\)
}
