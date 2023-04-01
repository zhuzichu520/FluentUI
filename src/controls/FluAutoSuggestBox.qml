import QtQuick
import QtQuick.Controls
import FluentUI

TextField{

    property var items:[]
    property int fontStyle: FluText.Body
    property string emptyText: "没有找到结果"
    property int pixelSize : FluTheme.textSize
    property int iconSource: 0
    property bool disabled: false
    signal itemClicked(var data)
    signal handleClicked
    property color normalColor: FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    property color disableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property color placeholderNormalColor: FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    property color placeholderFocusColor: FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color placeholderDisableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    QtObject{
        id:d
        property bool flagVisible: true
    }
    id:control
    width: 300
    enabled: !disabled
    color: {
        if(disabled){
            return disableColor
        }
        return normalColor
    }
    selectionColor: FluTheme.primaryColor.lightest
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    placeholderTextColor: {
        if(disabled){
            return placeholderDisableColor
        }
        if(focus){
            return placeholderFocusColor
        }
        return placeholderNormalColor
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

    FluIconButton{
        iconSource:FluentIcons.ChromeClose
        iconSize: 10
        width: 20
        height: 20
        opacity: 0.5
        visible: control.text !== ""
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: icon_right.visible ? 25 : 5
        }
        onClicked:{
            control.text = ""
        }
    }

    background: FluTextBoxBackground{
        inputItem: control
        FluIcon{
            id:icon_right
            iconSource: control.iconSource
            iconSize: 15
            opacity: 0.5
            visible: control.iconSource != 0
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 5
            }
        }
    }

    Component.onCompleted: {
        loadData()
    }

    Popup{
        id:control_popup
        y:control.height
        focus: false
        enter: Transition {
            NumberAnimation {
                property: "y"
                from:0
                to:control_popup.y
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
            width: control.width
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
                delegate:Control{
                    width: control.width
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
                                target: control
                                function onHandleClicked(){
                                    if((list_view.currentIndex === index)){
                                        handleClick(modelData)
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
    onTextChanged: {
        loadData()
        if(d.flagVisible){
            control_popup.visible = true
        }
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: control.echoMode !== TextInput.Password && menu.popup()
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
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

