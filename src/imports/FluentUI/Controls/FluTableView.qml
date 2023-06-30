import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import FluentUI

Rectangle {
    property var columnSource
    property var dataSource
    property color selectionColor: Qt.alpha(FluTheme.primaryColor.lightest,0.6)
    property color hoverButtonColor: Qt.alpha(selectionColor,0.2)
    property color pressedButtonColor: Qt.alpha(selectionColor,0.4)

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
                d.header_rows = [header_rows]
            }
        }
    }
    QtObject{
        id:d
        property var header_rows:[]
        property bool selectionFlag: true
        function obtEditDelegate(column,row){
            var display = table_model.data(table_model.index(row,column),"display")
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
        Item{
            anchors.fill: parent
            ScrollView{
                id:item_scroll
                clip: true
                anchors.fill: parent
                ScrollBar.vertical: FluScrollBar{
                    parent: item_scroll
                    x: item_scroll.mirrored ? 0 : item_scroll.width - width
                    y: item_scroll.topPadding
                    height: item_scroll.availableHeight
                    active: item_scroll.ScrollBar.horizontal.active
                }
                FluMultilineTextBox {
                    id:text_box
                    text: display
                    readOnly: true === columnSource[column].readOnly
                    verticalAlignment: TextInput.AlignVCenter
                    Component.onCompleted: {
                        forceActiveFocus()
                        selectAll()
                    }
                    rightPadding: 24
                    onCommit: {
                        if(!readOnly){
                            display = text
                        }
                        tableView.closeEditor()
                    }
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeClose
                iconSize: 10
                width: 20
                height: 20
                visible: {
                    if(text_box.readOnly)
                        return false
                    return text_box.text !== ""
                }
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 5
                }
                onClicked:{
                    text_box.text = ""
                }
            }
        }
    }
    Component{
        id:com_text
        FluText {
            id:item_text
            text: itemData
            anchors.fill: parent
            anchors.margins: 10
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            verticalAlignment: Text.AlignVCenter
            HoverHandler{
                id: hover_handler
            }
            FluTooltip{
                text: item_text.text
                delay: 500
                visible: item_text.contentWidth < item_text.implicitWidth && item_text.contentHeight < item_text.implicitHeight &&  hover_handler.hovered
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
                model: table_model
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
                id:item_table
                property var position: Qt.point(column,row)
                required property bool selected
                //                onSelectedChanged: {
                //                    d.selectionFlag = !d.selectionFlag
                //                }
                color: (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
                implicitHeight: 40
                implicitWidth: columnSource[column].width
                Rectangle{
                    anchors.fill: parent
                    visible: item_loader.sourceComponent == null
                    color: selected ? control.selectionColor : "#00000000"
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed:{
                        closeEditor()
                        table_view.interactive = false
                    }
                    onReleased: {
                        table_view.interactive = true
                    }
                    onDoubleClicked:{
                        if(display instanceof Component){
                            return
                        }
                        item_loader.sourceComponent = d.obtEditDelegate(column,row)
                    }
                    onClicked:
                        (event)=>{
                            item_loader.sourceComponent = null
                            if(!(event.modifiers & Qt.ControlModifier)){
                                selection_model.clear()
                            }
                            selection_model.select(table_model.index(row,column),ItemSelectionModel.Select)
                            d.selectionFlag = !d.selectionFlag
                            event.accepted = true
                        }
                }
                Loader{
                    property var itemData: display
                    property var tableView: table_view
                    property var tableModel: table_model
                    property var position: item_table.position
                    property int row: position.y
                    property int column: position.x
                    anchors.fill: parent
                    sourceComponent: {
                        if(itemData instanceof Component){
                            return itemData
                        }
                        return com_text
                    }
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
            sourceComponent: null
            onDisplayChanged: {
                var obj = table_model.getRow(row)
                obj[columnSource[column].dataIndex] = display
                table_model.setRow(row,obj)
            }
        }
    }
    Component{
        id:com_handle
        Item {
            onYChanged: {
                d.selectionFlag = !d.selectionFlag
            }
            onXChanged: {
                d.selectionFlag = !d.selectionFlag
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
        onDraggingChanged: {
            if(!dragging){
                table_view.interactive = true
            }
        }
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
        delegate: FluControl {
            id:column_item_control
            readonly property real cellPadding: 8
            readonly property var obj : columnSource[column]
            implicitWidth: column_text.implicitWidth + (cellPadding * 2)
            implicitHeight: Math.max(header_horizontal.height, column_text.implicitHeight + (cellPadding * 2))
            Rectangle{
                anchors.fill: parent
                color:{
                    d.selectionFlag
                    if(column_item_control.pressed){
                        return control.pressedButtonColor
                    }
                    if(selection_model.isColumnSelected(column)){
                        return control.hoverButtonColor
                    }
                    return column_item_control.hovered ? control.hoverButtonColor :  FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
                }
                border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            }
            FluText {
                id: column_text
                text: model.display
                width: parent.width
                height: parent.height
                font.bold:{
                    d.selectionFlag
                    return selection_model.columnIntersectsSelection(column)
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                closeEditor()
                selection_model.clear()
                for(var i=0;i<=table_view.rows;i++){
                    selection_model.select(table_model.index(i,column),ItemSelectionModel.Select)
                }
                d.selectionFlag = !d.selectionFlag
            }
            MouseArea{
                property point clickPos: "0,0"
                height: parent.height
                width: 6
                anchors.right: parent.right
                acceptedButtons: Qt.LeftButton
                visible: !(obj.width === obj.minimumWidth && obj.width === obj.maximumWidth)
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
        delegate: FluControl{
            id:item_control
            readonly property real cellPadding: 8
            implicitWidth: Math.max(header_vertical.width, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
            Rectangle{
                anchors.fill: parent
                color: {
                    d.selectionFlag
                    if(item_control.pressed){
                        return control.pressedButtonColor
                    }
                    if(selection_model.isRowSelected(row)){
                        return control.hoverButtonColor
                    }
                    return item_control.hovered ? control.hoverButtonColor :  FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
                }
                border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            }
            FluText{
                id:row_text
                anchors.centerIn: parent
                text: row + 1
                font.bold:{
                    d.selectionFlag
                    return selection_model.rowIntersectsSelection(row)
                }
            }
            onClicked: {
                closeEditor()
                selection_model.clear()
                for(var i=0;i<=columnSource.length;i++){
                    selection_model.select(table_model.index(row,i),ItemSelectionModel.Select)
                }
                d.selectionFlag = !d.selectionFlag
            }
            MouseArea{
                property point clickPos: "0,0"
                height: 6
                width: parent.width
                anchors.bottom: parent.bottom
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.SplitVCursor
                preventStealing: true
                visible: {
                    var obj = table_model.getRow(row)
                    return !(obj.height === obj.minimumHeight && obj.width === obj.maximumHeight)
                }
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
                        var obj = table_model.getRow(row)
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = obj.minimumHeight
                        var maximumHeight = obj.maximumHeight
                        if(!minimumHeight){
                            minimumHeight = 46
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
    function resetPosition(){
        table_view.positionViewAtCell(Qt.point(0, 0),Qt.AlignTop|Qt.AlignLeft)
    }
}
