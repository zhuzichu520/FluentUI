import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("RatingControl")

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10

        Column {
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            FluRatingControl {}
            FluRatingControl {
                number: 10
            }
        }
    }

    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluRatingControl{

}'
    }
}
