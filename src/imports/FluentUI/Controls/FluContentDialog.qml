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
    property int delayTime: 100
    signal neutralClicked
    signal negativeClicked
    signal positiveClicked
    enum ButtonFlag{
        NegativeButton=1
        ,NeutralButton=2
        ,PositiveButton=4
    }
    property int buttonFlags: FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
    property var minWidth: {
        if(Window.window==null)
            return 400
        return  Math.min(Window.window.width,400)
    }
    focus: true
    Rectangle {
        id:layout_content
        anchors.fill: parent
        implicitWidth:minWidth
        implicitHeight: text_title.height + text_message.height + layout_actions.height
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
        FluText{
            id:text_message
            font: FluTextStyle.Body
            wrapMode: Text.WrapAnywhere
            text:message
            topPadding: 14
            leftPadding: 20
            rightPadding: 20
            bottomPadding: 14
            anchors{
                top:text_title.bottom
                left: parent.left
                right: parent.right
            }
        }
        Rectangle{
            id:layout_actions
            height: 68
            radius: 5
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255, blurBackground ? blurOpacity - 0.4 : 1) : Qt.rgba(243/255,243/255,243/255,blurBackground ? blurOpacity - 0.4 : 1)
            anchors{
                top:text_message.bottom
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
                    visible: popup.buttonFlags&FluContentDialog.NeutralButton
                    text: neutralText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialog.NeutralButton
                        timer_delay.restart()
                    }
                }
                FluButton{
                    id:negative_btn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: popup.buttonFlags&FluContentDialog.NegativeButton
                    text: negativeText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialog.NegativeButton
                        timer_delay.restart()
                    }
                }
                FluFilledButton{
                    id:positive_btn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: popup.buttonFlags&FluContentDialog.PositiveButton
                    text: positiveText
                    onClicked: {
                        popup.close()
                        timer_delay.targetFlags = FluContentDialog.PositiveButton
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
            if(targetFlags === FluContentDialog.NegativeButton){
                negativeClicked()
            }
            if(targetFlags === FluContentDialog.NeutralButton){
                neutralClicked()
            }
            if(targetFlags === FluContentDialog.PositiveButton){
                positiveClicked()
            }
        }
    }
}
