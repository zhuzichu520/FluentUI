import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import FluentUI 1.0

Rectangle {
    property var dataSource
    property var columnSource : []
    property bool showLine: true
    property int cellHeight: 30
    property int depthPadding: 15
    property bool checkable: false
    property color lineColor: FluTheme.dividerColor
    property color borderColor: FluTheme.dark ? Qt.rgba(37/255,37/255,37/255,1) : Qt.rgba(228/255,228/255,228/255,1)
    property color selectedBorderColor: FluTheme.primaryColor
    property color selectedColor: FluTools.withOpacity(FluTheme.primaryColor,0.3)
    readonly property alias current: d.current
    id:control
    color: {
        if(Window.active){
            return FluTheme.frameActiveColor
        }
        return FluTheme.frameColor
    }
    onDataSourceChanged: {
        tree_model.setDataSource(dataSource)
    }
    onColumnSourceChanged: {
        if(columnSource.length !== 0){
            var columns= []
            var headerRow = {}
            columnSource.forEach(function(item){
                var column = Qt.createQmlObject('import Qt.labs.qmlmodels 1.0;TableModelColumn{}',control);
                column.display = item.dataIndex
                columns.push(column)
                headerRow[item.dataIndex] = item.title
            })
            header_column_model.columns = columns
            header_column_model.rows = [headerRow]
        }
    }
    FluTreeModel{
        id:tree_model
        columnSource: control.columnSource
    }
    onDepthPaddingChanged: {
        table_view.forceLayout()
    }
    onCellHeightChanged: {
        table_view.forceLayout()
    }
    onCheckableChanged: {
        delay_force_layout.restart()
    }
    Timer{
        id:delay_force_layout
        interval: 30
        onTriggered: {
            table_view.forceLayout()
        }
    }
    QtObject {
        id:d
        property var current
        property int defaultItemWidth: 100
        property int rowHoverIndex: -1
        property var editDelegate
        property var editPosition
        function getEditDelegate(column){
            var obj = control.columnSource[column].editDelegate
            if(obj){
                return obj
            }
            if(control.columnSource[column].editMultiline === true){
                return com_edit_multiline
            }
            return com_edit
        }
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
        id:com_column
        Item{
            id:item_container
            clip: true
            function toggle(){
                if(rowModel.isExpanded){
                    tree_model.collapse(row)
                }else{
                    tree_model.expand(row)
                }
                delay_force_layout.restart()
            }
            MouseArea{
                id:item_mouse
                property point clickPos: Qt.point(0,0)
                anchors.fill: parent
                onClicked: {
                    d.current = rowModel
                }
                onDoubleClicked: {
                    if(rowModel.hasChildren()){
                        item_container.toggle()
                    }
                }
            }
            FluRectangle{
                width: 1
                color: control.lineColor
                visible: control.showLine && rowModel.depth !== 0 && !rowModel.hasChildren()
                height: rowModel.hideLineFooter() ? parent.height/2 : parent.height
                anchors{
                    top: parent.top
                    left: item_line_h.left
                }
            }
            FluRectangle{
                id:item_line_h
                height: 1
                color: control.lineColor
                visible: control.showLine && rowModel.depth !== 0 && !rowModel.hasChildren()
                width: depthPadding - 10
                anchors{
                    right: layout_row.left
                    rightMargin: -24
                    verticalCenter: parent.verticalCenter
                }
            }
            Repeater{
                model: Math.max(rowModel.depth-1,0)
                delegate: FluRectangle{
                    required property int index
                    width: 1
                    color: control.lineColor
                    visible: control.showLine && rowModel.depth !== 0 && rowModel.hasNextNodeByIndex(index)
                    anchors{
                        top:parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: control.depthPadding*(index+1) + 24
                    }
                }
            }
            RowLayout{
                id:layout_row
                height: parent.height
                anchors.fill: parent
                spacing: 0
                anchors.leftMargin: 14 + control.depthPadding*rowModel.depth
                Component{
                    id:com_icon_btn
                    FluIconButton{
                        opacity: rowModel.hasChildren()
                        onClicked: {
                            item_container.toggle()
                        }
                        contentItem:FluIcon{
                            rotation: rowModel.isExpanded?0:-90
                            iconSource:FluentIcons.ChevronDown
                            iconSize: 16
                            anchors.centerIn: parent
                        }
                    }
                }
                FluLoader{
                    id:item_loader_expand
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    sourceComponent: rowModel.hasChildren() ? com_icon_btn : undefined
                    Layout.alignment: Qt.AlignVCenter
                }
                FluCheckBox{
                    id:item_check_box
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    Layout.leftMargin: 5
                    horizontalPadding:0
                    verticalPadding: 0
                    checked: rowModel.checked
                    animationEnabled:false
                    visible: control.checkable
                    padding: 0
                    clickListener: function(){
                        tree_model.checkRow(row,!rowModel.checked)
                    }
                    Layout.alignment: Qt.AlignVCenter
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 6
                    FluText {
                        id:item_text
                        text: String(display)
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                        MouseArea{
                            acceptedButtons: Qt.NoButton
                            id: hover_handler
                            hoverEnabled: true
                            anchors.fill: parent
                        }
                        FluTooltip{
                            text: item_text.text
                            delay: 500
                            visible: item_text.contentWidth < item_text.implicitWidth &&  hover_handler.containsMouse
                        }
                    }
                }

            }
        }
    }
    Component{
        id:com_other
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
    TableView{
        id:table_view
        ScrollBar.horizontal: FluScrollBar{}
        ScrollBar.vertical: FluScrollBar{}
        boundsBehavior: Flickable.StopAtBounds
        model: tree_model
        anchors{
            top: header_horizontal.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        columnWidthProvider: function(column) {
            var columnObject = control.columnSource[column]
            var width = columnObject.width
            if(width){
                return width
            }
            var minimumWidth = columnObject.minimumWidth
            if(minimumWidth){
                return minimumWidth
            }
            return d.defaultItemWidth
        }
        rowHeightProvider: function(row) {
            return control.cellHeight
        }
        delegate: MouseArea{
            property var rowObject : rowModel.data
            property alias isRowSelected: item_table_loader.isRowSelected
            property var display: rowModel.data[columnModel.dataIndex]
            property bool isObject: typeof(item_table.display) == "object"
            property bool editVisible: {
                if(rowObject && d.editPosition && d.editPosition._key === rowObject._key && d.editPosition.column === column){
                    return true
                }
                return false
            }
            implicitHeight: 30
            implicitWidth: 30
            id: item_table
            hoverEnabled: true
            onEntered: {
                d.rowHoverIndex = row
            }
            onWidthChanged: {
                if(editVisible){
                    updateEditPosition()
                }
            }
            onHeightChanged: {
                if(editVisible){
                    updateEditPosition()
                }
            }
            onXChanged: {
                if(editVisible){
                    updateEditPosition()
                }
            }
            onYChanged: {
                if(editVisible){
                    updateEditPosition()
                }
            }
            function updateEditPosition(){
                var obj = {}
                obj._key = rowObject._key
                obj.column = column
                obj.row = row
                obj.x = item_table.x
                obj.y = item_table.y + 1
                obj.width = item_table.width
                obj.height = item_table.height - 2
                d.editPosition = obj
            }
            onDoubleClicked:{
                if(typeof(display) == "object"){
                    return
                }
                d.editDelegate = d.getEditDelegate(column)
                updateEditPosition()
                loader_edit.display = display
            }
            onClicked:
                (event)=>{
                    d.current = rowModel
                    event.accepted = true
                }
            Rectangle{
                anchors.fill: parent
                color:{
                    if(item_table.isRowSelected){
                        return control.selectedColor
                    }
                    if(d.rowHoverIndex === row || item_table.isRowSelected){
                        return FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
                    }
                    return (row%2!==0) ? control.color : (FluTheme.dark ? Qt.rgba(1,1,1,0.015) : Qt.rgba(0,0,0,0.015))
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
                        visible: column === control.columnSource.length-1
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
            FluLoader{
                anchors.fill: parent
                id:item_table_loader
                property var rowModel : model.rowModel
                property var columnModel : model.columnModel
                property int row : model.row
                property int column: model.column
                property var display: item_table.display
                property bool isRowSelected: d.current === rowModel
                property var options: {
                    if(isObject){
                        return display.options
                    }
                    return {}
                }
                sourceComponent: {
                    if(column === 0)
                        return com_column
                    if(item_table.isObject){
                        return item_table.display.comId
                    }
                    return com_other
                }
            }
        }
        FluLoader{
            id:loader_edit
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
            signal editTextChaged(string text)
            sourceComponent: d.editPosition ? d.editDelegate : undefined
            onEditTextChaged:
                (text)=>{
                    const obj = tree_model.getRow(row).data
                    obj[control.columnSource[column].dataIndex] = text
                    tree_model.setRow(row,obj)
                }
            width: {
                if(d.editPosition){
                    return d.editPosition.width
                }
                return 0
            }
            height: {
                if(d.editPosition){
                    return d.editPosition.height
                }
                return 0
            }
            x:{
                if(d.editPosition){
                    return d.editPosition.x
                }
                return 0
            }
            y:{
                if(d.editPosition){
                    return d.editPosition.y
                }
                return 0
            }
            z:999
        }
    }
    TableModel{
        id:header_column_model
        TableModelColumn {}
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
    Component{
        id:com_column_header_delegate
        Rectangle{
            id:column_item_control
            readonly property real cellPadding: 8
            property bool canceled: false
            property int columnIndex: column
            property var columnObject : control.columnSource[column]
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

                    }
            }
            FluLoader{
                id:item_column_loader
                property var itemModel: model
                property var modelData: model.display
                property var tableView: table_view
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
        id: header_horizontal
        model: header_column_model
        anchors{
            left: table_view.left
            right: table_view.right
            top: parent.top
        }
        height: Math.max(1, contentHeight)
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        syncDirection: Qt.Horizontal
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

    Component{
        id:com_item_text
        Item{
            width: item_text.width
            FluText {
                id:item_text
                text: model.title
                rightPadding: 14
                anchors.centerIn: parent
                color:{
                    if(itemMouse.pressed){
                        return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                    }
                    return FluTheme.dark ? FluColors.White : FluColors.Grey220
                }
            }
        }
    }
    function count(){
        return tree_model.dataSourceSize
    }
    function visibleCount(){
        return table_view.rows
    }
    function collapse(rowIndex){
        tree_model.collapse(rowIndex)
    }
    function expand(rowIndex){
        tree_model.expand(rowIndex)
    }
    function allExpand(){
        tree_model.allExpand()
    }
    function allCollapse(){
        tree_model.allCollapse()
    }
    function customItem(comId,options={}){
        var o = {}
        o.comId = comId
        o.options = options
        return o
    }
    function closeEditor(){
        d.editPosition = undefined
        d.editDelegate = undefined
    }
    function selectionModel(){
        return tree_model.selectionModel()
    }
}
