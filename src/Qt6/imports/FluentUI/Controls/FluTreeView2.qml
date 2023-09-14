import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels
import FluentUI

Rectangle {
    color:"#33000000"
    property var dataSource
    clip: true

    function iterateTree(treeData) {
        var comItem = Qt.createComponent("FluTreeItem.qml");
        if (comItem.status !== Component.Ready) {
            return
        }
        const stack = [{ node: treeData[0], depth: 0 , isExpanded: true, __parent: undefined}];
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
            table_model.appendRow({itemData:objItem})
            if (node.children && node.children.length > 0) {
                const children = node.children.reverse();
                for (const child of children) {
                    stack.push({ node: child, depth: depth + 1,isExpanded:true,__parent:objItem});
                }
            }
        }

        console.debug("共计：%1条数据".arg(table_model.rowCount))
    }



    onDataSourceChanged: {
        table_model.clear()

        iterateTree(dataSource)
    }

    TableModel {
        id:table_model
        TableModelColumn { display: "itemData" }
    }

    Component{
        id:com_item

        Rectangle {
            implicitWidth:  120 + 50*itemData.depth
            implicitHeight: 38
            RowLayout{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin:14+50*itemData.depth
                FluIcon{
                    rotation: itemData.isExpanded?0:-90
                    iconSource:FluentIcons.ChevronDown
                    iconSize: 15
                    Layout.alignment: Qt.AlignVCenter
                    Behavior on rotation {
                        enabled: FluTheme.enableAnimation
                        NumberAnimation{
                            duration: 167
                            easing.type: Easing.OutCubic
                        }
                    }
                    opacity: {
                        if(itemData.children){
                            return true
                        }
                        return false
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            itemData.isExpanded = !itemData.isExpanded
                        }
                    }
                }

                Rectangle{
                    radius: 4
                    Layout.preferredWidth: item_text.width+14
                    Layout.preferredHeight:item_text.height+14
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
                    Text {
                        id:item_text
                        text: itemData.title
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    TableView{
        id:table_view
        anchors.fill: parent
        ScrollBar.horizontal: FluScrollBar{}
        ScrollBar.vertical: FluScrollBar{}
        boundsBehavior: Flickable.StopAtBounds
        model: table_model
        delegate: Loader{
            property var itemData: display
            sourceComponent: {
                if(!itemData.__parent){
                    return com_item
                }
                if(itemData.__parent.isExpanded){
                    return com_item
                }
                return undefined
            }
        }
    }

}
