import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

FluPopup {
    id: popup
    property string title: "Title"
    property string message: "Message"
    property string neutralText: "Neutral"
    property string negativeText: "Negative"
    property string positiveText: "Positive"
    property alias messageTextFormart: text_message.textFormat
    property int delayTime: 100
    signal neutralClicked
    signal negativeClicked
    signal positiveClicked
    property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    focus: true
    implicitWidth: 400
    implicitHeight: text_title.height + sroll_message.height + layout_actions.height
    Rectangle {
        id:layout_content
        anchors.fill: parent
        color: 'transparent'
        radius:5
        FluText{
            id:text_title
            font: FluTextStyle.TitleLarge
            text:title
            topPadding: 20
            leftPadding: 20
            rightPadding: 20
            wrapMode: Text.WrapAnywhere
            anchors{
                top:parent.top
                left: parent.left
                right: parent.right
            }
        }
        Flickable{
            id:sroll_message
            contentWidth: width
            clip: true
            anchors{
                top:text_title.bottom
                left: parent.left
                right: parent.right
            }
            boundsBehavior:Flickable.StopAtBounds
            contentHeight: text_message.height
            height: Math.min(text_message.height,300)
            ScrollBar.vertical: FluScrollBar {}
            FluText{
                id:text_message
                font: FluTextStyle.Body
                wrapMode: Text.WrapAnywhere
                text:message
                width: parent.width
                topPadding: 14
                leftPadding: 20
                rightPadding: 20
                bottomPadding: 14
            }
        }
        Rectangle{
            id:layout_actions
            height: 68
            radius: 5
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
            anchors{
                top:sroll_message.bottom
                left: parent.left
                right: parent.right
            }
            RowLayout{
                anchors
                {
                    centerIn: parent
                    margins: spacing
                    fill: parent
                }
                spacing: 15
                FluButton{
                    id:neutral_btn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: popup.buttonFlags&FluContentDialogType.NeutralButton
                    text: neutralText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialogType.NeutralButton
                        timer_delay.restart()
                    }
                }
                FluButton{
                    id:negative_btn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: popup.buttonFlags&FluContentDialogType.NegativeButton
                    text: negativeText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialogType.NegativeButton
                        timer_delay.restart()
                    }
                }
                FluFilledButton{
                    id:positive_btn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: popup.buttonFlags&FluContentDialogType.PositiveButton
                    text: positiveText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialogType.PositiveButton
                        timer_delay.restart()
                    }
                }
            }
        }
    }
    Timer{
        property int targetFlags
        id:timer_delay
        interval: popup.delayTime
        onTriggered: {
            if(targetFlags === FluContentDialogType.NegativeButton){
                negativeClicked()
            }
            if(targetFlags === FluContentDialogType.NeutralButton){
                neutralClicked()
            }
            if(targetFlags === FluContentDialogType.PositiveButton){
                positiveClicked()
            }
        }
    }
}
