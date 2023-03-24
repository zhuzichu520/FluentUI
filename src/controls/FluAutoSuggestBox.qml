import QtQuick
import QtQuick.Controls
import FluentUI

TextField{

    property var values:[]
    property int fontStyle: FluText.Body
    property int pixelSize : FluTheme.textSize
    property int iconSource: 0
    property bool disabled: false
    signal itemClicked(string data)

    id:input
    width: 300
    enabled: !disabled
    color: {
        if(disabled){
            return FluTheme.isDark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        return FluTheme.isDark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    }
    selectionColor: {
        if(FluTheme.isDark){
            return FluTheme.primaryColor.lighter
        }else{
            return FluTheme.primaryColor.dark
        }
    }
    renderType: FluTheme.isNativeText ? Text.NativeRendering : Text.QtRendering
    placeholderTextColor: {
        if(disabled){
            return FluTheme.isDark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        if(focus){
            return FluTheme.isDark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
        }
        return FluTheme.isDark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    }
    rightPadding: icon_right.visible ? 50 : 30
    selectByMouse: true

    Keys.onUpPressed: {
        list_view.currentIndex = Math.max(list_view.currentIndex-1,0)
    }

    Keys.onDownPressed: {
        list_view.currentIndex = Math.min(list_view.currentIndex+1,list_view.count-1)
    }

    signal handleClicked
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
        case FluText.Subtitle:
            return true
        case FluText.BodyLarge:
            return false
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
            return input.pixelSize * 4
        case FluText.TitleLarge:
            return input.pixelSize * 2
        case FluText.Title:
            return input.pixelSize * 1.5
        case FluText.Subtitle:
            return input.pixelSize * 0.9
        case FluText.BodyLarge:
            return input.pixelSize * 1.1
        case FluText.BodyStrong:
            return input.pixelSize * 1.0
        case FluText.Body:
            return input.pixelSize * 1.0
        case FluText.Caption:
            return input.pixelSize * 0.8
        default:
            return input.pixelSize * 1.0
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
        visible: input.focus
        y:input.height
        onClosed: {
            input.focus = false
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
            color: FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
            height: 38*Math.min(Math.max(list_view.count,1),8)
            ListView{
                id:list_view
                signal closePopup
                anchors.fill: parent
                boundsBehavior: ListView.StopAtBounds
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
                                return FluTheme.isDark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                            }
                            if(hovered){
                                return FluTheme.isDark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                            }
                            return FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(0,0,0,0)
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
                            onClicked: handleClick()
                            function handleClick(){
                                input_popup.close()
                                input.itemClicked(modelData)
                                input.text = modelData
                            }
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
                        text:modelData
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                    }

                }
                //                Item{
                //                    height: 38
                //                    width: input.width
                //                    Rectangle{
                //                        anchors.fill: parent
                //                        anchors.topMargin: 2
                //                        anchors.bottomMargin: 2
                //                        anchors.leftMargin: 5
                //                        anchors.rightMargin: 5

                //                        radius: 3
                //                        MouseArea{
                //                            id:item_mouse
                //                            anchors.fill: parent
                //                            hoverEnabled: true
                //                            onClicked: {
                //                                input_popup.close()
                //                                input.itemClicked(modelData)
                //                                input.text = modelData
                //                            }
                //                        }

                //                    }
                //                }
            }
        }
    }

    onTextChanged: {
        searchData()
    }

    function searchData(){
        var result = []
        if(values==null){
            list_view.model = result
            return
        }
        values.map(function(item){
            if(item.indexOf(input.text)!==-1){
                result.push(item)
            }
        })
        list_view.model = result
    }

}

