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
    property color lineColor: FluTheme.dark ? Qt.rgba(111/255,111/255,111/255,1) : Qt.rgba(217/255,217/255,217/255,1)
    id:control
    QtObject {
        id:d
        property var rowData: []
        function handleTree(treeData) {
            var comItem = Qt.createComponent("FluTreeItem.qml");
            if (comItem.status !== Component.Ready) {
                return
            }
            var stack = []
            var rawData = []
            for (var item of treeData) {
                stack.push({node:item,depth:0,isExpanded:true,__parent:undefined,__childIndex:0})
            }
            stack = stack.reverse()
            var index =0
            while (stack.length > 0) {
                const { node, depth,isExpanded,__parent,__childIndex} = stack.pop();
                node.depth = depth;
                node.isExpanded = isExpanded;
                node.__parent = __parent;
                node.__childIndex = __childIndex;
                var objItem = comItem.createObject(table_view);
                objItem.title = node.title
                objItem.key = node.key
                objItem.depth = node.depth
                objItem.isExpanded = node.isExpanded
                objItem.__parent = node.__parent
                objItem.children = node.children
                objItem.__childIndex = node.__childIndex
                objItem.index = index
                index = index + 1;
                rawData.push(objItem)
                if (node.children && node.children.length > 0) {
                    const children = node.children.reverse();
                    var childIndex = children.length-1
                    for (const child of children) {
                        stack.push({ node: child, depth: depth + 1,isExpanded:true,__parent:objItem,__childIndex:childIndex});
                        childIndex=childIndex-1;
                    }
                }
            }
            return rawData
        }
    }
    onDataSourceChanged: {
        d.rowData = d.handleTree(dataSource)
        tree_model.setData(d.rowData)
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
        reuseItems: false
        delegate: Item {
            property bool hasChildren: {
                if(display.children){
                    return true
                }
                return false
            }
            property var itemData: display
            property bool vlineVisible: display.depth !== 0 && control.showLine
            property bool hlineVisible: display.depth !== 0 && control.showLine && !hasChildren
            property bool isLastIndex : {
                if(display.__parent && display.__parent.children){
                    return display.__childIndex === display.__parent.children.length-1
                }
                return false
            }
            property bool isCurrent: control.currentIndex === row
            implicitWidth:  46 + item_layout_text.width + 30*display.depth
            implicitHeight: 30
            Rectangle{
                width: 1
                color: control.lineColor
                visible: hlineVisible
                height: isLastIndex ? parent.height/2 : parent.height
                anchors{
                    top: parent.top
                    right: layout_row.left
                }
            }
            Rectangle{
                height: 1
                color: control.lineColor
                visible: hlineVisible
                width: 18
                anchors{
                    right: layout_row.left
                    rightMargin: -18
                    verticalCenter: parent.verticalCenter
                }
            }
            Repeater{
                model: Math.max(display.depth-1,0)
                delegate: Rectangle{
                    required property int index
                    width: 1
                    color: control.lineColor
                    visible: vlineVisible
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
                anchors.leftMargin: 14 + 30*display.depth
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    enabled: opacity
                    opacity: hasChildren
                    contentItem: FluIcon{
                        rotation: itemData.isExpanded?0:-90
                        iconSource:FluentIcons.ChevronDown
                        iconSize: 16
                        Behavior on rotation{
                            NumberAnimation{
                                duration: FluTheme.enableAnimation ? 167 : 0
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    onClicked: {
                        var isExpanded = !itemData.isExpanded
                        itemData.isExpanded = isExpanded
                        var i,obj
                        if(isExpanded){
                            for( i=0;i<d.rowData.length;i++){
                                obj = d.rowData[i]
                                if(obj === itemData){
                                    var data = []
                                    for(var j=i+1;j<d.rowData.length;j++){
                                        obj = d.rowData[j]
                                        if(obj.depth === itemData.depth){
                                            break
                                        }
                                        if(obj.__expanded){
                                            data.push(obj)
                                        }
                                    }
                                    tree_model.insertRows(row+1,data)
                                    break
                                }
                            }
                        }else{
                            var removeCount = 0
                            for( i=row+1;i<tree_model.rowCount();i++){
                                obj = tree_model.getRow(i)
                                if(obj.depth === itemData.depth){
                                    break
                                }
                                removeCount = removeCount + 1;
                            }
                            tree_model.removeRows(row+1,removeCount)
                        }
                    }
                }
                Rectangle{
                    id:item_layout_text
                    radius: 4
                    Layout.preferredWidth: item_text.implicitWidth+14
                    Layout.preferredHeight:item_text.implicitHeight+14
                    Layout.alignment: Qt.AlignVCenter
                    Rectangle{
                        width: 3
                        height: 18
                        radius: 1.5
                        color: FluTheme.primaryColor.dark
                        visible: isCurrent
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea{
                        id:item_text_mousearea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            control.currentIndex = row
                        }
                    }
                    color: {
                        if(FluTheme.dark){
                            if(item_text_mousearea.containsMouse || isCurrent){
                                return Qt.rgba(1,1,1,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(item_text_mousearea.containsMouse || isCurrent){
                                return Qt.rgba(0,0,0,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                    FluText {
                        id:item_text
                        text: display.title
                        anchors.centerIn: parent
                        color:{
                            if(item_text_mousearea.pressed){
                                return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                            }
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                    }
                }
            }
        }
    }
    function count(){
        return d.rowData.length
    }
    function visibleCount(){
        return table_view.rows
    }
}
