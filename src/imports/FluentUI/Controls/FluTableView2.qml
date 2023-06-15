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
    color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
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

    Component{
        id:com_edit
        FluTextBox {
            anchors.fill: parent
            text: display
            verticalAlignment: TextInput.AlignVCenter
            Component.onCompleted: selectAll()
            TableView.onCommit: {
                display = text
            }
        }
    }

    ScrollView{
        id:scroll_table
        anchors.left: header_vertical.right
        anchors.top: header_horizontal.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        TableView {
            id:table_view
            ListModel{
                id:model_columns
            }
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.horizontal: FluScrollBar{}
            ScrollBar.vertical: FluScrollBar{}
            selectionModel: ItemSelectionModel {}
            columnWidthProvider: function(column) {
                let w = explicitColumnWidth(column)
                if (w >= 0){
                    return Math.max(100, w)
                }
                return implicitColumnWidth(column)
            }
            rowHeightProvider: function(row) {
                let h = explicitRowHeight(row)
                if (h >= 0){
                    return Math.max(40, h)
                }
                return implicitRowHeight(row)
            }
            model: table_model
            clip: true
            delegate: Rectangle {
                required property bool selected
                required property bool current
                color: selected ? FluTheme.primaryColor.lightest: (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
                implicitHeight: 40
                implicitWidth: columnSource[column].width
                FluText {
                    text: display
                    anchors.fill: parent
                    anchors.margins: 10
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                TableView.editDelegate: {
                    var obj =columnSource[column].editDelegate
                    if(obj){
                        return obj
                    }
                    return com_edit
                }
            }
        }
    }

    Component{
        id:com_handle
        FluControl {
            width: 24
            height: 24
            background: Rectangle{
                radius: 12
                color: FluTheme.dark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
            }
            visible: SelectionRectangle.control.active
            FluShadow{
                radius: 12
            }
            Rectangle{
                width: 24
                height: 24
                radius: 12
                scale: pressed?4/10:hovered?6/10:5/10
                color:FluTheme.dark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
                anchors.centerIn: parent
                Behavior on scale {
                    NumberAnimation{
                        duration: 167
                    }
                }
            }
        }
    }

    SelectionRectangle {
        target: table_view
        bottomRightHandle:com_handle
        topLeftHandle: com_handle
    }


    FluHorizontalHeaderView {
        id: header_horizontal
        textRole: "title"
        model: columnSource
        anchors.left: scroll_table.left
        anchors.top: parent.top
        syncView: table_view
        boundsBehavior: Flickable.StopAtBounds
        clip: true
    }

    FluVerticalHeaderView {
        id: header_vertical
        boundsBehavior: Flickable.StopAtBounds
        anchors.top: scroll_table.top
        anchors.left: parent.left
        syncView: table_view
        clip: true
    }


}

