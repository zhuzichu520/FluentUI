import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels
import FluentUI

Item {
    property var dataSource
    id:control
    QtObject {
        id:d
        signal refreshLayout()
        onRefreshLayout: {
            table_view.forceLayout()
        }
        function handleTree(treeData) {
            var comItem = Qt.createComponent("FluTreeItem.qml");
            if (comItem.status !== Component.Ready) {
                return
            }
            var stack = []
            var rawData = []
            for (var item of treeData) {
                stack.push({node:item,depth:0,isExpanded:true,__parent:undefined})
            }
            stack = stack.reverse()
            var index =0
            while (stack.length > 0) {
                const { node, depth,isExpanded,__parent} = stack.pop();
                node.depth = depth;
                node.isExpanded = isExpanded;
                node.__parent = __parent;
                var objItem = comItem.createObject(table_view);
                objItem.title = node.title
                objItem.key = node.key
                objItem.depth = node.depth
                objItem.isExpanded = node.isExpanded
                objItem.__parent = node.__parent
                objItem.children = node.children
                objItem.index = index
                index = index + 1;
                rawData.push({display:objItem})
                if (node.children && node.children.length > 0) {
                    const children = node.children.reverse();
                    for (const child of children) {
                        stack.push({ node: child, depth: depth + 1,isExpanded:true,__parent:objItem});
                    }
                }
            }
            return rawData
        }
    }
    onDataSourceChanged: {
        table_model.clear()
        var data = d.handleTree(dataSource)
        table_model.rows = data
        table_view.forceLayout()
        console.debug("共计：%1条数据".arg(table_model.rowCount))
    }
    TableModel {
        id:table_model
        TableModelColumn { display: "display" }
    }
    ListView{
        anchors.fill: parent
        TableView{
            id:table_view
            ScrollBar.horizontal: FluScrollBar{}
            ScrollBar.vertical: FluScrollBar{}
            boundsBehavior: Flickable.StopAtBounds
            model: table_model
            clip: true
            anchors.fill: parent
            rowHeightProvider: function(row) {
                if(table_model.getRow(row).display.__expanded){
                    return 38
                }
                return 0
            }
            delegate: Item {
                implicitWidth:  46 + item_layout_text.width + 30*display.depth
                RowLayout{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 14 + 30*display.depth
                    FluIcon{
                        rotation: display.isExpanded?0:-90
                        iconSource:FluentIcons.ChevronDown
                        iconSize: 15
                        Layout.alignment: Qt.AlignVCenter
                        opacity: {
                            if(display.children){
                                return true
                            }
                            return false
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                display.isExpanded = !display.isExpanded
                                d.refreshLayout()
                            }
                        }
                    }
                    Rectangle{
                        id:item_layout_text
                        radius: 4
                        Layout.preferredWidth: item_text.implicitWidth+14
                        Layout.preferredHeight:item_text.implicitHeight+14
                        Layout.alignment: Qt.AlignVCenter
                        HoverHandler{
                            id:item_hover_text
                        }
                        color: {
                            if(FluTheme.dark){
                                if(item_hover_text.hovered){
                                    return Qt.rgba(1,1,1,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_hover_text.hovered){
                                    return Qt.rgba(0,0,0,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }
                        }
                        FluText {
                            id:item_text
                            text: display.title
                            anchors.centerIn: parent
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                d.refreshLayout()
                            }
                        }
                    }
                }
            }
        }
    }
    function count(){
        return table_model.rowCount
    }
}
