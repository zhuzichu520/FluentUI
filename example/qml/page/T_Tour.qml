import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Tour")

    FluTour{
        id:tour
        steps:[
            {title:qsTr("Upload File"),description: qsTr("Put your files here."),target:()=>btn_upload},
            {title:qsTr("Save"),description: qsTr("Save your changes."),target:()=>btn_save},
            {title:qsTr("Other Actions"),description: qsTr("Click to see other actions."),target:()=>btn_more}
        ]
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 130
        padding: 10

        FluFilledButton{
            anchors{
                top: parent.top
                topMargin: 14
            }
            text: qsTr("Begin Tour")
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
                id: btn_upload
                text: qsTr("Upload")
                onClicked: {
                    showInfo(qsTr("Upload"))
                }
            }
            FluFilledButton{
                id: btn_save
                text: qsTr("Save")
                onClicked: {
                    showInfo(qsTr("Save"))
                }
            }
            FluIconButton{
                id: btn_more
                iconSource: FluentIcons.More
                onClicked: {
                    showInfo(qsTr("More"))
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
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
