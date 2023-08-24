import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Tour"

    FluTour{
        id:tour
        steps:[
            {title:"Upload File",description: "Put your files here.",target:()=>btn_upload},
            {title:"Save",description: "Save your changes.",target:()=>btn_save},
            {title:"Other Actions",description: "Click to see other actions.",target:()=>btn_more}
        ]
    }

    FluArea{
        Layout.fillWidth: true
        height: 130
        paddings: 10
        Layout.topMargin: 20

        FluFilledButton{
            anchors{
                top: parent.top
                topMargin: 14
            }
            text:"Begin Tour"
            onClicked: {
                tour.open()
            }
        }

        Row{
            spacing: 20
            anchors{
                top: parent.top
                topMargin: 60
            }
            FluButton{
                id:btn_upload
                text:"Upload"
                onClicked: {
                    showInfo("Upload")
                }
            }
            FluFilledButton{
                id:btn_save
                text:"Save"
                onClicked: {
                    showInfo("Save")
                }
            }
            FluIconButton{
                id:btn_more
                iconSource: FluentIcons.More
                onClicked: {
                    showInfo("More")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTour{
    id:tour
    steps:[
        {title:"Upload File",description: "Put your files here.",target:()=>btn_upload},
        {title:"Save",description: "Save your changes.",target:()=>btn_save},
        {title:"Other Actions",description: "Click to see other actions.",target:()=>btn_more}
    ]
}'
    }

}
