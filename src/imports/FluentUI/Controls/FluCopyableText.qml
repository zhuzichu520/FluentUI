 import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G

TextField {
    property color textColor: G.FluTheme.dark ? G.FluColors.White : G.FluColors.Grey220
    id:control
    color: textColor
    readOnly: true
    renderType: G.FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    padding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    selectByMouse: true
    selectionColor: G.FluTheme.primaryColor.lightest
    TextMetrics {
        id: text_metrics
        font:control.font
        text: control.text
    }
    background: Item{
        implicitWidth: text_metrics.width+10
        implicitHeight: text_metrics.height
    }
    font:FluTextStyle.Body
    MouseArea{
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.NoButton
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: control.echoMode !== TextInput.Password && menu.popup()
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }
}
