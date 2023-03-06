import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import QtGraphicalEffects 1.15

Rectangle {
    id:root
    color:"#eeeeee"

    ListModel{
        id:list_model
    }

    ListView {
        id: list_root
        anchors.fill: parent

        delegate: Rectangle{
            width: list_root.width
            height: 40
            FluText{
                anchors.centerIn: parent
                text:model.text
            }
        }
        model:list_model
        clip: true
    }


    function addItems(items:list<FluTreeItem>){
        items.map(item=>{
                      list_model.append({"text":item.text})
                      console.debug(item.text)
                  })
    }

    function createItem(text){
        var com = Qt.createComponent("FluTreeItem.qml")
        return com.createObject(root,{text:text})
    }

    Component.onCompleted: {
        addItems([createItem("item1"),createItem("item2")])
        //        var data=[{"text":"item1"},{"text":"item1"}]
        //        list_model.append(data)
    }



}
