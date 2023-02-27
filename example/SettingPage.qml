import QtQuick 2.15
import FluentUI 1.0

FluWindow {

    width: 500
    height: 500

    FluAppBar{
        id:appbar
    }

    FluText{
        text:"Display"
        fontStyle: FluText.Display
        anchors.centerIn: parent

    }

}
