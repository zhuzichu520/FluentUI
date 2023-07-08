import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

FluTextBox{
    property var items:[]
    property string emptyText: "没有找到结果"
    property int autoSuggestBoxReplacement: FluentIcons.Search
    property var window : Window.window
    signal itemClicked(var data)
    signal handleClicked
    id:control
    width: 300
    Component.onCompleted: {
        loadData()
    }
    QtObject{
        id:d
        property bool flagVisible: true
    }
    Popup{
        id:control_popup
        y:control.height
        focus: false
//        modal: true
//        Overlay.modal: Item{}

        padding: 0
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: FluTheme.enableAnimation ? 83 : 0
            }
        }
        contentItem: FluRectangle{
            radius: [4,4,4,4]
            FluShadow{
                radius: 4
            }
            color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
            ListView{
                id:list_view
                anchors.fill: parent
                clip: true
                boundsBehavior: ListView.StopAtBounds
                ScrollBar.vertical: FluScrollBar {}
                header: Item{
                    width: control.width
                    height: visible ? 38 : 0
                    visible: list_view.count === 0
                    FluText{
                        text:emptyText
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
                delegate:FluControl{
                    id:item_control
                    height: 38
                    width: control.width
                    onClicked:{
                        handleClick(modelData)
                    }
                    background: Rectangle{
                        FluFocusRectangle{
                            visible: item_control.activeFocus
                            radius:4
                        }
                        color:  {
                            if(hovered){
                                return FluTheme.dark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                            }
                            return FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(0,0,0,0)
                        }
                    }
                    contentItem: FluText{
                        text:modelData.title
                        leftPadding: 10
                        rightPadding: 10
                        verticalAlignment : Qt.AlignVCenter
                    }
                }
            }
        }
        background: Item{
            id:container
            implicitWidth: control.width
            implicitHeight: 38*Math.min(Math.max(list_view.count,1),8)
        }
    }
    onTextChanged: {
        loadData()
        if(d.flagVisible){
            var pos = control.mapToItem(null, 0, 0)
            if(window.height>pos.y+control.height+container.height){
                control_popup.y = control.height
            } else if(pos.y>container.height){
                control_popup.y = -container.height
            } else {
                popup.y = window.height-(pos.y+container.height)
            }
            control_popup.visible = true
        }
    }
    function handleClick(modelData){
        control_popup.visible = false
        control.itemClicked(modelData)
        updateText(modelData.title)
    }
    function updateText(text){
        d.flagVisible = false
        control.text = text
        d.flagVisible = true
    }
    function loadData(){
        var result = []
        if(items==null){
            list_view.model = result
            return
        }
        items.map(function(item){
            if(item.title.indexOf(control.text)!==-1){
                result.push(item)
            }
        })
        list_view.model = result
    }
}
