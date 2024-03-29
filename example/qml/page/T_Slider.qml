import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Slider")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        padding: 10

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
        Layout.topMargin: -6
        code:'FluSlider{
    value:50
}'
    }


    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        Layout.topMargin: 20
        padding: 10
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
        Layout.topMargin: -6
        code:'FluRangeSlider{
    orientation: Qt.Vertical
}'
    }
}

