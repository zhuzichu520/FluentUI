import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("CheckBox")

    FluArea{
        Layout.fillWidth: true
        height: 72
        paddings: 10
        Layout.topMargin: 20

        FluText{
            text: qsTr("A 2-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Right")
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Left")
                textRight: false
            }
        }
        FluToggleSwitch{
            id:check_box_switch_two
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Disabled")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluCheckBox{
    text:"Text"
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 72
        paddings: 10
        Layout.topMargin: 20

        FluText{
            text: qsTr("A 3-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                property int count: 1
                text: qsTr("Three State")
                disabled: check_box_switch_three.checked
                clickListener: function(){
                    var flag = count%3
                    if(flag === 0){
                        checked = false
                        indeterminate = false
                    }
                    if(flag === 1){
                        checked = true
                        indeterminate = false
                    }
                    if(flag === 2){
                        checked = true
                        indeterminate = true
                    }
                    count++
                }
            }
        }
        FluToggleSwitch{
            id:  check_box_switch_three
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Disabled")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluCheckBox{
    text:"Text"
    indeterminate:true
}'
    }

}
