import QtQuick
import QtQuick.Controls
import FluentUI

FluTextBox{
    property var items:[]
    property string emptyText: qsTr("No results found")
    property int autoSuggestBoxReplacement: FluentIcons.Search
    property int itemHeight: 38
    property int itemRows: 8
    property bool showSuggestWhenPressed: false
    property string textRole: "title"
    property var filter: function(item){
        if(item[textRole].indexOf(control.text)!==-1){
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
            control.updateText(modelData[textRole])
        }
        function loadData(){
            if(items==null){
                list_view.model = []
                return
            }
            list_view.model = items.filter(item => control.filter(item))
            list_view.currentIndex = -1
        }
        function navigateList(step) {
            if (list_view.count < 1) {
                return
            }
            let newIndex = list_view.currentIndex + step
            if (newIndex >= list_view.count) {
                newIndex = 0
            } else if (newIndex < 0) {
                newIndex = list_view.count - 1
            }
            list_view.currentIndex = newIndex
            list_view.positionViewAtIndex(newIndex, ListView.Contain)
        }
        function handleEnterReturn() {
            if (list_view.count > 0 && list_view.currentIndex !== -1) {
                d.handleClick(list_view.model[list_view.currentIndex])
            }
        }
    }
    onActiveFocusChanged: {
        if(!activeFocus){
            control_popup.visible = false
        }
    }
    Keys.onDownPressed: {
        d.navigateList(1)
    }
    Keys.onUpPressed: {
        d.navigateList(-1)
    }
    Keys.onEnterPressed: {
        d.handleEnterReturn()
    }
    Keys.onReturnPressed: {
        d.handleEnterReturn()
    }
    Popup{
        id:control_popup
        focus: false
        padding: 0
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }
        contentItem: FluClip{
            radius: [5,5,5,5]
            ListView{
                id: list_view
                anchors.fill: parent
                clip: true
                boundsBehavior: ListView.StopAtBounds
                ScrollBar.vertical: FluScrollBar {}
                header: Item{
                    width: control.width
                    height: visible ? control.itemHeight : 0
                    visible: list_view.count === 0
                    FluText{
                        text: emptyText
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
                highlight: Rectangle {
                    color: FluTheme.itemHoverColor
                }
                delegate:FluControl{
                    id: item_control
                    height: control.itemHeight
                    width: control.width
                    onClicked: {
                        d.handleClick(modelData)
                    }
                    background: Rectangle{
                        FluFocusRectangle{
                            visible: item_control.activeFocus
                            radius:4
                        }
                        color:  {
                            if(pressed){
                                return FluTheme.itemPressColor
                            }
                            if(hovered){
                                return FluTheme.itemHoverColor
                            }
                            return FluTheme.itemNormalColor
                        }
                    }
                    contentItem: FluText{
                        text: modelData[textRole]
                        leftPadding: 10
                        rightPadding: 10
                        verticalAlignment : Qt.AlignVCenter
                    }
                }
            }
        }
        background:Rectangle{
            id: rect_background
            implicitWidth: control.width
            implicitHeight: control.itemHeight*Math.min(Math.max(list_view.count,1),control.itemRows)
            radius: 5
            color: FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(1,1,1,1)
            border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1)
            FluShadow{
                radius: 5
            }
        }
    }
    onTextChanged: {
        control.showSuggest()
    }
    onPressed: {
        if(control.showSuggestWhenPressed){
            control.showSuggest()
        }
    }
    function showSuggest(){
        d.loadData()
        if(d.flagVisible){
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+rect_background.implicitHeight){
                control_popup.y = Qt.binding(function(){return control.height})
            } else if(pos.y>rect_background.implicitHeight){
                control_popup.y = -rect_background.implicitHeight
            } else {
                control_popup.y = d.window.height-(pos.y+rect_background.implicitHeight) - 1
            }
            control_popup.visible = true
        }
    }
    function updateText(text){
        d.flagVisible = false
        control.text = text
        d.flagVisible = true
    }
}
