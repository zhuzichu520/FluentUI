import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Text {
    property color textColor: FluTheme.fontPrimaryColor
    id:text
    color: enabled ? textColor : (FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1))
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTextStyle.Body
}
