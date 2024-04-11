import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Text {
    property bool isFontAwesome: false
    property int iconSource
    property int iconSize: 20
    property color iconColor: FluTheme.dark ? "#FFFFFF" : "#000000"
    id:control
    font {
        family: {
            if (isFontAwesome) {
                return fontFontAwesome.name;
            } else {
                return fontSegoeIcons.name;
            }
        }
        pixelSize: iconSize
    }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
    FontLoader{
        id: fontFontAwesome
        source: "../Font/Font-Awesome-6-Free-Solid.ttf"
    }
    FontLoader{
        id: fontSegoeIcons
        source: "../Font/Segoe_Fluent_Icons.ttf"
    }
}
