import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

Text {
    property color textColor: FluTheme.dark ? FluColors.White : FluColors.Grey220
    id:text
    color: textColor
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTextStyle.Body
}
