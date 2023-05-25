import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title:"RatingControl"

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20

        Column{
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            FluRatingControl{

            }
            FluRatingControl{
                number:10
            }
        }

    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluRatingControl{

}'
    }


}
