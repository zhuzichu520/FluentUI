import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Text {
    property int iconSource
    property int iconSize: 20
    property color iconColor: FluTheme.dark ? "#FFFFFF" : "#000000"
    id:control
    font.family: font_loader.name
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: enabled ? iconColor :  Qt.rgba(iconColor.r, iconColor.g, iconColor.b, iconColor.a * 0.5)

    text: (String.fromCharCode(iconSource).toString(16))
    opacity: iconSource>0
    FontLoader{
        id: font_loader
        source: "qrc:/qt/qml/FluentUI/Font/FluentIcons.ttf"
    }
}
