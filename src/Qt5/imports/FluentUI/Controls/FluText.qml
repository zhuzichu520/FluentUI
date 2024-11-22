import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Text {
    property color textColor: FluTheme.fontPrimaryColor
    id:text
    color: enabled ? textColor :  Qt.rgba(textColor.r, textColor.g, textColor.b, textColor.a * 0.7)
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTextStyle.Body
}
