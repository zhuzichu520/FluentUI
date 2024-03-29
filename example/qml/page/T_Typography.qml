import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {

    property real textScale: 1

    title: qsTr("Typography")
    rightPadding: 10

    FluFrame{
        anchors{
            top:parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        padding: 10
        ColumnLayout{
            spacing: 0
            scale: textScale
            transformOrigin: Item.TopLeft
            FluText{
                id:text_Display
                text:"Display"
                padding: 0
                font: FluTextStyle.Display
            }
            FluText{
                id:text_TitleLarge
                text:"Title Large"
                padding: 0
                font: FluTextStyle.TitleLarge
            }
            FluText{
                id:text_Title
                text:"Title"
                padding: 0
                font: FluTextStyle.Title
            }
            FluText{
                id:text_Subtitle
                text:"Subtitle"
                padding: 0
                font: FluTextStyle.Subtitle
            }
            FluText{
                id:text_BodyStrong
                text:"Body Strong"
                padding: 0
                font: FluTextStyle.BodyStrong
            }
            FluText{
                id:text_Body
                text:"Body"
                padding: 0
                font: FluTextStyle.Body
            }
            FluText{
                id:text_Caption
                text:"Caption"
                padding: 0
                font: FluTextStyle.Caption
            }
        }

        FluSlider{
            id:slider
            orientation: Qt.Vertical
            anchors{
                right: parent.right
                rightMargin: 45
                top: parent.top
                topMargin: 30
            }
            onValueChanged:{
                textScale = 1+value/100
            }
        }
    }
}
