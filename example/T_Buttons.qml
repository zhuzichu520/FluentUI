import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    width: parent.width
    FluText{
        id:title
        text:"Buttons"
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
            width: parent.width
            RowLayout{
                Layout.topMargin: 20
                width: parent.width
                FluButton{
                    disabled:button_switch.checked
                    onClicked: {
                        showInfo("点击StandardButton")
                    }
                }
                Item{
                    height: 1
                    Layout.fillWidth: true
                }
                FluToggleSwitch{
                    id:button_switch
                    Layout.alignment: Qt.AlignRight
                }
                FluText{
                    text:"Disabled"
                }
            }
            FluDivider{
                Layout.fillWidth: true ; height:1;
            }
            RowLayout{
                Layout.topMargin: 20
                width: parent.width
                FluFilledButton{
                    disabled:filled_button_switch.checked
                    onClicked:{
                        showWarning("点击FilledButton")
                    }
                }
                Item{
                    height: 1
                    Layout.fillWidth: true
                }
                FluToggleSwitch{
                    id:filled_button_switch
                    Layout.alignment: Qt.AlignRight
                }
                FluText{
                    text:"Disabled"
                }
            }
            FluDivider{
                Layout.fillWidth: true ; height:1
            }
            RowLayout{
                Layout.topMargin: 20
                width: parent.width
                FluIconButton{
                    icon:FluentIcons.FA_close
                    disabled:icon_button_switch.checked
                    onClicked:{
                        showSuccess("点击IconButton")
                    }
                }
                Item{
                    height: 1
                    Layout.fillWidth: true
                }
                FluToggleSwitch{
                    id:icon_button_switch
                    Layout.alignment: Qt.AlignRight
                }
                FluText{
                    text:"Disabled"
                }
            }
            FluDivider{
                Layout.fillWidth: true ; height:1
            }
            RowLayout{
                Layout.topMargin: 20
                width: parent.width
                ColumnLayout{
                    spacing: 8
                    Repeater{
                        id:repeater
                        property int selecIndex : 0
                        model: 3
                        delegate:  FluRadioButton{
                            checked : repeater.selecIndex===index
                            disabled:radio_button_switch.checked
                            text:"RodioButton_"+index
                            onClicked:{
                                repeater.selecIndex = index
                            }
                        }
                    }
                }
                Item{
                    height: 1
                    Layout.fillWidth: true
                }
                FluToggleSwitch{
                    id:radio_button_switch
                    Layout.alignment: Qt.AlignRight
                }
                FluText{
                    text:"Disabled"
                }
            }
        }
    }
}
