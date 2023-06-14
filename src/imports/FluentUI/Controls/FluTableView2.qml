import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import FluentUI


Rectangle {

    id:control



    property var columnSource
    property var dataSource
    color: Qt.styleHints.appearance === Qt.Light ? palette.mid : palette.midlight
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

    TableModel {
        id:table_model
    }

    onDataSourceChanged: {
        table_model.clear()
        dataSource.forEach(function(item){
            table_model.appendRow(item)
        })
    }

    TableView {
        id:table_view
        anchors.left: header_vertical.right
        anchors.top: header_horizontal.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        ListModel{
            id:model_columns
        }
        columnWidthProvider: function(column) {
            let w = explicitColumnWidth(column)
            if (w >= 100)
                return Math.max(100, w);;
            return implicitColumnWidth(column)
        }
        rowHeightProvider: function(row) {
            let h = explicitRowHeight(row)
            if (h >= 0)
                return Math.max(60, h);
            return implicitRowHeight(row)
        }

        model: table_model
        ScrollBar.horizontal: FluScrollBar{}
        ScrollBar.vertical: FluScrollBar{}
        clip: true
        delegate: Rectangle {
            implicitHeight: 60
            implicitWidth: columnSource[column].width
            color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
            FluText {
                text: display
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
            }
        }
    }


    HorizontalHeaderView {
        id: header_horizontal
        anchors.left: table_view.left
        anchors.top: parent.top
        syncView: table_view
        clip: true
    }

    VerticalHeaderView {
        id: header_vertical
        anchors.top: table_view.top
        anchors.left: parent.left
        syncView: table_view
        clip: true
    }



}

