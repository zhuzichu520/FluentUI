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
        Layout.preferredHeight: 200
        Layout.topMargin: 20
        paddings: 10

        Row{
            spacing: 30
            FluSlider{
            }
            FluSlider{
                orientation: Qt.Vertical
                anchors.verticalCenter: parent.verticalCenter
            }
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
        Layout.preferredHeight: 200
        Layout.topMargin: 20
        paddings: 10
        Row{
            spacing: 30
            FluRangeSlider{
            }
            FluRangeSlider{
                orientation: Qt.Vertical
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluRangeSlider{
    orientation: Qt.Vertical
}'
    }
}
