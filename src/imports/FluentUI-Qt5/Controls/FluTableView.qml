import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12
import FluentUI 1.0


Item {
    property var columns : []
    property var dataSource : []
    property int pageCurrent: 1
    property int itemCount: 1000
    property int pageCount: 10
    property int itemHeight: 56
    property bool pageVisible: true
    signal requestPage(int page,int count)
    id:control
    implicitHeight: layout_table.height
    QtObject{
        id:d
        property int columnsWidth: layout_table.headerItem.columnsWidth()
    }
    MouseArea{
        anchors.fill: parent
        preventStealing: true
    }
    ListModel{
        id:model_columns
    }
    ListModel{
        id:model_data_source
    }
    onColumnsChanged: {
        model_columns.clear()
        model_columns.append(columns)
    }
    onDataSourceChanged: {
        model_data_source.clear()
        model_data_source.append(dataSource)
    }

    Component{
        id:header_columns
        FluRectangle{
            id:layout_columns
            height: control.itemHeight
            width: parent.width
            color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            radius: [5,5,0,0]
            function columnsWidth(){
                var w = 0
                for(var i=0;i<repeater_columns.count;i++){
                    var item = repeater_columns.itemAt(i)
                    w=w+item.width
                }
                return w
            }
            function widthByColumnIndex(index){
                return repeater_columns.itemAt(index).width
            }
            Row{
                id:list_columns
                spacing: 0
                anchors.fill: parent
                Repeater{
                    id:repeater_columns
                    model: model_columns
                    delegate: Item{
                        id:item_column
                        property point clickPos: "0,0"
                        height: list_columns.height
                        width: model.width
                        FluText{
                            id:item_column_text
                            text:model.title
                            wrapMode: Text.WordWrap
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 14
                            }
                            font: FluTextStyle.BodyStrong
                        }
                        FluDivider{
                            id:item_divider
                            width: 1
                            height: 40
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            visible: index !== model_columns.count-1
                        }
                        MouseArea{
                            height: 40
                            width: 6
                            anchors.centerIn: item_divider
                            visible: item_divider.visible
                            cursorShape: Qt.SplitHCursor
                            onPressed:
                                (mouse)=>{
                                    clickPos = Qt.point(mouse.x, mouse.y)
                                }
                            preventStealing: true
                            onPositionChanged:
                                (mouse)=>{
                                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                                    var minimumWidth = item_column_text.implicitWidth+28
                                    if(model.minimumWidth){
                                        minimumWidth = model.minimumWidth
                                    }
                                    item_column.width = Math.max(item_column.width+delta.x,minimumWidth)
                                }
                        }
                    }
                }
            }
        }
    }

    Flickable{
        id:layout_flickable
        height: layout_table.height
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        contentWidth: layout_table.width
        clip:true
        ScrollBar.horizontal: FluScrollBar {
        }
        Rectangle{
            anchors.fill: layout_table
            radius: 5
            color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
        }
        ListView{
            id:layout_table
            height: contentHeight
            width: Math.max(layout_flickable.width,d.columnsWidth)
            clip:true
            interactive: false
            removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 167 }
            }
            header: header_columns
            footer: Item{
                height: pageVisible ? 54 : 0
                clip: true
                width: layout_table.width
                FluPagination{
                    id:pagination
                    height: 40
                    pageCurrent: control.pageCurrent
                    onPageCurrentChanged: control.pageCurrent = pageCurrent
                    itemCount: control.itemCount
                    pageCount: control.pageCount
                    onRequestPage:
                        (page,count)=> {
                            control.requestPage(page,count)
                        }
                    anchors{
                        top: parent.top
                        right: parent.right
                    }
                    Connections{
                        target: control
                        function onPageCurrentChanged(){
                            if (control.pageCurrent!==pagination.pageCurrent)
                            {
                                pagination.calcNewPage(control.pageCurrent)
                            }
                        }
                    }
                }
            }
            model:model_data_source
            delegate: Control{
                id:item_control
                height: maxHeight()
                width: layout_table.width
                property var model_values : getObjectValues(index)
                property var itemObject: getObject(index)
                property var listModel: model
                Rectangle{
                    anchors.fill: parent
                    color: {
                        if(item_control.hovered){
                            return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
                        }
                        return FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
                    }
                }
                FluDivider{
                    id:item_divider
                    width: parent.width
                    height: 1
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
                Row{
                    id: table_row
                    spacing: 0
                    anchors.fill: parent
                    Repeater{
                        id:repeater_rows
                        model: model_values
                        delegate:FluControl{
                            id:item_row_control
                            width: layout_table.headerItem.widthByColumnIndex(index)
                            height: item_control.height
                            focusPolicy:Qt.TabFocus
                            background: Item{
                                FluFocusRectangle{
                                    visible: item_row_control.activeFocus
                                    radius:8
                                }
                            }
                            Loader{
                                id:item_column_loader
                                property var model : modelData
                                property var dataModel : listModel
                                property var dataObject : itemObject
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                sourceComponent: {
                                    if(model.itemData instanceof Component){
                                        return model.itemData
                                    }
                                    return com_text
                                }
                            }
                            function columnHeight(){
                                return item_column_loader.item.height
                            }
                        }
                    }
                }
                function maxHeight(){
                    var h = 0
                    for(var i=0;i<repeater_rows.count;i++){
                        var item = repeater_rows.itemAt(i)
                        h=Math.max(h,item.columnHeight())
                    }
                    return h
                }
            }
        }
    }

    Component{
        id:com_text
        Item{
            height: table_value.implicitHeight + 20
            FluCopyableText{
                id:table_value
                text:String(model.itemData)
                width: Math.min(parent.width - 14,implicitWidth)
                wrapMode: Text.WordWrap
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 14
                }
                rightPadding: 14
                MouseArea{
                    id:item_mouse
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    acceptedButtons: Qt.NoButton
                }
                FluTooltip{
                    visible: item_mouse.containsMouse
                    text:parent.text
                    delay: 1000
                }
            }
        }
    }
    function getObject(index){
        return model_data_source.get(index)
    }
    function getObjectValues(index) {
        var obj = model_data_source.get(index)
        if(!obj)
            return
        var data = []
        for(var i=0;i<model_columns.count;i++){
            var item = model_columns.get(i)
            data.push({itemData:obj[item.dataIndex],width:item.width})
        }
        return data;
    }
    function remove(index){
        model_data_source.remove(index)
    }
}
