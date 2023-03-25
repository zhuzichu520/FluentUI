import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

FluContentPage {

    title: "Typography"
    property int textSize: 13

    Component.onCompleted: {
        slider.seek(31)
    }

    ScrollView{
        clip: true
        width: parent.width
        contentWidth: parent.width
        ColumnLayout{
            spacing: 0
            FluText{
                text:"Display"
                Layout.topMargin: 20
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
                fontStyle: FluText.Subtitle
            }
            FluText{
                text:"Body Large"
                padding: 0
                pixelSize: textSize
                fontStyle: FluText.BodyLarge
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
    }


    FluSlider{
        id:slider
        orientation:FluSlider.Vertical
        anchors{
            right: parent.right
            rightMargin: 30
            top: parent.top
            topMargin: 30
        }
        onValueChanged:{
            textSize = value/100*16+8
        }
    }

}
