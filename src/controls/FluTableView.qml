import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {

    id:control
    property var columns : []
    property var dataSource : []
    property int pageCurrent: 1
    property int itemCount: 1000
    property int pageCount: 10
    property int itemHeight: 56
    signal requestPage(int page,int count)

    implicitHeight: layout_coumns.height + layout_table.height

    MouseArea{
        anchors.fill: parent
        preventStealing: true
    }

    ListModel{
        id:model_coumns
    }

    ListModel{
        id:model_data_source
    }

    onColumnsChanged: {
        model_coumns.clear()
        model_coumns.append(columns)
    }

    onDataSourceChanged: {
        model_data_source.clear()
        model_data_source.append(dataSource)
    }

    FluRectangle{
        id:layout_coumns
        height: control.itemHeight
        width: parent.width
        color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
        radius: [12,12,0,0]

        Row{
            id:list_coumns
            spacing: 0
            anchors.fill: parent
            Repeater{
                model: model_coumns
                delegate: Item{
                    height: list_coumns.height
                    width: model.width
                    FluText{
                        text:model.title
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 14
                        }
                        fontStyle: FluText.BodyStrong
                    }
                    FluDivider{
                        width: 1
                        height: 40
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        visible: index !== list_coumns.count-1
                    }
                }
            }
        }
    }

    Rectangle{
        anchors.fill: layout_table
        color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    }

    ListView{
        id:layout_table
        anchors{
            top: layout_coumns.bottom
            left: parent.left
            right: parent.right
        }
        height: contentHeight
        clip:true
        footer: Item{
            height: 50
            width:  layout_table.width
            FluPagination{
                id:pagination
                height: 40
                pageCurrent: control.pageCurrent
                itemCount: control.itemCount
                pageCount: control.pageCount
                onRequestPage:
                    (page,count)=> {
                        control.requestPage(page,count)
                    }
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
            }
        }
        model:model_data_source
        delegate: Item{
            height: list_coumns.height
            width: layout_table.width
            property var model_values : getObjectValues(index)
            property var itemObject: getObject(index)
            property var listModel: model
            Row{
                spacing: 0
                anchors.fill: parent
                Repeater{
                    model: model_values
                    delegate:Item{
                        height: list_coumns.height
                        width: modelData.width
                        Loader{
                            property var model : modelData
                            property var dataModel : listModel
                            property var dataObject : itemObject
                            anchors.fill: parent
                            sourceComponent: {
                                if(model.itemData instanceof Component){
                                    return model.itemData
                                }
                                return com_text
                            }
                        }
                    }
                }
            }
            FluDivider{
                width: parent.width
                height: 1
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
    }

    Component{
        id:com_text
        Item{
            MouseArea{
                id:item_mouse
                hoverEnabled: true
                anchors.fill: parent
            }
            FluText{
                text:String(model.itemData)
                width: parent.width - 14
                elide: Text.ElideRight
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 14
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
        for(var i=0;i<model_coumns.count;i++){
            var item = model_coumns.get(i)
            data.push({itemData:obj[item.dataIndex],width:item.width})
        }
        return data;
    }

}
