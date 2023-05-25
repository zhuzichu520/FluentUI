import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
import "../component"

FluScrollablePage{

    title:"Theme"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 210
        paddings: 10
        ColumnLayout{
            spacing:0
            anchors{
                left: parent.left
            }
            RowLayout{
                Layout.topMargin: 10
                Repeater{
                    model: [G.FluColors.Yellow,G.FluColors.Orange,G.FluColors.Red,G.FluColors.Magenta,G.FluColors.Purple,G.FluColors.Blue,G.FluColors.Teal,G.FluColors.Green]
                    delegate:  FluRectangle{
                        width: 42
                        height: 42
                        radius: [4,4,4,4]
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === G.FluTheme.primaryColor
                            color: G.FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea{
                            id:mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                G.FluTheme.primaryColor = modelData
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
                selected: G.FluTheme.dark
                clickFunc:function(){
                    if(G.FluTheme.dark){
                        G.FluTheme.darkMode = FluDarkMode.Light
                    }else{
                        G.FluTheme.darkMode = FluDarkMode.Dark
                    }
                }
            }
            FluText{
                text:"native文本渲染"
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                selected: G.FluTheme.nativeText
                clickFunc:function(){
                    G.FluTheme.nativeText = !G.FluTheme.nativeText
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'G.FluTheme.primaryColor = G.FluColors.Orange

G.FluTheme.dark = true

G.FluTheme.nativeText = true'
    }


}
