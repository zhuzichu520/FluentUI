import QtQuick
import FluentUI

Rectangle {

    color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,230/255,234/255,1)

    Behavior on color{
        ColorAnimation {
            duration: 300
        }
    }

}
