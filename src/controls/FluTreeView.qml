import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtGraphicalEffects 1.15

Rectangle {
    id:root
    color: FluTheme.isDark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)

    enum TreeViewSelectionMode  {
        None,
        Single,
        Multiple
    }

    property int selectionMode: FluTreeView.None

    property var currentElement
    property var currentParentElement

    property var multipElement: []

    property var rootModel: tree_model.get(0).items

    signal itemClicked(var item)

    ListModel{
        id:tree_model
        ListElement{
            text: "根节点"
            expanded:true
            items:[]
        }
    }

    Component{
        id: delegate_root
        Column{
            width: calculateWidth()
            property var itemModel: model
            Repeater{
                id: repeater_first_level
                model: items
                delegate: delegate_items
            }
            function calculateWidth(){
                var w = 0;
                for(var i = 0; i < repeater_first_level.count; i++) {
                    var child = repeater_first_level.itemAt(i)
                    if(w < child.width_hint){
                        w = child.width_hint;
                    }
                }
                return w;
            }
        }
    }

    Component{
        id:delegate_items

        Column{
            id:item_layout

            property real level: (mapToItem(list_root,0,0).x+list_root.contentX)/0.001
            property var text: model.text??"Item"
            property bool isItems : (model.items !== undefined) && (model.items.count !== 0)
            property var items: model.items??[]
            property var expanded: model.expanded??true
            property int width_hint: calculateWidth()
            property bool singleSelected: currentElement === model
            property var itemModel: model

            function calculateWidth(){
                var w = Math.max(list_root.width, item_layout_row.implicitWidth + 10);
                if(expanded){
                    for(var i = 0; i < repeater_items.count; i++) {
                        var child = repeater_items.itemAt(i)
                        if(w < child.width_hint){
                            w = child.width_hint;
                        }
                    }
                }
                return w;
            }
            Item{
                id:item_layout_rect
                width: list_root.contentWidth
                height: item_layout_row.implicitHeight


                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color:{
                        if(FluTheme.isDark){
                            if(item_layout.singleSelected && selectionMode === FluTreeView.Single){
                                return Qt.rgba(62/255,62/255,62/255,1)
                            }
                            return (item_layout_mouse.containsMouse || item_layout_expanded.hovered)?Qt.rgba(62/255,62/255,62/255,1):Qt.rgba(50/255,50/255,50/255,1)
                        }else{
                            if(item_layout.singleSelected && selectionMode === FluTreeView.Single){
                                return Qt.rgba(244/255,244/255,244/255,1)
                            }
                            return (item_layout_mouse.containsMouse || item_layout_expanded.hovered)?Qt.rgba(244/255,244/255,244/255,1):Qt.rgba(253/255,253/255,253/255,1)
                        }
                    }

                    Rectangle{
                        width: 3
                        color:FluTheme.primaryColor.dark
                        visible: item_layout.singleSelected && (selectionMode === FluTreeView.Single)
                        radius: 3
                        height: 20
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea{
                        id:item_layout_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            item_layout_rect.onClickItem()
                        }
                    }
                }


                function onClickItem(){
                    if(selectionMode === FluTreeView.None){
                        itemClicked(model)
                    }
                    if(selectionMode === FluTreeView.Single){
                        currentElement = model
                        if(item_layout.parent.parent.parent.itemModel){
                            currentParentElement = item_layout.parent.parent.parent.itemModel
                        }else{
                            if(item_layout.parent.itemModel){
                                currentParentElement = item_layout.parent.itemModel
                            }
                        }
                    }
                    if(selectionMode === FluTreeView.Multiple){

                    }
                }

                RowLayout{
                    id:item_layout_row
                    anchors.verticalCenter: item_layout_rect.verticalCenter

                    Item{
                        width: 15*level
                        Layout.alignment: Qt.AlignVCenter
                    }

                    FluCheckBox{
                        text:""
                        checked: multipElement.includes(itemModel)
                        visible: selectionMode === FluTreeView.Multiple
                        checkClicked:function(){
                            if(checked){
                                multipElement = multipElement.filter((value) => value !== itemModel)
                            }else{
                                multipElement = [...multipElement,itemModel]
                            }
                        }
                    }

                    FluIconButton{
                        id:item_layout_expanded
                        color:"#00000000"
                        icon:item_layout.expanded?FluentIcons.FA_angle_down:FluentIcons.FA_angle_right
                        opacity: item_layout.isItems
                        onClicked: {
                            if(!item_layout.isItems){
                                item_layout_rect.onClickItem()
                                return
                            }
                            model.expanded = !model.expanded
                        }
                    }

                    FluText {
                        text:  item_layout.text
                        Layout.alignment: Qt.AlignVCenter
                        topPadding: 10
                        bottomPadding: 10
                    }
                }
            }

            Item{
                id:item_sub
                visible: {
                    if(!isItems){
                        return false
                    }
                    return item_layout.expanded??false
                }

                width: item_sub_layout.implicitWidth
                height: item_sub_layout.implicitHeight
                x:0.001
                Column{
                    id: item_sub_layout
                    Repeater{
                        id:repeater_items
                        model: item_layout.items
                        delegate: delegate_items
                    }
                }

            }

        }
    }

    ListView {
        id: list_root
        anchors.fill: parent
        delegate: delegate_root
        boundsBehavior: ListView.StopAtBounds
        contentWidth: contentItem.childrenRect.width
        model: tree_model
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        clip: true
        ScrollBar.vertical: ScrollBar { }
        ScrollBar.horizontal: ScrollBar { }
    }


    function updateData(items){
        rootModel.clear()
        rootModel.append(items)
    }

    function signleData(){
        return currentElement
    }

    function multipData(){
        return multipElement
    }

    function createItem(text="Title",expanded=true,items=[]){
        return {text:text,expanded:expanded,items:items};
    }


}
