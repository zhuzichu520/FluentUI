import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import FluentUI 1.0

Rectangle {
    property var columnSource
    property var dataSource
    property color borderColor: FluTheme.dark ? "#252525" : "#e4e4e4"
    property alias tableModel: table_model
    property alias tableView: table_view
    property bool horizonalHeaderVisible: true
    property bool verticalHeaderVisible: true
    id:control
    color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    onColumnSourceChanged: {
        if(columnSource.length!==0){
            var columns= []
            var header_rows = {}
            columnSource.forEach(function(item){
                var column = Qt.createQmlObject('import Qt.labs.qmlmodels 1.0;TableModelColumn{}',table_model);
                column.display = item.dataIndex
                columns.push(column)
                header_rows[item.dataIndex] = item.title
            })
            table_model.columns = columns
            header_model.columns = columns
            d.header_rows = [header_rows]
        }
    }
    QtObject{
        id:d
        property var currentIndex
        property int rowHoverIndex: -1
        property int defaultItemWidth: 100
        property int defaultItemHeight: 42
        property var header_rows:[]
        function obtEditDelegate(column,row,cellItem){
            var display = table_model.data(table_model.index(row,column),"display")
            var cellPosition = cellItem.mapToItem(scroll_table, 0, 0)
            item_loader.column = column
            item_loader.row = row
            item_loader_layout.cellItem = cellItem
            item_loader_layout.x = table_view.contentX + cellPosition.x
            item_loader_layout.y = table_view.contentY + cellPosition.y
            item_loader_layout.width = table_view.columnWidthProvider(column)
            item_loader_layout.height = table_view.rowHeightProvider(row)
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
        var rows = []
        for(var i =0;i<dataSource.length;i++){
            var row = dataSource[i]
            row.__index= i
            rows.push(row)
        }
        table_model.rows = rows
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
            text: modelData
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            anchors{
                fill: parent
                leftMargin: 11
                rightMargin: 11
                topMargin: 6
                bottomMargin: 6
            }
            verticalAlignment: Text.AlignVCenter
            MouseArea{
                acceptedButtons: Qt.NoButton
                id: hover_handler
                hoverEnabled: true
                anchors.fill: parent
            }
            FluTooltip{
                text: item_text.text
                delay: 500
                visible: item_text.contentWidth < item_text.implicitWidth && item_text.contentHeight < item_text.implicitHeight &&  hover_handler.containsMouse
            }
        }
    }

    MouseArea{
        id:scroll_table
        hoverEnabled: true
        anchors.left: header_vertical.right
        anchors.top: header_horizontal.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onExited: {
            d.rowHoverIndex = -1
        }
        onCanceled: {
            d.rowHoverIndex = -1
        }
        ScrollView{
            anchors.fill: parent
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
                    if(item_loader_layout.cellItem){
                        if(column === item_loader.column){
                            item_loader_layout.width = w
                        }
                        if(column === item_loader.column-1){
                            let cellPosition = item_loader_layout.cellItem.mapToItem(scroll_table, 0, 0)
                            item_loader_layout.x = table_view.contentX + cellPosition.x
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
                        h = d.defaultItemHeight
                    }
                    if(item_loader_layout.cellItem){
                        if(row === item_loader.row){
                            item_loader_layout.height = h
                        }
                        if(row === item_loader.row-1){
                            let cellPosition = item_loader_layout.cellItem.mapToItem(scroll_table, 0, 0)
                            item_loader_layout.y = table_view.contentY + cellPosition.y
                        }
                    }
                    return h
                }
                model: table_model
                clip: true
                delegate: MouseArea{
                    property var rowObject : table_model.getRow(row)
                    hoverEnabled: true
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
                    onEntered: {
                        d.rowHoverIndex = row
                    }
                    Rectangle{
                        id:item_table
                        anchors.fill: parent
                        property point position: Qt.point(column,row)
                        property bool isRowSelected: d.currentIndex === rowObject.__index
                        color:{
                            if(d.rowHoverIndex === row || item_table.isRowSelected){
                                return FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
                            }
                            return (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.015) : Qt.rgba(0,0,0,0.015))
                        }
                        Rectangle{
                            height: 18
                            radius: 1.5
                            color: FluTheme.primaryColor
                            width: 3
                            visible: item_table.isRowSelected && column === 0
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 3
                            }
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
                                if(typeof(display) == "object"){
                                    return
                                }
                                item_loader.sourceComponent = d.obtEditDelegate(column,row,item_table)
                            }
                            onClicked:
                                (event)=>{
                                    d.currentIndex = rowObject.__index
                                    item_loader.sourceComponent = undefined
                                    event.accepted = true
                                }
                        }
                        FluLoader{
                            property var itemModel: model
                            property var modelData: display
                            property var tableView: table_view
                            property var tableModel: table_model
                            property var position: item_table.position
                            property int row: position.y
                            property int column: position.x
                            property var options: {
                                if(typeof(modelData) == "object"){
                                    return modelData.options
                                }
                                return {}
                            }
                            anchors.fill: parent
                            sourceComponent: {
                                if(typeof(modelData) == "object"){
                                    return modelData.comId
                                }
                                return com_text
                            }
                        }
                    }
                }
            }
            MouseArea{
                property var cellItem
                id:item_loader_layout
                acceptedButtons: Qt.NoButton
                visible: item_loader.sourceComponent
                onVisibleChanged: {
                    if(!visible){
                        item_loader_layout.cellItem = undefined
                    }
                }
                hoverEnabled: true
                z:2
                onEntered: {
                    d.rowHoverIndex = -1
                }
                FluLoader{
                    id:item_loader
                    property var display
                    property int column
                    property int row
                    property var tableView: control
                    sourceComponent: undefined
                    anchors.fill: parent
                    onDisplayChanged: {
                        var obj = table_model.getRow(row)
                        obj[columnSource[column].dataIndex] = display
                        table_model.setRow(row,obj)
                    }
                }
            }
        }
    }
    Component{
        id:com_handle
        Item {}
    }
    Component{
        id:com_column_text
        FluText {
            id: column_text
            text: modelData
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
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
        visible: control.horizonalHeaderVisible
        implicitWidth: syncView ? syncView.width : 0
        implicitHeight: visible ? Math.max(1, contentHeight) : 0
        syncView: table_view
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        delegate: Rectangle {
            id:column_item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            property int columnIndex: column
            readonly property var columnObject : columnSource[column]
            implicitWidth: {
                return (item_column_loader.item && item_column_loader.item.implicitWidth) + (cellPadding * 2)
            }
            implicitHeight: Math.max(36, (item_column_loader.item&&item_column_loader.item.implicitHeight) + (cellPadding * 2))
            color: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            Rectangle{
                border.color: control.borderColor
                width: parent.width
                height: 1
                anchors.top: parent.top
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: 1
                height: parent.height
                anchors.left: parent.left
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: 1
                height: parent.height
                anchors.right: parent.right
                color:"#00000000"
                visible: column === tableModel.columnCount - 1
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
                    }
            }
            FluLoader{
                id:item_column_loader
                property var itemModel: model
                property var modelData: model.display
                property var tableView: table_view
                property var tableModel: table_model
                property var options:{
                    if(typeof(modelData) == "object"){
                        return modelData.options
                    }
                    return {}
                }
                property int column: column_item_control.columnIndex
                width: parent.width
                height: parent.height
                sourceComponent: {
                    if(typeof(modelData) == "object"){
                        return modelData.comId
                    }
                    return com_column_text
                }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: parent.height
                width: 6
                anchors.right: parent.right
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                visible: !(columnObject.width === columnObject.minimumWidth && columnObject.width === columnObject.maximumWidth && columnObject.width)
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
                        var minimumWidth = columnObject.minimumWidth
                        var maximumWidth = columnObject.maximumWidth
                        var w = columnObject.width
                        if(!w){
                            w = d.defaultItemWidth
                        }
                        if(!minimumWidth){
                            minimumWidth = d.defaultItemWidth
                        }
                        if(!maximumWidth){
                            maximumWidth = 65535
                        }
                        columnObject.width = Math.min(Math.max(minimumWidth, w + delta.x),maximumWidth)
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
        visible: control.verticalHeaderVisible
        implicitWidth: visible ? Math.max(1, contentWidth) : 0
        implicitHeight: syncView ? syncView.height : 0
        syncDirection: Qt.Vertical
        syncView: table_view
        clip: true
        model: TableModel{
            TableModelColumn {}
        }
        Connections{
            target: table_model
            function onRowCountChanged(){
                header_vertical.model.rows = table_model.rows
            }
        }
        onContentYChanged:{
            timer_vertical_force_layout.restart()
        }
        Timer{
            id:timer_vertical_force_layout
            interval: 50
            onTriggered: {
                header_vertical.forceLayout()
            }
        }
        delegate: Rectangle{
            id:item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            property var rowObject: table_model.getRow(row)
            implicitWidth: Math.max(30, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
            width: implicitWidth
            height: implicitHeight
            color: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            Rectangle{
                border.color: control.borderColor
                width: parent.width
                height: 1
                anchors.top: parent.top
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                visible: row === tableModel.rowCount - 1
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: 1
                height: parent.height
                anchors.left: parent.left
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: 1
                height: parent.height
                anchors.right: parent.right
                color:"#00000000"
            }
            FluText{
                id:row_text
                anchors.centerIn: parent
                text: row + 1
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
                    }
            }
            MouseArea{
                property point clickPos: "0,0"
                height: 6
                width: parent.width
                anchors.bottom: parent.bottom
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.SplitVCursor
                visible: !(rowObject.height === rowObject.minimumHeight && rowObject.height === rowObject.maximumHeight && rowObject.height)
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
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = rowObject.minimumHeight
                        var maximumHeight = rowObject.maximumHeight
                        var h = rowObject.height
                        if(!h){
                            h = d.defaultItemHeight
                        }
                        if(!minimumHeight){
                            minimumHeight = d.defaultItemHeight
                        }
                        if(!maximumHeight){
                            maximumHeight = 65535
                        }
                        rowObject.height = Math.min(Math.max(minimumHeight, h + delta.y),maximumHeight)
                        table_model.setRow(row,rowObject)
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
    function customItem(comId,options={}){
        var o = {}
        o.comId = comId
        o.options = options
        return o
    }
    function updateRow(row,obj){
        table_model.setRow(row,obj)
    }
    function sort(order){
        let sortedArray = []
        for(var i =0;i<table_model.rowCount;i++){
            let row = table_model.getRow(i)
            sortedArray.push(row)
        }
        if(order === undefined){
            sortedArray.sort((a, b) => a.__index -  b.__index)
        }else{
            sortedArray.sort(order)
        }
        table_model.clear()
        table_model.rows = sortedArray
    }
}
