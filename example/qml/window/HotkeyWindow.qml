import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "../component"

FluWindow {

    id: window
    property string sequence: ""
    title: qsTr("Hotkey")
    width: 250
    height: 250
    fixSize: true
    launchMode: FluWindowType.SingleInstance
    onInitArgument:
        (argument)=>{
            window.sequence = argument.sequence
        }
    FluText{
        anchors.centerIn: parent
        color: FluTheme.primaryColor
        font: FluTextStyle.Title
        text: window.sequence
    }
}
