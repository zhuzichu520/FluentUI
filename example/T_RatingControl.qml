import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "./component"

FluScrollablePage{

    title:"RatingControl"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

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
