import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "../component"
import FluentUI 1.0

FluScrollablePage{

    title:"Slider"

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        FluSlider{
            value: 50
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
            value: 50
            vertical:true
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluSlider{
    vertical:true
    value:50
}'
    }


}
