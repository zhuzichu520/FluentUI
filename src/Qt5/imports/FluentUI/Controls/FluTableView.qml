import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import FluentUI 1.0

Rectangle {
    property var columnSource
    property var dataSource
    property color selectionColor: FluTools.colorAlpha(FluTheme.primaryColor.lightest,0.6)
    property color hoverButtonColor: FluTools.colorAlpha(selectionColor,0.2)
    property color pressedButtonColor: FluTools.colorAlpha(selectionColor,0.4)
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
        property int defaultItemWidth: 100
        property int defaultItemHeight: 42
        property var header_rows:[]
        property bool selectionFlag: true
        function obtEditDelegate(column,row,cellItem){
            var display = table_model.data(table_model.index(row,column),"display")
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
            if(columnSource[column].editMultiline === true){
                return com_edit_multiline
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
        FluTextBox{
            id:text_box
            text: display
            readOnly: true === columnSource[column].readOnly
            Component.onCompleted: {
                forceActiveFocus()
                selectAll()
            }
            onCommit: {
                if(!readOnly){
                    display = text_box.text
                }
                tableView.closeEditor()
            }
        }
    }
    Component{
        id:com_edit_multiline
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
            leftPadding: 11
            rightPadding: 11
            topPadding: 6
            bottomPadding: 6
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
            ScrollBar.horizontal: FluScrollBar{
                id:scroll_bar_h
            }
            ScrollBar.vertical: FluScrollBar{
                id:scroll_bar_v
            }
            columnWidthProvider: function(column) {
                var w = columnSource[column].width
                if(!w){
                    w = columnSource[column].minimumWidth
                }
                if(!w){
                    w = d.defaultItemWidth
                }
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
                if(row>=table_model.rowCount){
                    return 0
                }
                var h = table_model.getRow(row).height
                if(!h){
                    h = table_model.getRow(row).minimumHeight
                }
                if(!h){
                    return d.defaultItemHeight
                }
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
                property point position: Qt.point(column,row)
                color: (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06))
                implicitHeight: 40
                implicitWidth: {
                    var w = columnSource[column].width
                    if(!w){
                        w = columnSource[column].minimumWidth
                    }
                    if(!w){
                        w = d.defaultItemWidth
                    }
                    return w
                }
                Rectangle{
                    anchors.fill: parent
                    visible: !item_loader.sourceComponent
                    color: "#00000000"
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed:{
                        closeEditor()
                    }
                    onCanceled: {
                    }
                    onReleased: {
                    }
                    onDoubleClicked:{
                        if(display instanceof Component){
                            return
                        }
                        item_loader.sourceComponent = d.obtEditDelegate(column,row,item_table)
                    }
                    onClicked:
                        (event)=>{
                            item_loader.sourceComponent = undefined
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
            sourceComponent: undefined
            onDisplayChanged: {
                var obj = table_model.getRow(row)
                obj[columnSource[column].dataIndex] = display
                table_model.setRow(row,obj)
            }
        }
    }
    Component{
        id:com_handle
        Item {}
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
            id:column_item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            readonly property var obj : columnSource[column]
            implicitWidth: column_text.implicitWidth + (cellPadding * 2)
            implicitHeight: Math.max(36, column_text.implicitHeight + (cellPadding * 2))
            color:{
                d.selectionFlag
                if(column_item_control_mouse.pressed){
                    return control.pressedButtonColor
                }
                return column_item_control_mouse.containsMouse&&!canceled ? control.hoverButtonColor :  FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            }
            border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            FluText {
                id: column_text
                text: model.display
                width: parent.width
                height: parent.height
                font.bold:{
                    d.selectionFlag
                    return true
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                id:column_item_control_mouse
                anchors.fill: parent
                anchors.rightMargin: 6
                hoverEnabled: true
                onCanceled: {
                    column_item_control.canceled = true
                }
                onContainsMouseChanged: {
                    if(!containsMouse){
                        column_item_control.canceled = false
                    }
                }
                onClicked:
                    (event)=>{
                        closeEditor()
                        d.selectionFlag = !d.selectionFlag
                    }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: parent.height
                width: 6
                anchors.right: parent.right
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                visible: !(obj.width === obj.minimumWidth && obj.width === obj.maximumWidth && obj.width)
                cursorShape: Qt.SplitHCursor
                onPressed :
                    (mouse)=>{
                        header_horizontal.interactive = false
                        FluTools.setOverrideCursor(Qt.SplitHCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    header_horizontal.interactive = true
                    FluTools.restoreOverrideCursor()
                }
                onCanceled: {
                    header_horizontal.interactive = true
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        if(!pressed){
                            return
                        }
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumWidth = obj.minimumWidth
                        var maximumWidth = obj.maximumWidth
                        var w = obj.width
                        if(!w){
                            w = d.defaultItemWidth
                        }
                        if(!minimumWidth){
                            minimumWidth = d.defaultItemWidth
                        }
                        if(!maximumWidth){
                            maximumWidth = 65535
                        }
                        obj.width = Math.min(Math.max(minimumWidth, w + delta.x),maximumWidth)
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
            id:item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            implicitWidth: Math.max(30, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
            color: {
                d.selectionFlag
                if(item_control_mouse.pressed){
                    return control.pressedButtonColor
                }
                return item_control_mouse.containsMouse&&!canceled ? control.hoverButtonColor :  FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            }
            border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
            FluText{
                id:row_text
                anchors.centerIn: parent
                text: row + 1
                font.bold:{
                    d.selectionFlag
                    return true
                }
            }
            MouseArea{
                id:item_control_mouse
                anchors.fill: parent
                anchors.bottomMargin: 6
                hoverEnabled: true
                onCanceled: {
                    item_control.canceled = true
                }
                onContainsMouseChanged: {
                    if(!containsMouse){
                        item_control.canceled = false
                    }
                }
                onClicked:
                    (event)=>{
                        closeEditor()
                        d.selectionFlag = !d.selectionFlag
                    }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: 6
                width: parent.width
                anchors.bottom: parent.bottom
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.SplitVCursor
                visible: {
                    var obj = table_model.getRow(row)
                    return !(obj.height === obj.minimumHeight && obj.height === obj.maximumHeight && obj.height)
                }
                onPressed :
                    (mouse)=>{
                        header_vertical.interactive = false
                        FluTools.setOverrideCursor(Qt.SplitVCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    header_vertical.interactive = true
                    FluTools.restoreOverrideCursor()
                }
                onCanceled: {
                    header_vertical.interactive = true
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        if(!pressed){
                            return
                        }
                        var obj = table_model.getRow(row)
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = obj.minimumHeight
                        var maximumHeight = obj.maximumHeight
                        var h = obj.height
                        if(!h){
                            h = d.defaultItemHeight
                        }
                        if(!minimumHeight){
                            minimumHeight = d.defaultItemHeight
                        }
                        if(!maximumHeight){
                            maximumHeight = 65535
                        }
                        obj.height = Math.min(Math.max(minimumHeight, h + delta.y),maximumHeight)
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
        scroll_bar_h.position = 0
        scroll_bar_v.position = 0
    }
}
