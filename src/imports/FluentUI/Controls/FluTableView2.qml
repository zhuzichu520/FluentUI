import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import FluentUI

TableView {
    property var columnSource
    property var dataSource
    id:control
    ListModel{
        id:model_columns
    }
    columnWidthProvider: function (column) {
        return 100
    }
    rowHeightProvider: function (column) {
        return 60
    }
    topMargin: columnsHeader.implicitHeight
    model: table_model
    ScrollBar.horizontal: FluScrollBar{}
    ScrollBar.vertical: FluScrollBar{}
    clip: true
    boundsBehavior:Flickable.StopAtBounds
    delegate: Rectangle {
        color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
        FluText {
            text: display
            anchors.fill: parent
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
        }
    }

    onColumnSourceChanged: {
        if(columnSource.length!==0){
            var com_column = Qt.createComponent("FluTableModelColumn.qml")
            if (com_column.status === Component.Ready) {
                var columns= []
                columnSource.forEach(function(item){
                    var column = com_column.createObject(table_model,{display:item.dataIndex});
                    columns.push(column)
                })
                table_model.columns = columns
            }
        }
    }

    onDataSourceChanged: {
        table_model.clear()
        dataSource.forEach(function(item){
            table_model.appendRow(item)
        })
    }

    TableModel {
        id:table_model
    }

    Row {
        id: columnsHeader
        y: control.contentY
        z: 2
        Repeater {
            model: columnSource
            Rectangle{
                height: 35
                width: control.columnWidthProvider(index)
                color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
                FluText {
                    text: modelData.title
                    font: FluTextStyle.BodyStrong
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                }
            }
        }
    }
}
