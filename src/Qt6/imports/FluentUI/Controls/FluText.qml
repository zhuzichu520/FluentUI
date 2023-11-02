import QtQuick
import QtQuick.Controls
import FluentUI

Text {
    property color textColor: FluTheme.fontPrimaryColor
    id:text
    color: textColor
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTextStyle.Body
}
