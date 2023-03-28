import QtQuick 2.15
import FluentUI 1.0

Rectangle {

    color: FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,230/255,234/255,1)

    Behavior on color{
        ColorAnimation {
            duration: 300
        }
    }

}
