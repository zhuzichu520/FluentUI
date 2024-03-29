import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Tooltip")

    FluText{
        text: qsTr("Hover over Tultip and it pops up")
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 68
        padding: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Text properties of FluIconButton support the Tooltip pop-up window by default")
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                iconSize: 15
                text: qsTr("Delete")
                onClicked:{
                    showSuccess(qsTr("Click IconButton"))
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluIconButton{
    iconSource:FluentIcons.ChromeCloseContrast
    iconSize: 15
    text: qsTr("Delete")
    onClicked:{
        showSuccess(qsTr("Click IconButton"))
    }
}
'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 68
        padding: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Add a Tooltip pop-up to a Button")
            }
            FluButton{
                id:button_1
                text: qsTr("Delete")
                onClicked:{
                    showSuccess(qsTr("Click Button"))
                }
                FluTooltip{
                    visible: button_1.hovered
                    text:button_1.text
                    delay: 1000
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluButton{
    id: button_1
    text: qsTr("Delete")
    FluTooltip{
        visible: button_1.hovered
        text:button_1.text
        delay: 1000
    }
    onClicked:{
        showSuccess(qsTr("Click Button"))
    }
}'
    }


}
