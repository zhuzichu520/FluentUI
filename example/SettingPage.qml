import QtQuick 2.15
import FluentUI 1.0

FluWindow {

    width: 500
    height: 600
    title:"设置"

    FluAppBar{
        id:appbar
        title:"设置"
    }

    FluText{
        text:"设置"
        fontStyle: FluText.Display
        anchors.centerIn: parent

        MouseArea{
            anchors.fill: parent
            onClicked: {
                FluApp.navigate("/About")
            }
        }

    }

}
