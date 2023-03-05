QT += quick concurrent
CONFIG += c++11 qtquickcompiler utf8_source

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_WARNING_OUTPUT

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    stdafx.h
