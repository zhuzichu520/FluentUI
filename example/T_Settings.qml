import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///global/"
import "./component"

FluScrollablePage{

    title:"Settings"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 168
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            FluText{
                text:"NavigationView Display Mode"
                fontStyle: FluText.BodyStrong
                Layout.bottomMargin: 4
            }

            Repeater{
                id:repeater
                model: [{title:"Open",mode:FluNavigationView.Open},{title:"Compact",mode:FluNavigationView.Compact},{title:"Minimal",mode:FluNavigationView.Minimal},{title:"Auto",mode:FluNavigationView.Auto}]
                delegate:  FluRadioButton{
                    selected : MainEvent.displayMode===modelData.mode
                    text:modelData.title
                    onClicked:{
                       MainEvent.displayMode = modelData.mode
                    }
                }
            }
        }

    }
}
