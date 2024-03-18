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
    property int cellHeight: 30
    property int depthPadding: 30
    property bool checkable: false
    property color lineColor: FluTheme.dark ? Qt.rgba(111/255,111/255,111/255,1) : Qt.rgba(217/255,217/255,217/255,1)
    id:control
    QtObject {
        id:d
        property int dy
        property var current
        property int dropIndex: -1
        property bool isDropTopArea: false
        property int dragIndex: -1
        property color hitColor: FluTheme.primaryColor
    }
    onDataSourceChanged: {
        tree_model.setDataSource(dataSource)
    }
    FluTreeModel{
        id:tree_model
    }
    ListView{
        id:table_view
        ScrollBar.horizontal: FluScrollBar{}
        ScrollBar.vertical: FluScrollBar{}
        boundsBehavior: Flickable.StopAtBounds
        model: tree_model
        anchors.fill: parent
        clip: true
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        contentWidth: contentItem.childrenRect.width
        reuseItems: true
        removeDisplaced : Transition{
            ParallelAnimation{
                NumberAnimation {
                    properties: "y"
                    duration: 167
                    from: d.dy + table_view.height
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 88
                    from: 0
                    to: 1
                }
            }
        }
        move: Transition {
            NumberAnimation { property: "y"; duration: 200 }
        }
        add: Transition{
            ParallelAnimation{
                NumberAnimation {
                    properties: "y"
                    duration: 167
                    from: d.dy - control.cellHeight
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 88
                    from: 0
                    to: 1
                }
            }
        }
        delegate: Item {
            id:item_control
            implicitWidth: item_loader_container.width
            implicitHeight: item_loader_container.height
            ListView.onReused: {
                item_loader_container.item.reused()
            }
            ListView.onPooled: {
                item_loader_container.item.pooled()
            }
            FluLoader{
                property var itemControl: item_control
                property var itemModel: dataModel
                property int rowIndex: index
                property bool isItemLoader: true
                id:item_loader_container
                sourceComponent: com_item_container
            }
        }
        FluLoader{
            id:loader_container
            property var itemControl
            property var itemModel
            property bool isItemLoader: false
        }
    }
    Component{
        id:com_item_container
        Item{
            signal reused
            signal pooled
            onReused: {

            }
            onPooled: {
            }
            property bool isCurrent: d.current === itemModel
            id:item_container
            width: {
                var w = 46 + item_loader_cell.width + control.depthPadding*itemModel.depth
                if(control.width>w){
                    return control.width
                }
                return w
            }
            height: control.cellHeight
            implicitWidth: width
            implicitHeight: height
            function toggle(){
                var pos = FluTools.cursorPos()
                var viewPos = table_view.mapToGlobal(0,0)
                d.dy = table_view.contentY + pos.y-viewPos.y
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
                color: FluTheme.primaryColor
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
                        clickPos = Qt.point(mouse.x,mouse.y)
                        loader_container.itemControl = itemControl
                        loader_container.itemModel = itemModel
                        var cellPosition = item_container.mapToItem(table_view, 0, 0)
                        loader_container.width = item_container.width
                        loader_container.height = item_container.height
                        loader_container.x = 0
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
                onPositionChanged:
                    (mouse)=> {
                        if(!drag.active){
                            return
                        }
                        var cellPosition = item_container.mapToItem(table_view, 0, 0)
                        if(mouse.y+cellPosition.y<0 || mouse.y+cellPosition.y>table_view.height){
                            d.dropIndex = -1
                            return
                        }
                        if((mouse.x-table_view.contentX)>table_view.width || (mouse.x-table_view.contentX)<0){
                            d.dropIndex = -1
                            return
                        }
                        var pos = FluTools.cursorPos()
                        var viewPos = table_view.mapToGlobal(0,0)
                        var y = table_view.contentY + pos.y-viewPos.y
                        var index = Math.floor(y/control.cellHeight)
                        if(index<0 || index>table_view.count-1){
                            d.dropIndex = -1
                            return
                        }
                        if(tree_model.hitHasChildrenExpanded(index) && y>index*control.cellHeight+control.cellHeight/2){
                            d.dropIndex = index + 1
                            d.isDropTopArea = true
                        }else{
                            d.dropIndex = index
                            if(y>index*control.cellHeight+control.cellHeight/2){
                                d.isDropTopArea = false
                            }else{
                                d.isDropTopArea = true
                            }
                        }
                    }
                onCanceled: {
                    loader_container.sourceComponent = undefined
                    loader_container.x = 0
                    loader_container.y = 0
                    d.dropIndex = -1
                    d.dragIndex = -1
                }
                onReleased: {
                    loader_container.sourceComponent = undefined
                    if(d.dropIndex !== -1){
                        tree_model.dragAnddrop(d.dragIndex,d.dropIndex,d.isDropTopArea)
                    }
                    d.dropIndex = -1
                    d.dragIndex = -1
                    loader_container.x = 0
                    loader_container.y = 0
                }
            }
            Drag.active: item_mouse.drag.active
            Rectangle{
                id:item_line_drop_tip
                anchors{
                    left: layout_row.left
                    leftMargin: 26
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
                    left: item_line_h.left
                }
            }
            FluRectangle{
                id:item_line_h
                height: 1
                color: control.lineColor
                visible: control.showLine && isItemLoader  && itemModel.depth !== 0 && !itemModel.hasChildren()
                width: depthPadding - 10
                anchors{
                    right: layout_row.left
                    rightMargin: -24
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
                        leftMargin: control.depthPadding*(index+1) + 24
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
                    if(isCurrent){
                        return FluTheme.itemCheckColor
                    }
                    if(item_mouse.containsMouse || item_check_box.hovered){
                        return FluTheme.itemHoverColor
                    }
                    if(item_loader_expand.item && item_loader_expand.item.hovered){
                        return FluTheme.itemHoverColor
                    }
                    return FluTheme.itemNormalColor
                }
            }
            RowLayout{
                id:layout_row
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 0
                anchors.leftMargin: 14 + control.depthPadding*itemModel.depth
                Component{
                    id:com_icon_btn
                    FluIconButton{
                        opacity: itemModel.hasChildren()
                        onClicked: {
                            item_container.toggle()
                        }
                        contentItem:FluIcon{
                            rotation: itemModel.isExpanded?0:-90
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
                    sourceComponent: itemModel.hasChildren() ? com_icon_btn : undefined
                    Layout.alignment: Qt.AlignVCenter
                }

                FluCheckBox{
                    id:item_check_box
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    Layout.leftMargin: 5
                    horizontalPadding:0
                    verticalPadding: 0
                    checked: itemModel.checked
                    enableAnimation:false
                    visible: control.checkable
                    padding: 0
                    clickListener: function(){
                        tree_model.checkRow(rowIndex,!itemModel.checked)
                    }
                    Layout.alignment: Qt.AlignVCenter
                }
                FluLoader{
                    property var dataModel: itemModel
                    property var itemMouse: item_mouse
                    id:item_loader_cell
                    Layout.leftMargin: 10
                    Layout.preferredWidth: {
                        if(item){
                            return item.width
                        }
                        return 0
                    }
                    Layout.fillHeight: true
                    sourceComponent:com_item_text
                }
            }
        }
    }
    Component{
        id:com_item_text
        Item{
            width: item_text.width
            FluText {
                id:item_text
                text: dataModel.title
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
    function selectionModel(){
        return tree_model.selectionModel
    }
    function count(){
        return tree_model.dataSourceSize
    }
    function visibleCount(){
        return table_view.count
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
