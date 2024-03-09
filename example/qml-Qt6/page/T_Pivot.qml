import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("Pivot")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 400
        paddings: 10



        FluPivot{
            anchors.fill: parent
            currentIndex: 2

            FluPivotItem{
                title: qsTr("All")
                contentItem:FluText{
                    text: qsTr("All emails go here.")
                }
            }
            FluPivotItem{
                title: qsTr("Unread")
                contentItem: FluText{
                    text: qsTr("Unread emails go here.")
                }
            }
            FluPivotItem{
                title: qsTr("Flagged")
                contentItem: FluText{
                    text: qsTr("Flagged emails go here.")
                }
            }
            FluPivotItem{
                title: qsTr("Urgent")
                contentItem: FluText{
                    text: qsTr("Urgent emails go here.")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluPivot{
    anchors.fill: parent
    FluPivotItem:{
        text: qsTr("All")
        contentItem: FluText{
            text: qsTr("All emails go here.")
        }
    }
    FluPivotItem:{
        text: qsTr("Unread")
        contentItem: FluText{
            text: qsTr("Unread emails go here.")
        }
    }
    FluPivotItem:{
        text: qsTr("Flagged")
        contentItem: FluText{
            text: qsTr("Flagged emails go here.")
        }
    }
    FluPivotItem:{
        text: qsTr("Urgent")
        contentItem: FluText{
            text: qsTr("Urgent emails go here.")
        }
    }
}
'
    }
}
