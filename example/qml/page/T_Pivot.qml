import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Pivot")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 400
        padding: 10

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
        Layout.topMargin: -6
        code:'FluPivot{
    anchors.fill: parent
    FluPivotItem {
        title: qsTr("All")
        contentItem: FluText{
            text: qsTr("All emails go here.")
        }
    }
    FluPivotItem {
        title: qsTr("Unread")
        contentItem: FluText{
            text: qsTr("Unread emails go here.")
        }
    }
    FluPivotItem {
        title: qsTr("Flagged")
        contentItem: FluText{
            text: qsTr("Flagged emails go here.")
        }
    }
    FluPivotItem {
        title: qsTr("Urgent")
        contentItem: FluText{
            text: qsTr("Urgent emails go here.")
        }
    }
}
'
    }
}
