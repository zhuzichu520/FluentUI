import QtQuick
import QtQuick.Controls
import FluentUI

TextEdit {
    property color textColor: FluTheme.dark ? FluColors.White : FluColors.Grey220
    id:control
    color: textColor
    readOnly: true
    activeFocusOnTab: false
    activeFocusOnPress: false
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    padding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    selectionColor: FluTheme.primaryColor.lightest
    font:FluTextStyle.Body
    onSelectedTextChanged: {
        control.forceActiveFocus()
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
