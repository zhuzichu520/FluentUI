import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

FluScrollablePage{

    title:"Theme"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 270
        paddings: 10
        ColumnLayout{
            spacing:0
            anchors{
                left: parent.left
            }
            RowLayout{
                Layout.topMargin: 10
                Repeater{
                    model: [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]
                    delegate:  FluRectangle{
                        width: 42
                        height: 42
                        radius: [4,4,4,4]
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === FluTheme.themeColor
                            color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea{
                            id:mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                FluTheme.themeColor = modelData
                            }
                        }
                    }
                }
            }
            FluText{
                text:"夜间模式"
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
                text:"native文本渲染"
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
                text:"开启动画效果"
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
        code:'FluTheme.themeColor = FluColors.Orange

FluTheme.dark = true

FluTheme.nativeText = true'
    }


}
