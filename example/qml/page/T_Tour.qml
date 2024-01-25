import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

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
