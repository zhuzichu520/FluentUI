import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import FluentUI

Rectangle {
    property var columnSource
    property var dataSource
    id:control
    color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    onColumnSourceChanged: {
        if(columnSource.length!==0){
            var com_column = Qt.createComponent("FluTableModelColumn.qml")
            if (com_column.status === Component.Ready) {
                var columns= []
                var header_rows = {}
                columnSource.forEach(function(item){
                    var column = com_column.createObject(table_model,{display:item.dataIndex});
                    columns.push(column)
                    header_rows[item.dataIndex] = item.title
                })
                table_model.columns = columns
                header_model.columns = columns
                console.debug(JSON.stringify(header_rows))
                d.header_rows = [header_rows]
            }
        }
    }
    QtObject{
        id:d
        property var header_rows:[]
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
    Component{
        id:com_edit
        FluTextBox {
            anchors.fill: parent
            text: display
            verticalAlignment: TextInput.AlignVCenter
            Component.onCompleted: {
                forceActiveFocus()
                selectAll()
            }
            onCommit: {
                display = text
                tableView.closeEditor()
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
            selectionModel: ItemSelectionModel {
                id:selection_model
            }
            columnWidthProvider: function(column) {
                var w = columnSource[column].width
                if(column === item_loader.column){
                    item_loader.width = w
                }
                if(column === item_loader.column-1){
                    let cellItem = table_view.itemAtCell(item_loader.column, item_loader.row)
                    if(cellItem){
                        let cellPosition = cellItem.mapToItem(scroll_table, 0, 0)
                        item_loader.x = table_view.contentX + cellPosition.x
                    }
                }
                return w
            }
            rowHeightProvider: function(row) {
                var h = table_model.getRow(row).height
                if(row === item_loader.row){
                    item_loader.height = h
                }
                if(row === item_loader.row-1){
                    let cellItem = table_view.itemAtCell(item_loader.column, item_loader.row)
                    if(cellItem){
                        let cellPosition = cellItem.mapToItem(scroll_table, 0, 0)
                        item_loader.y = table_view.contentY + cellPosition.y
                    }
                }
                return h
            }
            model: table_model
            clip: true
            delegate: Rectangle {
                required property bool selected
                required property bool current
                color: selected ? FluTheme.primaryColor.lightest: (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
                implicitHeight: 40
                implicitWidth: columnSource[column].width
                TapHandler{
                    onDoubleTapped: {
                        item_loader.sourceComponent = obtEditDelegate(column,row)
                        var index = table_view.index(row,column)
                    }
                    onTapped: {
                        if(!current){
                            item_loader.sourceComponent = null
                        }
                    }
                }
                FluText {
                    text: display
                    anchors.fill: parent
                    anchors.margins: 10
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Loader{
            id:item_loader
            z:2
            property var display
            property int column
            property int row
            property var tableView: control
            onDisplayChanged: {
                table_model.setData(table_view.index(row,column),"display",display)
            }
        }
    }

    function obtEditDelegate(column,row){
        var display = table_model.data(table_view.index(row,column),"display")
        var cellItem = table_view.itemAtCell(column, row)
        var cellPosition = cellItem.mapToItem(scroll_table, 0, 0)
        item_loader.column = column
        item_loader.row = row
        item_loader.x = table_view.contentX + cellPosition.x
        item_loader.y = table_view.contentY + cellPosition.y
        item_loader.width = table_view.columnWidthProvider(column)
        item_loader.height = table_view.rowHeightProvider(row)
        item_loader.display = display
        var obj =columnSource[column].editDelegate
        if(obj){
            return obj
        }
        return com_edit
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
        target: {
            if(item_loader.sourceComponent){
                return null
            }
            return table_view
        }
        bottomRightHandle:com_handle
        topLeftHandle: com_handle
    }
    TableView {
        id: header_horizontal
        model: TableModel{
            id:header_model
            rows: d.header_rows
        }
        syncDirection: Qt.Horizontal
        anchors.left: scroll_table.left
        anchors.top: parent.top
        implicitWidth: syncView ? syncView.width : 0
        implicitHeight: Math.max(1, contentHeight)
        syncView: table_view
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        delegate: Rectangle {
            readonly property real cellPadding: 8
            readonly property var obj : columnSource[column]
            implicitWidth: column_text.implicitWidth + (cellPadding * 2)
            implicitHeight: Math.max(header_horizontal.height, column_text.implicitHeight + (cellPadding * 2))
            color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            FluText {
                id: column_text
                text: display
                width: parent.width
                height: parent.height
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            TapHandler{
                onDoubleTapped: {
                    selection_model.clear()
                    for(var i=0;i<=table_view.rows;i++){
                        selection_model.select(table_view.index(i,column),ItemSelectionModel.Select)
                    }
                }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: parent.height
                width: 4
                anchors.right: parent.right
                acceptedButtons: Qt.LeftButton
                visible: !(obj.width === obj.maximumWidth && obj.width === obj.maximumWidth)
                cursorShape: Qt.SplitHCursor
                preventStealing: true
                propagateComposedEvents: true
                onPressed :
                    (mouse)=>{
                        FluTools.setOverrideCursor(Qt.SplitHCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumWidth = obj.minimumWidth
                        var maximumWidth = obj.maximumWidth
                        if(!minimumWidth){
                            minimumWidth = 100
                        }
                        if(!maximumWidth){
                            maximumWidth = 65535
                        }
                        obj.width = Math.min(Math.max(minimumWidth, obj.width + delta.x),maximumWidth)
                        table_view.forceLayout()
                    }
            }
        }
    }
    TableView {
        id: header_vertical
        boundsBehavior: Flickable.StopAtBounds
        anchors.top: scroll_table.top
        anchors.left: parent.left
        implicitWidth: Math.max(1, contentWidth)
        implicitHeight: syncView ? syncView.height : 0
        syncDirection: Qt.Vertical
        syncView: table_view
        clip: true
        model: TableModel{
            TableModelColumn {}
            rows: {
                if(dataSource)
                    return dataSource
                return []
            }
        }
        delegate: Rectangle{
            readonly property real cellPadding: 8
            readonly property var obj : table_model.getRow(row)
            implicitWidth: Math.max(header_vertical.width, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
            color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            FluText{
                id:row_text
                anchors.centerIn: parent
                text: row + 1
            }
            TapHandler{
                onDoubleTapped: {
                    selection_model.clear()
                    for(var i=0;i<=columnSource.length;i++){
                        selection_model.select(table_view.index(row,i),ItemSelectionModel.Select)
                    }
                }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: 4
                width: parent.width
                anchors.bottom: parent.bottom
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.SplitVCursor
                preventStealing: true
                visible: !(obj.height === obj.minimumHeight && obj.width === obj.maximumHeight)
                propagateComposedEvents: true
                onPressed :
                    (mouse)=>{
                        FluTools.setOverrideCursor(Qt.SplitVCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = obj.minimumHeight
                        var maximumHeight = obj.maximumHeight
                        if(!minimumHeight){
                            minimumHeight = 40
                        }
                        if(!maximumHeight){
                            maximumHeight = 65535
                        }
                        obj.height = Math.min(Math.max(minimumHeight, obj.height + delta.y),maximumHeight)
                        table_model.setRow(row,obj)
                        table_view.forceLayout()
                    }
            }
        }
    }

    function closeEditor(){
        item_loader.sourceComponent = null
    }

}
