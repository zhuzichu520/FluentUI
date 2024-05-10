import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import FluentUI 1.0

Rectangle {
    readonly property alias rows: table_view.rows
    readonly property alias columns: table_view.columns
    readonly property alias current: d.current
    property var sourceModel:FluTableModel {
        columnSource: control.columnSource
    }
    property var columnSource: []
    property var dataSource
    property color borderColor: FluTheme.dark ? Qt.rgba(37/255,37/255,37/255,1) : Qt.rgba(228/255,228/255,228/255,1)
    property bool horizonalHeaderVisible: true
    property bool verticalHeaderVisible: true
    property color selectedBorderColor: FluTheme.primaryColor
    property color selectedColor: FluTools.withOpacity(FluTheme.primaryColor,0.3)
    property alias view: table_view
    id:control
    color: {
        if(Window.active){
            return FluTheme.frameActiveColor
        }
        return FluTheme.frameColor
    }
    onColumnSourceChanged: {
        if(columnSource.length!==0){
            var columns= []
            var headerRow = {}
            var offsetX = 0
            for(var i=0;i<=columnSource.length-1;i++){
                var item = columnSource[i]
                if(!item.width){
                    item.width = d.defaultItemWidth
                }
                item.x = offsetX
                offsetX = offsetX + item.width
                var column = Qt.createQmlObject('import Qt.labs.qmlmodels 1.0;TableModelColumn{}',sourceModel);
                column.display = item.dataIndex
                columns.push(column)
                headerRow[item.dataIndex] = item
            }
            header_column_model.columns = columns
            header_column_model.rows = [headerRow]
        }
    }
    Component.onDestruction: {
        table_view.contentY = 0
    }
    QtObject{
        id:d
        property var current
        property int rowHoverIndex: -1
        property int defaultItemWidth: 100
        property int defaultItemHeight: 42
        property var editDelegate
        property var editPosition
        signal tableItemLayout(int column)
        function getEditDelegate(column){
            var obj =control.columnSource[column].editDelegate
            if(obj){
                return obj
            }
            if(control.columnSource[column].editMultiline === true){
                return com_edit_multiline
            }
            return com_edit
        }
    }
    onDataSourceChanged: {
        sourceModel.clear()
        sourceModel.rows = dataSource
    }
    TableModel{
        id: header_column_model
        TableModelColumn { display : "title"}
    }
    TableModel{
        id: header_row_model
        TableModelColumn { display: "rowIndex" }
    }
    FluTableSortProxyModel{
        id: table_sort_model
        model: control.sourceModel
    }
    Component{
        id:com_edit
        FluTextBox{
            id:text_box
            text: String(display)
            readOnly: true === control.columnSource[column].readOnly
            Component.onCompleted: {
                forceActiveFocus()
                selectAll()
            }
            onCommit: {
                if(!readOnly){
                    editTextChaged(text_box.text)
                }
                control.closeEditor()
            }
        }
    }
    Component{
        id:com_edit_multiline
        Item{
            anchors.fill: parent
            Flickable{
                id:item_scroll
                clip: true
                anchors.fill: parent
                ScrollBar.vertical: multiline_text_srcoll_bar
                boundsBehavior: Flickable.StopAtBounds
                TextArea.flickable: FluMultilineTextBox {
                    id:text_box
                    text: String(display)
                    readOnly: true === control.columnSource[column].readOnly
                    verticalAlignment: TextInput.AlignVCenter
                    isCtrlEnterForNewline: true
                    Component.onCompleted: {
                        forceActiveFocus()
                        selectAll()
                    }
                    rightPadding: 34
                    onCommit: {
                        if(!readOnly){
                            editTextChaged(text_box.text)
                        }
                        control.closeEditor()
                    }
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeClose
                iconSize: 10
                width: 20
                height: 20
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                visible: {
                    if(text_box.readOnly)
                        return false
                    return text_box.text !== ""
                }
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 15
                }
                onClicked:{
                    text_box.text = ""
                }
            }
            FluScrollBar{
                id:multiline_text_srcoll_bar
                anchors{
                    right: parent.right
                    rightMargin: 5
                    top: parent.top
                    bottom: parent.bottom
                    topMargin: 3
                    bottomMargin: 3
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
    Component{
        id:com_table_delegate
        MouseArea{
            id:item_table_mouse
            implicitWidth: TableView.view.width
            property var _model: model
            property bool isMainTable: TableView.view == table_view
            property var currentTableView: TableView.view
            visible: {
                if(isMainTable && columnModel.frozen){
                    return false
                }
                if(!isMainTable){
                    if(currentTableView.dataIndex !== columnModel.dataIndex)
                    return false
                }
                return true
            }
            property bool isRowSelected: {
                if(rowModel === null)
                    return false
                if(d.current){
                    return rowModel._key === d.current._key
                }
                return false
            }
            property bool editVisible: {
                if(d.editPosition && d.editPosition._key === rowModel._key && d.editPosition.column === column){
                    return true
                }
                return false
            }
            TableView.onPooled: {
                if(d.editPosition && d.editPosition.row === row && d.editPosition.column === column){
                    control.closeEditor()
                }
            }
            hoverEnabled: true
            onEntered: {
                d.rowHoverIndex = row
            }
            onWidthChanged: {
                if(editVisible){
                    updateEditPosition()
                }
                if(isMainTable){
                    updateTableItem()
                }
            }
            onHeightChanged: {
                if(editVisible){
                    updateEditPosition()
                }
                if(isMainTable){
                    updateTableItem()
                }
            }
            onXChanged: {
                if(editVisible){
                    updateEditPosition()
                }
                if(isMainTable){
                    updateTableItem()
                }
            }
            onYChanged: {
                if(editVisible){
                    updateEditPosition()
                }
                if(isMainTable){
                    updateTableItem()
                }
            }
            function updateEditPosition(){
                var obj = {}
                obj._key = rowModel._key
                obj.column = column
                obj.row = row
                obj.x = item_table_mouse.x
                obj.y = item_table_mouse.y + 1
                obj.width = item_table_mouse.width
                obj.height = item_table_mouse.height - 2
                d.editPosition = obj
            }
            function updateTableItem(){
                var columnModel = control.columnSource[column]
                columnModel.x = item_table_mouse.x
                columnModel.y = item_table_mouse.y
                d.tableItemLayout(column)
            }
            Rectangle{
                anchors.fill: parent
                color:{
                    if(item_table_mouse.isRowSelected){
                        return control.selectedColor
                    }
                    if(d.rowHoverIndex === row || item_table_mouse.isRowSelected){
                        return FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
                    }
                    return (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03))
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed:{
                        control.closeEditor()
                    }
                    onCanceled: {
                    }
                    onReleased: {
                    }
                    onDoubleClicked:{
                        if(item_table_loader.isObject){
                            return
                        }
                        loader_edit.display = item_table_loader.display
                        d.editDelegate = d.getEditDelegate(column)
                        item_table_mouse.updateEditPosition()
                    }
                    onClicked:
                        (event)=>{
                            d.current = rowModel
                            control.closeEditor()
                            event.accepted = true
                        }
                }
                FluLoader{
                    id: item_table_loader
                    property var model: item_table_mouse._model
                    property var display: rowModel[columnModel.dataIndex]
                    property var rowModel : model.rowModel
                    property var columnModel : model.columnModel
                    property int row : model.row
                    property int column: model.column
                    property bool isObject: typeof(display) == "object"
                    property var options: {
                        if(isObject){
                            return display.options
                        }
                        return {}
                    }
                    anchors.fill: parent
                    sourceComponent: {
                        if(item_table_mouse.visible){
                            if(isObject){
                                return display.comId
                            }
                            return com_text
                        }
                        return undefined
                    }
                }
                FluLoader{
                    id: loader_edit
                    property var tableView: control
                    property var display
                    property int column: {
                        if(d.editPosition){
                            return d.editPosition.column
                        }
                        return 0
                    }
                    property int row: {
                        if(d.editPosition){
                            return d.editPosition.row
                        }
                        return 0
                    }
                    anchors{
                        fill: parent
                        margins: 1
                    }
                    signal editTextChaged(string text)
                    sourceComponent: {
                        if(item_table_mouse.visible && d.editPosition && d.editPosition.column === model.column && d.editPosition.row === model.row){
                            return d.editDelegate
                        }
                        return undefined
                    }
                    onEditTextChaged:
                        (text)=>{
                            var obj = control.getRow(row)
                            obj[control.columnSource[column].dataIndex] = text
                            control.setRow(row,obj)
                        }
                    z:999
                }
                Item{
                    anchors.fill: parent
                    visible: item_table_mouse.isRowSelected
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
    MouseArea{
        id:layout_mouse_table
        hoverEnabled: true
        anchors{
            left: header_vertical.right
            top: header_horizontal.bottom
            right: parent.right
            bottom: parent.bottom
        }
        onExited: {
            d.rowHoverIndex = -1
        }
        onCanceled: {
            d.rowHoverIndex = -1
        }
        TableView {
            id:table_view
            boundsBehavior: Flickable.StopAtBounds
            anchors.fill: parent
            ScrollBar.horizontal:scroll_bar_h
            ScrollBar.vertical:scroll_bar_v
            columnWidthProvider: function(column) {
                var columnModel = control.columnSource[column]
                var width = columnModel.width
                if(width){
                    return width
                }
                var minimumWidth = columnModel.minimumWidth
                if(minimumWidth){
                    return minimumWidth
                }
                return d.defaultItemWidth
            }
            rowHeightProvider: function(row) {
                var rowModel = control.getRow(row)
                var height = rowModel.height
                if(height){
                    return height
                }
                var minimumHeight = rowModel._minimumHeight
                if(minimumHeight){
                    return minimumHeight
                }
                return d.defaultItemHeight
            }
            model: table_sort_model
            clip: true
            onRowsChanged: {
                control.closeEditor()
                table_view.flick(0,1)
            }
            delegate: com_table_delegate
        }
    }

    Component{
        id:com_column_header_delegate
        Rectangle{
            id: column_item_control
            property var currentTableView : TableView.view
            readonly property real cellPadding: 8
            property bool canceled: false
            property var _model: model
            readonly property var columnModel : control.columnSource[_index]
            readonly property int _index : {
                const isDataIndex = (element) => {
                    return element.dataIndex === display.dataIndex
                }
                return control.columnSource.findIndex(isDataIndex)
            }
            readonly property bool isHeaderHorizontal: TableView.view == header_horizontal
            implicitWidth: {
                if(column_item_control.isHeaderHorizontal){
                    return (item_column_loader.item && item_column_loader.item.implicitWidth) + (cellPadding * 2)
                }
                return TableView.view.width
            }
            implicitHeight: {
                if(column_item_control.isHeaderHorizontal){
                    return Math.max(36, (item_column_loader.item&&item_column_loader.item.implicitHeight) + (cellPadding * 2))
                }
                return TableView.view.height
            }
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
                visible: column_item_control._index !== 0
                color:"#00000000"
            }
            Rectangle{
                border.color: control.borderColor
                width: 1
                height: parent.height
                anchors.right: parent.right
                color:"#00000000"
                visible: column_item_control._index === table_view.columns - 1
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
                        control.closeEditor()
                    }
            }
            FluLoader{
                id:item_column_loader
                property var model: column_item_control._model
                property var display: model.display.title
                property var tableView: table_view
                property var sourceModel: control.sourceModel
                property bool isObject: typeof(display) == "object"
                property var options:{
                    if(isObject){
                        return display.options
                    }
                    return {}
                }
                property int column: column_item_control._index
                width: parent.width
                height: parent.height
                sourceComponent: {
                    if(isObject){
                        return display.comId
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
                visible: !columnModel.frozen && !(columnModel.width === columnModel.minimumWidth && columnModel.width === columnModel.maximumWidth && columnModel.width)
                cursorShape: Qt.SplitHCursor
                preventStealing: true
                onPressed :
                    (mouse)=>{
                        FluTools.setOverrideCursor(Qt.SplitHCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    FluTools.restoreOverrideCursor()
                }
                onCanceled: {
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        if(!pressed){
                            return
                        }
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumWidth = columnModel.minimumWidth
                        var maximumWidth = columnModel.maximumWidth
                        var w = columnModel.width
                        if(!w){
                            w = d.defaultItemWidth
                        }
                        if(!minimumWidth){
                            minimumWidth = d.defaultItemWidth
                        }
                        if(!maximumWidth){
                            maximumWidth = 65535
                        }
                        columnModel.width = Math.min(Math.max(minimumWidth, w + delta.x),maximumWidth)
                        table_view.forceLayout()
                        header_horizontal.forceLayout()
//                        column_item_control.currentTableView.forceLayout()
                    }
            }
        }
    }
    Component{
        id:com_row_header_delegate
        Rectangle{
            id:item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            property var rowModel: control.getRow(row)
            implicitWidth: Math.max(30, row_text.implicitWidth + (cellPadding * 2))
            implicitHeight: row_text.implicitHeight + (cellPadding * 2)
            color: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            Rectangle{
                border.color: control.borderColor
                width: parent.width
                height: 1
                anchors.top: parent.top
                visible: row !== 0
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
                        control.closeEditor()
                    }
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
                    if(rowModel === null)
                        return false
                    return !(rowModel.height === rowModel._minimumHeight && rowModel.height === rowModel._maximumHeight && rowModel.height)
                }
                onPressed :
                    (mouse)=>{
                        FluTools.setOverrideCursor(Qt.SplitVCursor)
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                onReleased:{
                    FluTools.restoreOverrideCursor()
                }
                onCanceled: {
                    FluTools.restoreOverrideCursor()
                }
                onPositionChanged:
                    (mouse)=>{
                        if(!pressed){
                            return
                        }
                        var rowModel = control.getRow(row)
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        var minimumHeight = rowModel._minimumHeight
                        var maximumHeight = rowModel._maximumHeight
                        var h = rowModel.height
                        if(!h){
                            h = d.defaultItemHeight
                        }
                        if(!minimumHeight){
                            minimumHeight = d.defaultItemHeight
                        }
                        if(!maximumHeight){
                            maximumHeight = 65535
                        }
                        rowModel.height = Math.min(Math.max(minimumHeight, h + delta.y),maximumHeight)
                        control.setRow(row,rowModel)
                        table_view.forceLayout()
                    }
            }
        }
    }
    Component{
        id:com_column_text
        FluText {
            id: column_text
            text: String(display)
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Item{
        id: header_vertical_column
        anchors{
            top: header_horizontal.top
            bottom: header_horizontal.bottom
            left: parent.left
            right: header_vertical.right
        }
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
        }
    }
    TableView {
        id: header_horizontal
        model: header_column_model
        anchors{
            left: header_vertical.right
            right: layout_mouse_table.right
            top: parent.top
        }
        visible: control.horizonalHeaderVisible
        height: visible ? Math.max(1, contentHeight) : 0
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        syncDirection: Qt.Horizontal
        ScrollBar.horizontal:scroll_bar_h_2
        columnWidthProvider: table_view.columnWidthProvider
        syncView: table_view.rows === 0 ? null : table_view
        onContentXChanged:{
            timer_horizontal_force_layout.restart()
        }
        Timer{
            id:timer_horizontal_force_layout
            interval: 50
            onTriggered: {
                header_horizontal.forceLayout()
            }
        }
        delegate: com_column_header_delegate
    }
    TableView {
        id: header_vertical
        boundsBehavior: Flickable.StopAtBounds
        anchors{
            top: layout_mouse_table.top
            left: parent.left
        }
        visible: control.verticalHeaderVisible
        implicitWidth: visible ? Math.max(1, contentWidth) : 0
        implicitHeight: syncView ? syncView.height : 0
        syncDirection: Qt.Vertical
        syncView: table_view
        clip: true
        model: header_row_model
        delegate: com_row_header_delegate
        onContentYChanged:{
            timer_vertical_force_layout.restart()
        }
        Connections{
            target: table_view
            function onRowsChanged(){
                header_row_model.rows = Array.from({length: table_view.rows}, (_, i) => ({rowIndex:i+1}))
            }
        }
        Timer{
            id:timer_vertical_force_layout
            interval: 50
            onTriggered: {
                header_vertical.forceLayout()
            }
        }
    }
    Item{
        anchors{
            left: header_vertical.right
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        Component{
            id: com_table_frozen
            Rectangle{
                id: item_layout_frozen
                anchors.fill: parent
                color: {
                    if(Window.active){
                        return FluTheme.dark ? Qt.rgba(48/255,48/255,48/255,1) :Qt.rgba(1,1,1,1)
                    }
                    return FluTheme.dark ? Qt.rgba(56/255,56/255,56/255,1) :Qt.rgba(243/255,243/255,243/255,1)
                }
                visible: table_view.rows !== 0
                Rectangle{
                    z:99
                    anchors.fill: parent
                    border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,0.6) : Qt.rgba(191/255,191/255,191/255,0.3)
                    FluShadow{
                        radius: 0
                        anchors.fill: parent
                    }
                    color: "#00000000"
                }
                TableView {
                    id:item_table_frozen_header
                    model: header_column_model
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    interactive: false
                    anchors{
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        bottom: item_table_frozen.top
                    }
                    delegate: com_column_header_delegate
                }
                TableView{
                    property string dataIndex: columnModel.dataIndex
                    id: item_table_frozen
                    clip: true
                    interactive: false
                    anchors{
                        fill: parent
                        topMargin: header_horizontal.height
                    }
                    boundsBehavior: TableView.StopAtBounds
                    model: table_sort_model
                    delegate: com_table_delegate
                    syncDirection: Qt.Vertical
                    syncView: table_view
                    Component.onCompleted: {
                        item_table_frozen_header.contentX = columnModel.width * _index
                        item_table_frozen.contentX = columnModel.width * _index
                    }

                }
            }
        }
        Repeater{
            Component.onCompleted: {
                model = control.columnSource
            }
            delegate: FluLoader{
                id: item_layout_frozen
                readonly property int _index : model.index
                readonly property var columnModel : control.columnSource[_index]
                Connections{
                    target: d
                    function onTableItemLayout(column){
                        if(item_layout_frozen._index === column){
                            updateLayout()
                        }
                    }
                }
                Connections{
                    target: table_view
                    function onContentXChanged(){
                        updateLayout()
                    }
                }
                function updateLayout(){
                    width = table_view.columnWidthProvider(_index)
                    x = Qt.binding(function(){
                        var minX = 0
                        var maxX = table_view.width-item_layout_frozen.width
                        for(var i=0;i<_index;i++){
                            var item = control.columnSource[i]
                            if(item.frozen){
                                minX = minX + item.width
                            }
                        }
                        for(i=_index+1;i<control.columnSource.length;i++){
                            item = control.columnSource[i]
                            if(item.frozen){
                                maxX =  maxX- item.width
                            }
                        }
                        return Math.min(Math.max(columnModel.x - table_view.contentX,minX),maxX)}
                    )
                }
                Component.onCompleted: {
                    updateLayout()
                }
                height: control.height
                visible: {
                    if(modelData.frozen){
                        return true
                    }
                    return false
                }
                sourceComponent: visible ? com_table_frozen : undefined
                onStatusChanged: {
                    if(status === Loader.Ready){
                        sourceComponent = Qt.binding(function(){
                            if(modelData.frozen){
                                return com_table_frozen
                            }
                            return undefined
                        })
                    }
                }
            }
        }
    }
    FluScrollBar {
        id: scroll_bar_h
        anchors{
            left: layout_mouse_table.left
            right: parent.right
            bottom: layout_mouse_table.bottom
        }
        visible: table_view.rows !== 0
        z:999
    }
    FluScrollBar {
        id: scroll_bar_h_2
        anchors{
            left: layout_mouse_table.left
            right: parent.right
            bottom: layout_mouse_table.bottom
        }
        visible: table_view.rows === 0
        z:999
    }
    FluScrollBar {
        id: scroll_bar_v
        anchors{
            top: layout_mouse_table.top
            bottom: layout_mouse_table.bottom
            right: parent.right
        }
        z:999
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
                return callback(sourceModel.getRow(left),sourceModel.getRow(right))
            })
        }else{
            table_sort_model.setComparator(undefined)
        }
    }
    function filter(callback=undefined){
        if(callback){
            table_sort_model.setFilter(function(index){
                return callback(sourceModel.getRow(index))
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
    function insertRow(rowIndex,obj){
        if(rowIndex>=0 && rowIndex<table_view.rows){
            sourceModel.insertRow(rowIndex,obj)
        }
    }
    function currentIndex(){
        var index = -1
        if(!d.current){
            return index
        }
        for (var i = 0; i <= sourceModel.rowCount-1; i++) {
            var sourceItem = sourceModel.getRow(i);
            if(sourceItem._key === d.current._key){
                index = i
                break
            }
        }
        return index
    }
    function appendRow(obj){
        sourceModel.appendRow(obj)
    }
}
