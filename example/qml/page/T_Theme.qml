import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    property var colorData: [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]
    id: root
    title: qsTr("Theme")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 340
        paddings: 10

        ColumnLayout{
            spacing:0
            anchors{
                left: parent.left
            }
            FluText{
                text: qsTr("Theme colors")
                Layout.topMargin: 10
            }
            RowLayout{
                Layout.topMargin: 5
                Repeater{
                    model: root.colorData
                    delegate:  Rectangle{
                        width: 42
                        height: 42
                        radius: 4
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        border.color: modelData.darkest
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === FluTheme.accentColor
                            color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea{
                            id:mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                FluTheme.accentColor = modelData
                            }
                        }
                    }
                }
            }
            Row{
                Layout.topMargin: 10
                spacing: 10
                FluText{
                    text: qsTr("Customize the Theme Color")
                    anchors.verticalCenter: parent.verticalCenter
                }
                FluColorPicker{
                    id:color_picker
                    current: FluTheme.accentColor.normal
                    onAccepted: {
                       FluTheme.accentColor = FluColors.createAccentColor(current)
                    }
                    FluIcon {
                        anchors.centerIn: parent
                        iconSource: FluentIcons.AcceptMedium
                        iconSize: 15
                        visible: {
                            for(var i =0 ;i< root.colorData.length; i++){
                                if(root.colorData[i] === FluTheme.accentColor){
                                    return false
                                }
                            }
                            return true
                        }
                        color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                    }
                }
            }
            FluText{
                text: qsTr("Dark Mode")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.dark
                onClicked: {
                    if(FluTheme.dark){
                        FluTheme.darkMode = FluThemeType.Light
                    }else{
                        FluTheme.darkMode = FluThemeType.Dark
                    }
                }
            }
            FluText{
                text: qsTr("Native Text")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.nativeText
                onClicked: {
                    FluTheme.nativeText = !FluTheme.nativeText
                }
            }
            FluText{
                text: qsTr("Open Animation")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.enableAnimation
                onClicked: {
                    FluTheme.enableAnimation = !FluTheme.enableAnimation
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTheme.accentColor = FluColors.Orange

FluTheme.dark = true

FluTheme.nativeText = true'
    }


}
