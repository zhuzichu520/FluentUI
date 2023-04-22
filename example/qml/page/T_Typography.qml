import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

FluContentPage {

    title: "Typography"
    property int textSize: FluTheme.textSize
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    Component.onCompleted: {
        slider.seek(0)
    }

    FluArea{
        anchors{
            top:parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 20
        }
        paddings: 10
        ColumnLayout{
            spacing: 0
            FluText{
                text:"Display"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.Display
            }
            FluText{
                text:"Title Large"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.TitleLarge
            }
            FluText{
                text:"Title"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.Title
            }
            FluText{
                text:"Subtitle"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.SubTitle
            }
            FluText{
                text:"Body Strong"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.BodyStrong
            }
            FluText{
                text:"Body"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.Body
            }
            FluText{
                text:"Caption"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.Caption
            }
        }

        FluSlider{
            id:slider
            vertical:true
            anchors{
                right: parent.right
                rightMargin: 45
                top: parent.top
                topMargin: 30
            }
            onValueChanged:{
                textSize = value/100*6+FluTheme.textSize
            }
        }

    }






}
