import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import "qrc:///example/qml/component"
import FluentUI

FluScrollablePage{

    title:"Slider"

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        FluSlider{
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluSlider{
    value:50
}'
    }


    FluArea{
        Layout.fillWidth: true
        height: 200
        paddings: 10
        Layout.topMargin: 20
        FluSlider{
            orientation: Qt.Vertical
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluSlider{
    orientation: Qt.Vertical
    value:50
}'
    }


}
