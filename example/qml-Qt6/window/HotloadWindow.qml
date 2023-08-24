import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import example
import "qrc:///example/qml/component"

CustomWindow {

    id:window
    title:"热加载"
    width: 800
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    FileWatcher{
        id:watcher
        onFileChanged: {
            loader.reload()
        }
    }
    FluArea{
        anchors.fill: parent
        FluRemoteLoader{
            id:loader
            anchors.fill: parent
            statusMode: FluStatusViewType.Success
            lazy: true
            errorItem: Item{
                FluText{
                    text:loader.itemLodaer().sourceComponent.errorString()
                    color:"red"
                    anchors.fill: parent
                    wrapMode: Text.WrapAnywhere
                    padding: 20
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                }
            }
        }
        FluText{
            text:"拖入qml文件"
            font.pixelSize: 26
            anchors.centerIn: parent
            visible: !loader.itemLodaer().item && loader.statusMode === FluStatusViewType.Success
        }
        Rectangle{
            radius: 4
            anchors.fill: parent
            color: "#33333333"
            visible: drop_area.containsDrag
        }
        DropArea{
            id:drop_area
            anchors.fill: parent
            onEntered:
                (event)=>{
                    if(!event.hasUrls){
                        event.accepted = false
                        return
                    }
                    if (event.urls.length !== 1) {
                        event.accepted = false
                        return
                    }
                    var url = event.urls[0].toString()
                    var fileExtension = url.substring(url.lastIndexOf(".") + 1)
                    if (fileExtension !== "qml") {
                        event.accepted = false
                        return
                    }
                    return true
                }
            onDropped:
                (event)=>{
                    var path = event.urls[0].toString()
                    loader.source = path
                    watcher.path = path
                    loader.reload()
                }
        }
    }

}
