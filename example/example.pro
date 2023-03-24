QT += quick quickcontrols2 concurrent network multimedia
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_WARNING_OUTPUT

SOURCES += \
        ChatController.cpp \
        main.cpp

RESOURCES += qml.qrc

RC_ICONS = favicon.ico

#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =
CONFIG(debug,debug|release) {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/debug)
} else {
    DESTDIR = $$absolute_path($${_PRO_FILE_PWD_}/../bin/release)
}

win32 {

contains(QT_ARCH, i386) {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../third/Win_x86/*.dll) $$DESTDIR
    contains(QMAKE_CC, cl) {
        QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, \\)
    } else {
        QMAKE_PRE_LINK += $$QMAKE_COPY $$COPYDLL
    }
} else {
    COPYDLL = $$absolute_path($${_PRO_FILE_PWD_}/../third/Win_x64/*.dll) $$DESTDIR
    contains(QMAKE_CC, cl) {
        QMAKE_PRE_LINK += $$QMAKE_COPY $$replace(COPYDLL, /, \\)
    } else {
        QMAKE_PRE_LINK += $$QMAKE_COPY $$COPYDLL
    }
}

}


HEADERS += \
    ChatController.h
