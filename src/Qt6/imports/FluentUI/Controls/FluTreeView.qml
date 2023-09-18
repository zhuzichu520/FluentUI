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
                console.debug("----->onReused")
            }
            onPooled: {
                console.debug("----->onPooled")
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
                        if(item_mouse.containsMouse){
                            return Qt.rgba(1,1,1,0.03)
                        }
                        return Qt.rgba(0,0,0,0)
                    }else{
                        if(isCurrent){
                            return Qt.rgba(0,0,0,0.06)
                        }
                        if(item_mouse.containsMouse){
                            return Qt.rgba(0,0,0,0.03)
                        }
                        return Qt.rgba(0,0,0,0)
                    }
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
                onPressed: {
                    loader_container.itemControl = itemControl
                    loader_container.itemModel = itemModel
                    var cellPosition = item_container.mapToItem(table_view, 0, 0)
                    loader_container.width = item_container.width
                    loader_container.height = item_container.height
                    loader_container.x = table_view.contentX + cellPosition.x
                    loader_container.y = table_view.contentY + cellPosition.y

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
                        var y = loader_container.y
                        var index = Math.round(y/30)
                        if(index !== d.dragIndex){
                            d.dropIndex = index
                        }else{
                            d.dropIndex = -1
                        }
                    }
                onCanceled: {
                    loader_container.sourceComponent = undefined
                    d.dropIndex = -1
                    d.dragIndex = -1
                }
                onReleased: {
                    loader_container.sourceComponent = undefined
                    if(d.dropIndex !== -1){
                        tree_model.dragAnddrop(d.dragIndex,d.dropIndex)
                    }
                    d.dropIndex = -1
                    d.dragIndex = -1
                }
            }
            Drag.active: item_mouse.drag.active
            Rectangle{
                anchors{
                    left: parent.left
                    leftMargin: {
                        if(itemModel.hasChildren()){
                            return 30*(itemModel.depth+1) - 8
                        }
                        return 30*(itemModel.depth+1) + 18
                    }
                    right: parent.right
                    rightMargin: 10
                    bottom: parent.bottom
                }
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
                visible: itemModel.depth !== 0 && control.showLine && !itemModel.hasChildren()
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
                visible: itemModel.depth !== 0 && control.showLine && !itemModel.hasChildren()
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
                    visible: itemModel.depth !== 0 && control.showLine
                    anchors{
                        top:parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 30*(index+2) - 8
                    }
                }
            }
            RowLayout{
                id:layout_row
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 14 + 30*itemModel.depth
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    enabled: opacity
                    opacity: itemModel.hasChildren()
                    contentItem: FluIcon{
                        rotation: itemModel.isExpanded?0:-90
                        iconSource:FluentIcons.ChevronDown
                        iconSize: 16
                    }
                    onClicked: {
                        item_container.toggle()
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
                            if(item_mouse.pressed){
                                return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                            }
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                    }
                }
            }
        }
    }
    ScrollView{
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
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
                    id:item_loader_container
                    sourceComponent: com_item_container
                }
            }
        }

        Loader{
            id:loader_container
            property var itemControl
            property var itemModel
        }
    }
    function count(){
        return tree_model.dataSourceSize
    }
    function visibleCount(){
        return table_view.rows
    }
}
