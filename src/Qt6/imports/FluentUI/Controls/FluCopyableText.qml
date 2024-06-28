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
    selectByMouse: true
    selectedTextColor: color
    bottomPadding: 0
    selectionColor: FluTools.withOpacity(FluTheme.primaryColor,0.5)
    font:FluTextStyle.Body
    onSelectedTextChanged: {
        control.forceActiveFocus()
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: control.echoMode !== TextInput.Password && menu_loader.popup()
    }
    FluLoader{
        id: menu_loader
        function popup(){
            sourceComponent = menu
        }
        onLoaded: {
            item.open()
        }
    }
    Component{
        id:menu
        FluTextBoxMenu{
            inputItem: control
            onClosed: {
                menu_loader.sourceComponent = undefined
            }
        }
    }
}
