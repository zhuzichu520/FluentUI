import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels
import FluentUI

Item {
    property int currentIndex : -1
    property var dataSource
    property bool showLine: true
    property bool draggable: false
    property color lineColor: FluTheme.dark ? Qt.rgba(111/255,111/255,111/255,1) : Qt.rgba(217/255,217/255,217/255,1)
    id:control
    QtObject {
        id:d
        property var current
        property int dropIndex: -1
        property var hoverItem
        property int hoverIndex: -1
        property bool itemPress: false
        property bool itemDragActive: false
        property bool isDropTopArea: false
        property int dragIndex: -1
        property color hitColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    }
    onDataSourceChanged: {
        tree_model.setDataSource(dataSource)
    }
    FluTreeModel{
        id:tree_model
    }
    Timer{
        id:timer_refresh
        interval: 10
        onTriggered: {
            table_view.forceLayout()
        }
    }
    Component{
        id:com_item_container
        Item{
            signal reused
            signal pooled

            onReused: {
                console.debug(itemModel.title)
            }
            onPooled: {
            }

            property bool isCurrent: d.current === itemModel
            id:item_container
            width: {
                var w = 46 + item_layout_text.width + 30*itemModel.depth
                if(control.width>w){
                    return control.width
                }
                return w
            }
            height: 30
            implicitWidth: width
            implicitHeight: height
            function toggle(){
                if(itemModel.isExpanded){
                    tree_model.collapse(rowIndex)
                }else{
                    tree_model.expand(rowIndex)
                }
            }
            Rectangle{
                width: 3
                height: 18
                radius: 1.5
                color: FluTheme.primaryColor.dark
                visible: isCurrent
                anchors{
                    left: parent.left
                    leftMargin: 6
                    verticalCenter: parent.verticalCenter
                }
            }
            MouseArea{
                id:item_mouse
                property point clickPos: Qt.point(0,0)
                anchors.fill: parent
                drag.target:control.draggable ? loader_container : undefined
                hoverEnabled: true
                drag.onActiveChanged: {
                    d.itemDragActive = drag.active
                    if(drag.active){
                        if(itemModel.isExpanded && itemModel.hasChildren()){
                            tree_model.collapse(rowIndex)
                        }
                        d.dragIndex = rowIndex
                        loader_container.sourceComponent = com_item_container
                    }
                }
                onPressed:
                    (mouse)=>{
                        d.itemPress = true
                        clickPos = Qt.point(mouse.x,mouse.y)
                        console.debug(clickPos)
                        loader_container.itemControl = itemControl
                        loader_container.itemModel = itemModel
                        var cellPosition = item_container.mapToItem(table_view, 0, 0)
                        loader_container.width = item_container.width
                        loader_container.height = item_container.height
                        loader_container.x = cellPosition.x
                        loader_container.y = cellPosition.y
                    }
                onClicked: {
                    d.current = itemModel
                }
                onDoubleClicked: {
                    if(itemModel.hasChildren()){
                        item_container.toggle()
                    }
                }
                onExited: {
                    d.hoverIndex = -1
                }
                onPositionChanged:
                    (mouse)=> {
                        var cellPosition = item_container.mapToItem(table_view, 0, 0)
                        if(mouse.y+cellPosition.y<0 || mouse.y+cellPosition.y>table_view.height){
                            d.hoverItem = undefined
                            d.hoverIndex = -1
                            d.dropIndex = -1
                            return
                        }
                        if((mouse.x-table_view.contentX)>table_view.width || (mouse.x-table_view.contentX)<0){
                            d.hoverItem = undefined
                            d.hoverIndex = -1
                            d.dropIndex = -1
                            return
                        }
                        var pos = FluTools.cursorPos()
                        var viewPos = table_view.mapToGlobal(0,0)
                        var y = table_view.contentY + pos.y-viewPos.y
                        var index = Math.floor(y/30)
                        if(item_mouse.pressed){
                            d.hoverItem = undefined
                            d.hoverIndex = -1
                        }else{
                            d.hoverItem = item_container
                            d.hoverIndex = index
                        }
                        if(!drag.active){
                            return
                        }
                        if(tree_model.hitHasChildrenExpanded(index) && y>index*30+15){
                            d.dropIndex = index + 1
                            d.isDropTopArea = true
                        }else{
                            d.dropIndex = index
                            if(y>index*30+15){
                                d.isDropTopArea = false
                            }else{
                                d.isDropTopArea = true
                            }
                        }
                    }
                onCanceled: {
                    loader_container.sourceComponent = undefined
                    d.itemPress = false
                    d.dropIndex = -1
                    d.dragIndex = -1
                }
                onReleased: {
                    d.itemPress = false
                    loader_container.sourceComponent = undefined
                    if(d.dropIndex !== -1){
                        tree_model.dragAnddrop(d.dragIndex,d.dropIndex,d.isDropTopArea)
                    }
                    d.dropIndex = -1
                    d.dragIndex = -1
                }
            }
            Drag.dragType: Drag.None
            Drag.active: item_mouse.drag.active
            Rectangle{
                id:item_line_drop_tip
                anchors{
                    left: parent.left
                    leftMargin: {
                        var count = itemModel.depth+1
                        if(itemModel.hasChildren()){
                            return 30*count - 8
                        }
                        return 30*count + 18
                    }
                    right: parent.right
                    rightMargin: 10
                    bottom: parent.bottom
                    bottomMargin: -1.5
                    top: undefined
                }
                states: [
                    State {
                        when:d.isDropTopArea
                        AnchorChanges {
                            target: item_line_drop_tip
                            anchors.top: item_container.top
                            anchors.bottom: undefined
                        }
                        PropertyChanges {
                            target: item_line_drop_tip
                            anchors.topMargin: -1.5
                        }
                    }
                ]
                height: 3
                radius: 1.5
                color: d.hitColor
                visible: d.dropIndex === rowIndex
                Rectangle{
                    width: 10
                    height: 10
                    radius: 5
                    border.width: 3
                    border.color: d.hitColor
                    color: FluTheme.dark ? FluColors.Black : FluColors.White
                    anchors{
                        top: parent.top
                        left: parent.left
                        topMargin: -3
                        leftMargin: -5
                    }
                }
            }
            FluRectangle{
                width: 1
                color: control.lineColor
                visible: control.showLine  && isItemLoader && itemModel.depth !== 0 && !itemModel.hasChildren()
                height: itemModel.hideLineFooter() ? parent.height/2 : parent.height
                anchors{
                    top: parent.top
                    right: layout_row.left
                    rightMargin: -9
                }
            }
            FluRectangle{
                height: 1
                color: control.lineColor
                visible: control.showLine && isItemLoader  && itemModel.depth !== 0 && !itemModel.hasChildren()
                width: 18
                anchors{
                    right: layout_row.left
                    rightMargin: -27
                    verticalCenter: parent.verticalCenter
                }
            }
            Repeater{
                model: Math.max(itemModel.depth-1,0)
                delegate: FluRectangle{
                    required property int index
                    width: 1
                    color: control.lineColor
                    visible: control.showLine && isItemLoader && itemModel.depth !== 0 && itemModel.hasNextNodeByIndex(index)
                    anchors{
                        top:parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 30*(index+2) - 8
                    }
                }
            }
            Rectangle{
                anchors.fill: parent
                radius: 4
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                border.color: d.hitColor
                border.width: d.dragIndex === rowIndex ? 1 : 0
                color: {
                    if(FluTheme.dark){
                        if(isCurrent){
                            return Qt.rgba(1,1,1,0.03)
                        }
                        return Qt.rgba(0,0,0,0)
                    }else{
                        if(isCurrent){
                            return Qt.rgba(0,0,0,0.06)
                        }
                        return Qt.rgba(0,0,0,0)
                    }
                }
            }
            RowLayout{
                id:layout_row
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 14 + 30*itemModel.depth
                Item{
                    opacity: itemModel.hasChildren()
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    TapHandler{
                        enabled: parent.opacity
                        onSingleTapped: {
                            item_container.toggle()
                        }
                    }
                    MouseArea{
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.NoButton
                        anchors.fill: parent
                    }
                    FluIcon{
                        rotation: itemModel.isExpanded?0:-90
                        iconSource:FluentIcons.ChevronDown
                        iconSize: 16
                        anchors.centerIn: parent
                    }
                }
                Item{
                    id:item_layout_text
                    Layout.preferredWidth: item_text.implicitWidth+14
                    Layout.preferredHeight:item_text.implicitHeight+14
                    Layout.alignment: Qt.AlignVCenter
                    FluText {
                        id:item_text
                        text: itemModel.title
                        anchors.centerIn: parent
                        color:{
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                    }
                }
            }
        }
    }
    Component{
        id:com_background
        Item{
            Rectangle{
                radius: 4
                anchors{
                    fill: parent
                    leftMargin: 6
                    rightMargin: 6
                }
                color:{
                    if(FluTheme.dark){
                        if(d.itemPress){
                            return Qt.rgba(1,1,1,0.06)
                        }
                        return Qt.rgba(1,1,1,0.03)
                    }else{
                        if(d.itemPress){
                            return Qt.rgba(0,0,0,0.06)
                        }
                        return Qt.rgba(0,0,0,0.03)
                    }
                }
            }
        }
    }
    ScrollView{
        id:scroll_view
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        Loader{
            id:loader_background
            y:{
                if(d.hoverItem){
                    var cellPosition = d.hoverItem.mapToItem(table_view, 0, 0)
                    return  cellPosition.y
                }
                return 0
            }
            width: {
                if(d.hoverItem){
                    return d.hoverItem.width
                }
                return 0
            }
            height: {
                if(d.hoverItem){
                    return d.hoverItem.height
                }
                return 0
            }
            sourceComponent: {
                if(d.hoverIndex === -1 || d.itemDragActive){
                    return undefined
                }
                return com_background
            }
        }
        TableView{
            id:table_view
            ScrollBar.horizontal: FluScrollBar{}
            ScrollBar.vertical: FluScrollBar{}
            boundsBehavior: Flickable.StopAtBounds
            model: tree_model
            clip: true
            anchors.fill: parent
            onContentYChanged:{
                timer_refresh.restart()
            }
            onWidthChanged: {
                timer_refresh.restart()
            }
            delegate: Item {
                id:item_control
                implicitWidth: item_loader_container.width
                implicitHeight: item_loader_container.height
                TableView.onReused: {
                    item_loader_container.item.reused()
                }
                TableView.onPooled: {
                    item_loader_container.item.pooled()
                }
                Loader{
                    property var itemControl: item_control
                    property var itemModel: modelData
                    property int rowIndex: row
                    property bool isItemLoader: true
                    id:item_loader_container
                    sourceComponent: com_item_container
                }
            }
        }
        Loader{
            id:loader_container
            property var itemControl
            property var itemModel
            property bool isItemLoader: false
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

}
