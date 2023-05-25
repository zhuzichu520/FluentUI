import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
Text {
    property color textColor: G.FluTheme.dark ? G.FluColors.White : G.FluColors.Grey220
    id:text
    color: textColor
    renderType: G.FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTextStyle.Body
}
