import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"Theme"
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
            FluText{
                text:"Display"
                fontStyle: FluText.Display
            }
            FluText{
                text:"Title Large"
                fontStyle: FluText.TitleLarge
            }
            FluText{
                text:"Title"
                fontStyle: FluText.Title
            }
            FluText{
                text:"Subtitle"
                fontStyle: FluText.Subtitle
            }
            FluText{
                text:"Body Large"
                fontStyle: FluText.BodyLarge
            }
            FluText{
                text:"Body Strong"
                fontStyle: FluText.BodyStrong
            }
            FluText{
                text:"Body"
                fontStyle: FluText.Body
            }
            FluText{
                text:"Caption"
                fontStyle: FluText.Caption
            }
        }
    }
}
