import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import FluentUI 1.0

Rectangle {
    property var columnSource
    property var dataSource
    property color borderColor: FluTheme.dark ? "#252525" : "#e4e4e4"
    property alias rows: table_view.rows
    property alias columns: table_view.columns
    property bool horizonalHeaderVisible: true
    property bool verticalHeaderVisible: true
    property color selectedBorderColor: FluTheme.primaryColor
    property color selectedColor: FluTools.colorAlpha(FluTheme.primaryColor,0.3)
    property alias sourceModel: table_model
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
        property var current
        property int rowHoverIndex: -1
        property int defaultItemWidth: 100
        property int defaultItemHeight: 42
        property var header_rows:[]
        property var editDelegate
        property var editPosition
        function getEditDelegate(column){
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
        table_model.rows = dataSource
    }
    TableModel {
        id:table_model
    }
    FluTableSortProxyModel{
        id:table_sort_model
        model: table_model
    }
    Component{
        id:com_edit
        FluTextBox{
            id:text_box
            text: String(display)
            readOnly: true === columnSource[column].readOnly
            Component.onCompleted: {
                forceActiveFocus()
                selectAll()
            }
            onCommit: {
                if(!readOnly){
                    editTextChaged(text_box.text)
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
                            editTextChaged(text_box.text)
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
            text: String(display)
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
        id:layout_mouse_table
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
                syncView: header_horizontal
                syncDirection: Qt.Horizontal
                ScrollBar.vertical:scroll_bar_v
                rowHeightProvider: function(row) {
                    if(row>=table_view.rows){
                        return 0
                    }
                    var rowObject = control.getRow(row)
                    var h = rowObject.height
                    if(!h){
                        h = rowObject._minimumHeight
                    }
                    if(!h){
                        h = d.defaultItemHeight
                    }
                    return h
                }
                model: table_sort_model
                clip: true
                onRowsChanged: {
                    closeEditor()
                }
                delegate: MouseArea{
                    property var rowObject : control.getRow(row)
                    property var itemModel: model
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
                        property bool isRowSelected: {
                            if(rowObject === null)
                                return false
                            if(d.current){
                                return rowObject._key === d.current._key
                            }
                            return false
                        }
                        color:{
                            if(item_table.isRowSelected){
                                return control.selectedColor
                            }
                            if(d.rowHoverIndex === row || item_table.isRowSelected){
                                return FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
                            }
                            return (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.015) : Qt.rgba(0,0,0,0.015))
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
                                d.editDelegate = d.getEditDelegate(column)
                                d.editPosition = {"_key":rowObject._key,"column":column}
                            }
                            onClicked:
                                (event)=>{
                                    d.current = rowObject
                                    closeEditor()
                                    event.accepted = true
                                }
                        }
                        FluLoader{
                            property var model: itemModel
                            property var display: itemModel.display
                            property int row: item_table.position.y
                            property int column: item_table.position.x
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
                        FluLoader{
                            property var display: itemModel.display
                            property int column: item_table.position.x
                            property int row: item_table.position.y
                            property var tableView: control
                            signal editTextChaged(string text)
                            anchors.fill: parent
                            onEditTextChaged:
                                (text)=>{
                                    var obj = control.getRow(row)
                                    obj[columnSource[column].dataIndex] = text
                                    control.setRow(row,obj)
                                }
                            sourceComponent: {
                                if(d.editPosition === undefined){
                                    return undefined
                                }
                                if(d.editPosition._key === rowObject._key && d.editPosition.column === column){
                                    return d.editDelegate
                                }
                                return undefined
                            }
                        }
                        Item{
                            anchors.fill: parent
                            visible: item_table.isRowSelected
                            Rectangle{
                                width: 1
                                height: parent.height
                                anchors.left: parent.left
                                color: control.selectedBorderColor
                                visible: column === 0
                            }
                            Rectangle{
                                width: 1
                                height: parent.height
                                anchors.right: parent.right
                                color: control.selectedBorderColor
                                visible: column === control.columns-1
                            }
                            Rectangle{
                                width: parent.width
                                height: 1
                                anchors.top: parent.top
                                color: control.selectedBorderColor
                            }
                            Rectangle{
                                width: parent.width
                                height: 1
                                anchors.bottom: parent.bottom
                                color: control.selectedBorderColor
                            }
                        }
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
    FluScrollBar {
        id:scroll_bar_h
        anchors{
            left: layout_mouse_table.left
            right: layout_mouse_table.right
            bottom: layout_mouse_table.bottom
        }
    }
    FluScrollBar {
        id:scroll_bar_v
        anchors{
            top: layout_mouse_table.top
            bottom: layout_mouse_table.bottom
            right: layout_mouse_table.right
        }
    }
    TableView {
        id: header_horizontal
        model: TableModel{
            id:header_model
            rows: d.header_rows
        }
        syncDirection: Qt.Horizontal
        anchors.left: layout_mouse_table.left
        anchors.top: parent.top
        visible: control.horizonalHeaderVisible
        implicitWidth: table_view.width
        implicitHeight: visible ? Math.max(1, contentHeight) : 0
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        ScrollBar.horizontal:scroll_bar_h
        columnWidthProvider: function(column) {
            var w = columnSource[column].width
            if(!w){
                w = columnSource[column].minimumWidth
            }
            if(!w){
                w = d.defaultItemWidth
            }
            return w
        }
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
                visible: column === table_view.columns - 1
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
                        header_horizontal.forceLayout()
                    }
            }
        }
    }
    TableView {
        id: header_vertical
        boundsBehavior: Flickable.StopAtBounds
        anchors.top: layout_mouse_table.top
        anchors.left: parent.left
        visible: control.verticalHeaderVisible
        implicitWidth: visible ? Math.max(1, contentWidth) : 0
        implicitHeight: syncView ? syncView.height : 0
        syncDirection: Qt.Vertical
        syncView: table_view
        clip: true
        model: TableModel{
            id:model_rows
            TableModelColumn { display: "rowIndex" }
        }
        Connections{
            target: table_model
            function onRowCountChanged(){
                model_rows.rows = Array.from({length: table_model.rows.length}, (_, i) => ({rowIndex:i+1}));
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
            property var rowObject: control.getRow(row)
            implicitWidth: Math.max(30, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
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
                visible: row === table_view.rows - 1
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
                text: model.display
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
                visible: {
                    if(rowObject === null)
                        return false
                    return !(rowObject.height === rowObject._minimumHeight && rowObject.height === rowObject._maximumHeight && rowObject.height)
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
                        var rowObject = control.getRow(row)
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = rowObject._minimumHeight
                        var maximumHeight = rowObject._maximumHeight
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
                        control.setRow(row,rowObject)
                        table_view.forceLayout()
                    }
            }
        }
    }
    function closeEditor(){
        d.editPosition = undefined
        d.editDelegate = undefined
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
    function sort(callback=undefined){
        if(callback){
            table_sort_model.setComparator(function(left,right){
                return callback(table_model.getRow(left),table_model.getRow(right))
            })
        }else{
            table_sort_model.setComparator(undefined)
        }
    }
    function filter(callback=undefined){
        if(callback){
            table_sort_model.setFilter(function(index){
                return callback(table_model.getRow(index))
            })
        }else{
            table_sort_model.setFilter(undefined)
        }
    }
    function setRow(rowIndex,obj){
        if(rowIndex>=0 && rowIndex<table_view.rows){
            table_view.model.setRow(rowIndex,obj)
        }
    }
    function getRow(rowIndex){
        if(rowIndex>=0 && rowIndex<table_view.rows){
            return table_view.model.getRow(rowIndex)
        }
        return null
    }
    function removeRow(rowIndex,rows=1){
        if(rowIndex>=0 && rowIndex<table_view.rows){
            table_view.model.removeRow(rowIndex,rows)
        }
    }
    function appendRow(obj){
        table_model.appendRow(obj)
    }
}
