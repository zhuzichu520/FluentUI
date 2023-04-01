OUTP = $$OUT_PWD/../bin/FluentUI
BUILDBIN_PATH = $$replace(OUTP, src/../bin, bin)
message("----------------->")
message($$OUTP)
message($$BUILDBIN_PATH)
QTQMLFLUENT_PATH = $$[QT_INSTALL_QML]/FluentUI
PRESET_PATH = $$PWD/build-preset
SOLIBFILE_PATH = $$OUT_PWD/libFluentUI.so
ANDROID = NO

android{
    ANDROID=YES
    QMAKE_PRE_LINK *= md $$replace(OUTP, /, \\)
}else{
    DESTDIR += $$OUTP
}

SHAREDSCRIPT = "$$PWD\win_install.bat" SHARED "$$PWD" "$$PRESET_PATH" "$$BUILDBIN_PATH" "$$QTQMLFLUENT_PATH" $$ANDROID "$$SOLIBFILE_PATH"
STATICSCRIPT = "$$PWD\win_install.bat" STATIC "$$PWD" "$$PRESET_PATH" "$$BUILDBIN_PATH" "$$QTQMLFLUENT_PATH" $$ANDROID "$$SOLIBFILE_PATH"

message("-------------------------")
message($$SHAREDSCRIPT)
CONFIG(sharedlib){
    QMAKE_POST_LINK *= $$replace(SHAREDSCRIPT, /, \\)
}
else{
    QMAKE_POST_LINK *= $$replace(STATICSCRIPT, /, \\)
}
