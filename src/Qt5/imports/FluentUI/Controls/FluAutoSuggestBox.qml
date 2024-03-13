import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluTextBox{
    property var items:[]
    property string emptyText: qsTr("No results found")
    property int autoSuggestBoxReplacement: FluentIcons.Search
    property var filter: function(item){
        if(item.title.indexOf(control.text)!==-1){
            return true
        }
        return false
    }
    signal itemClicked(var data)
    id:control
    Component.onCompleted: {
        d.loadData()
    }
    Item{
        id:d
        property bool flagVisible: true
        property var window : Window.window
        function handleClick(modelData){
            control_popup.visible = false
            control.itemClicked(modelData)
            d.updateText(modelData.title)
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
                if(control.filter(item)){
                    result.push(item)
                }
            })
            list_view.model = result
        }
    }
    onActiveFocusChanged: {
        if(!activeFocus){
            control_popup.visible = false
        }
    }
    Popup{
        id:control_popup
        y:control.height
        focus: false
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
                        d.handleClick(modelData)
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
        d.loadData()
        if(d.flagVisible){
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+container.implicitHeight){
                control_popup.y = control.height
            } else if(pos.y>container.implicitHeight){
                control_popup.y = -container.implicitHeight
            } else {
                control_popup.y = d.window.height-(pos.y+container.implicitHeight)
            }
            control_popup.visible = true
        }
    }
}
