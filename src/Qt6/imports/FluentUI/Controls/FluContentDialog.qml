import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

FluPopup {
    id: control
    property string title: ""
    property string message: ""
    property string neutralText: qsTr("Close")
    property string negativeText: qsTr("Cancel")
    property string positiveText: qsTr("OK")
    property int messageTextFormart: Text.AutoText
    property int delayTime: 100
    property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    property var contentDelegate:  Component{
        Item{
        }
    }
    property var onNeutralClickListener
    property var onNegativeClickListener
    property var onPositiveClickListener
    signal neutralClicked
    signal negativeClicked
    signal positiveClicked
    implicitWidth: 400
    implicitHeight: layout_content.height
    focus: true
    Component{
        id:com_message
        Flickable{
            id:sroll_message
            contentHeight: text_message.height
            contentWidth: width
            clip: true
            boundsBehavior:Flickable.StopAtBounds
            width: parent.width
            height: message === "" ? 0 : Math.min(text_message.height,300)
            ScrollBar.vertical: FluScrollBar {}
            FluText{
                id:text_message
                font: FluTextStyle.Body
                wrapMode: Text.WordWrap
                text:message
                width: parent.width
                topPadding: 4
                leftPadding: 20
                rightPadding: 20
                bottomPadding: 4
            }
        }
    }
    Rectangle {
        id:layout_content
        width: parent.width
        height: layout_column.childrenRect.height
        color: 'transparent'
        radius:5
        ColumnLayout{
            id:layout_column
            width: parent.width
            FluText{
                id:text_title
                font: FluTextStyle.Title
                text:title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WordWrap
            }
            FluLoader{
                sourceComponent: com_message
                Layout.fillWidth: true
                Layout.preferredHeight: status===Loader.Ready ? item.height : 0
            }
            FluLoader{
                sourceComponent:control.visible ? control.contentDelegate : undefined
                Layout.fillWidth: true
                onStatusChanged: {
                    if(status===Loader.Ready){
                        Layout.preferredHeight = item.implicitHeight
                    }else{
                        Layout.preferredHeight = 0
                    }
                }
            }
            Rectangle{
                id:layout_actions
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
                RowLayout{
                    anchors
                    {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 10
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        FluButton{
                            id:neutral_btn
                            visible: control.buttonFlags&FluContentDialogType.NeutralButton
                            text: neutralText
                            width: parent.width
                            anchors.centerIn: parent
                            onClicked: {
                                if(control.onNeutralClickListener){
                                    control.onNeutralClickListener()
                                }else{
                                    neutralClicked()
                                    control.close()
                                }
                            }
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        FluButton{
                            id:negative_btn
                            visible: control.buttonFlags&FluContentDialogType.NegativeButton
                            width: parent.width
                            anchors.centerIn: parent
                            text: negativeText
                            onClicked: {
                                if(control.onNegativeClickListener){
                                    control.onNegativeClickListener()
                                }else{
                                    negativeClicked()
                                    control.close()
                                }
                            }
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        FluFilledButton{
                            id:positive_btn
                            visible: control.buttonFlags&FluContentDialogType.PositiveButton
                            text: positiveText
                            width: parent.width
                            anchors.centerIn: parent
                            onClicked: {
                                if(control.onPositiveClickListener){
                                    control.onPositiveClickListener()
                                }else{
                                    positiveClicked()
                                    control.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
