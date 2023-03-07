QT += quick concurrent
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_WARNING_OUTPUT

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

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
