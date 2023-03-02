import QtQuick 2.15
import FluentUI 1.0

FluWindow {

    width: 500
    height: 600
    title:"关于"

    FluAppBar{
        id:appbar
        title:"关于"
    }

    FluText{
        text:"关于"
        fontStyle: FluText.Display
        anchors.centerIn: parent

        MouseArea{
            anchors.fill: parent
            onClicked: {

            }
        }

    }

}
