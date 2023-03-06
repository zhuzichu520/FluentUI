import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"Theme"
        fontStyle: FluText.TitleLarge
    }
    ScrollView{
        clip: true
        width: parent.width
        contentWidth: parent.width
        anchors{
            top: title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            spacing: 5
            RowLayout{
                Layout.topMargin: 20
                Repeater{
                    model: [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]
                    delegate:  Rectangle{
                        width: 42
                        height: 42
                        radius: 4
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        FluIcon {
                            anchors.centerIn: parent
                            icon: FluentIcons.FA_check
                            iconSize: 15
                            visible: modelData === FluTheme.primaryColor
                            color: FluTheme.isDark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea{
                            id:mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                FluTheme.primaryColor = modelData
                            }
                        }
                    }
                }
            }
            FluText{
                text:"夜间模式"
                fontStyle: FluText.Subtitle
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                checked: FluTheme.isDark
                onClickFunc:function(){
                    FluTheme.isDark = !FluTheme.isDark
                }
            }
        }
    }
}
