import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

TextField{

    property var items:[]
    property int fontStyle: FluText.Body
    property int pixelSize : FluTheme.textSize
    property int iconSource: 0
    property bool disabled: false
    signal itemClicked(var data)
    signal handleClicked
    QtObject{
        id:d
        property bool flagVisible: true
    }
    id:input
    width: 300
    enabled: !disabled
    color: {
        if(disabled){
            return FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        return FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    }
    selectionColor: FluTheme.primaryColor.lightest
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    placeholderTextColor: {
        if(disabled){
            return FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        if(focus){
            return FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
        }
        return FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    }
    rightPadding: icon_right.visible ? 50 : 30
    selectByMouse: true
    Keys.onUpPressed: {
        list_view.currentIndex = Math.max(list_view.currentIndex-1,0)
    }
    Keys.onDownPressed: {
        list_view.currentIndex = Math.min(list_view.currentIndex+1,list_view.count-1)
    }
    Keys.onEnterPressed:handleClicked()
    Keys.onReturnPressed:handleClicked()
    font.bold: {
        switch (fontStyle) {
        case FluText.Display:
            return true
        case FluText.TitleLarge:
            return true
        case FluText.Title:
            return true
        case FluText.SubTitle:
            return true
        case FluText.BodyStrong:
            return true
        case FluText.Body:
            return false
        case FluText.Caption:
            return false
        default:
            return false
        }
    }
    font.pixelSize: {
        switch (fontStyle) {
        case FluText.Display:
            return text.pixelSize * 4.857
        case FluText.TitleLarge:
            return text.pixelSize * 2.857
        case FluText.Title:
            return text.pixelSize * 2
        case FluText.SubTitle:
            return text.pixelSize * 1.428
        case FluText.Body:
            return text.pixelSize * 1.0
        case FluText.BodyStrong:
            return text.pixelSize * 1.0
        case FluText.Caption:
            return text.pixelSize * 0.857
        default:
            return text.pixelSize * 1.0
        }
    }
    background: FluTextBoxBackground{
        inputItem: input

        FluIconButton{
            iconSource:FluentIcons.ChromeClose
            iconSize: 10
            width: 20
            height: 20
            opacity: 0.5
            visible: input.text !== ""
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: icon_right.visible ? 25 : 5
            }
            onClicked:{
                input.text = ""
            }
        }

        FluIcon{
            id:icon_right
            iconSource: input.iconSource
            iconSize: 15
            opacity: 0.5
            visible: input.iconSource != 0
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 5
            }
        }
    }

    Component.onCompleted: {
        searchData()
    }

    Popup{
        id:input_popup
        y:input.height
        focus: false
        enter: Transition {
            NumberAnimation {
                property: "y"
                from:0
                to:input_popup.y
                duration: 150
            }
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: 150
            }
        }
        onVisibleChanged: {
            if(visible){
                list_view.currentIndex = -1
            }
        }
        background: Rectangle{
            width: input.width
            radius: 4
            FluShadow{
                radius: 4
            }
            color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
            height: 38*Math.min(Math.max(list_view.count,1),8)
            ListView{
                id:list_view
                anchors.fill: parent
                clip: true
                currentIndex: -1
                ScrollBar.vertical: FluScrollBar {}
                header: Item{
                    width: input.width
                    height: visible ? 38 : 0
                    visible: list_view.count === 0
                    FluText{
                        text:"没有找到结果"
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
                delegate:Control{
                    width: input.width
                    padding:10
                    background: Rectangle{
                        color:  {
                            if(list_view.currentIndex === index){
                                return FluTheme.dark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                            }
                            if(hovered){
                                return FluTheme.dark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                            }
                            return FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(0,0,0,0)
                        }
                        MouseArea{
                            id:mouse_area
                            anchors.fill: parent
                            Connections{
                                target: input
                                function onHandleClicked(){
                                    if((list_view.currentIndex === index)){
                                        mouse_area.handleClick()
                                    }
                                }
                            }
                            onClicked: handleClick(modelData)
                        }
                        Rectangle{
                            width: 3
                            color:FluTheme.primaryColor.dark
                            visible: list_view.currentIndex === index
                            radius: 3
                            height: 20
                            anchors{
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    contentItem: FluText{
                        text:modelData.title
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }

    function handleClick(modelData){
        input_popup.visible = false
        input.itemClicked(modelData)
        d.flagVisible = false
        input.text = modelData.title
        d.flagVisible = true
    }

    onTextChanged: {
        searchData()
        if(d.flagVisible){
            input_popup.visible = true
        }
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: menu.popup()
    }
    FluMenu{
        id:menu
        focus: false
        FluMenuItem{
            text: "剪切"
            visible: input.text !== ""
            onClicked: {
                input.cut()
            }
        }
        FluMenuItem{
            text: "复制"
            visible: input.selectedText !== ""
            onClicked: {
                input.copy()
            }
        }
        FluMenuItem{
            text: "粘贴"
            visible: input.canPaste
            onClicked: {
                input.paste()
            }
        }
        FluMenuItem{
            text: "全选"
            visible: input.text !== ""
            onClicked: {
                input.selectAll()
            }
        }
    }

    function searchData(){
        var result = []
        if(items==null){
            list_view.model = result
            return
        }
        items.map(function(item){
            if(item.title.indexOf(input.text)!==-1){
                result.push(item)
            }
        })
        list_view.model = result
    }

}

