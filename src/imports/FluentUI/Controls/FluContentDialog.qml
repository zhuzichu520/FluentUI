import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
Popup {
    id: popup
    property string title: "Title"
    property string message: "Message"
    property string neutralText: "Neutral"
    property string negativeText: "Negative"
    property string positiveText: "Positive"
    property alias blurSource: blur.sourceItem
    property bool blurBackground: true
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
    modal:true
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    background:Item{}
    enter: Transition {
        reversible: true
        NumberAnimation {
            properties: "opacity"
            from:0
            to:1
            duration: 83
        }
    }
    exit:Transition {
        NumberAnimation {
            properties: "opacity"
            from:1
            to:0
            duration: 83
        }
    }
    contentItem:
        Rectangle {
        id:layout_content
        anchors.fill: parent
        implicitWidth:minWidth
        implicitHeight: text_title.height + text_message.height + layout_actions.height
        color: 'transparent'
        radius:5
        FluAcrylic{
            id:blur
            anchors{
                top:parent.top
                left: parent.left
                right: parent.right
                bottom: layout_actions.bottom
            }
            height: parent.height
            color: G.FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(249/255,249/255,249/255,1)
            rectX: popup.x
            rectY: popup.y
            acrylicOpacity:blurBackground ? 0.8 : 1
        }
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
            color: G.FluTheme.dark ? Qt.rgba(32/255,32/255,32/255, blurBackground ? blur.acrylicOpacity - 0.4 : 1) : Qt.rgba(243/255,243/255,243/255,blurBackground ? blur.acrylicOpacity - 0.4 : 1)
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
                        neutralClicked()
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
                        negativeClicked()
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
                        positiveClicked()
                    }
                }
            }
        }
    }
}
