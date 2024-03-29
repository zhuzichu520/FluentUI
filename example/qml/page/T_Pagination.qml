import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "../component"
import FluentUI 1.0

FluScrollablePage{

    title: qsTr("Pagination")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        padding: 10
        ColumnLayout{
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter
            FluPagination{
                pageCurrent: 1
                pageButtonCount: 5
                itemCount: 5000
            }
            FluPagination{
                pageCurrent: 2
                itemCount: 5000
                pageButtonCount: 7
            }
            FluPagination{
                pageCurrent: 3
                itemCount: 5000
                pageButtonCount: 9
            }
        }

    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluPagination{
    pageCurrent: 1
    itemCount: 1000
    pageButtonCount: 9
}'
    }


}
