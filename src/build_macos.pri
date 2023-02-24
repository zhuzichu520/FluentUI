OUTP = $$OUT_PWD/../bin/FluentUI/

DESTDIR += $$OUTP

QMAKE_MOC_OPTIONS += -Muri=$$uri
QMAKE_PRE_LINK += chmod -R 777 $$PWD/macos_install.sh;
QMAKE_PRE_LINK += $$PWD/macos_install.sh PRESET $$PWD/ $$OUTP;

CONFIG(sharedlib){
    INST_QMLPATH = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)

    QMAKE_POST_LINK += $$PWD/macos_install.sh INSTALL $$PWD/ $$OUTP $$INST_QMLPATH;

    exists($$PWD/../../dev.pri){
        include($$PWD/../../dev.pri)
    }
}
