import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

FluScrollablePage{

    title:"Pivot"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 400
        paddings: 10



        FluPivot{
            anchors.fill: parent
            currentIndex: 2

            FluPivotItem{
                title:"All"
                contentItem:FluText{
                    text:"All emails go here."
                }
            }
            FluPivotItem{
                title:"Unread"
                contentItem:FluText{
                    text:"Unread emails go here."
                }
            }
            FluPivotItem{
                title:"Flagged"
                contentItem:FluText{
                    text:"Flagged emails go here."
                }
            }
            FluPivotItem{
                title:"Urgent"
                contentItem:FluText{
                    text:"Urgent emails go here."
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
        text:"All"
        contentItem: FluText{
            text:"All emails go here."
        }
    }
    FluPivotItem:{
        text:"Unread"
        contentItem: FluText{
            text:"Unread emails go here."
        }
    }
    FluPivotItem:{
        text:"Flagged"
        contentItem: FluText{
            text:"Flagged emails go here."
        }
    }
    FluPivotItem:{
        text:"Urgent"
        contentItem: FluText{
            text:"Urgent emails go here."
        }
    }
}
'
    }
}
