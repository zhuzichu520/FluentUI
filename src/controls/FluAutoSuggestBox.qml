import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

TextField{
    id:input
    width: 300
    property var values:[]
    color: FluTheme.isDark ? "#FFFFFF" : "#1A1A1A"
    selectionColor: {
        if(FluTheme.isDark){
            return FluTheme.primaryColor.lighter
        }else{
            return FluTheme.primaryColor.dark
        }
    }
    rightPadding: 30
    selectByMouse: true

    background: FluTextBoxBackground{
        inputItem: input

        FluIconButton{
            icon:FluentIcons.FA_close
            iconSize: 14
            width: 20
            height: 20
            opacity: 0.5
            visible: input.text !== ""
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 5
            }
            onClicked:{
                input.text = ""
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
        background: Rectangle{
            width: input.width
            radius: 4
            FluShadow{
                radius: 4
            }
            color: FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(243/255,241/255,240/255,1)
            height: 38*Math.min(Math.max(list_view.count,1),8)
            ListView{
                id:list_view
                signal closePopup
                anchors.fill: parent
                boundsBehavior: ListView.StopAtBounds
                clip: true
                header: Item{
                    width: input.width
                    height: visible ? 38 : 0
                    visible: list_view.count === 0
                    FluText{
                        text:"没有找到结果"
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 15
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar { }
                delegate: Item{
                    height: 38
                    width: input.width
                    Rectangle{
                        anchors.fill: parent
                        anchors.topMargin: 2
                        anchors.bottomMargin: 2
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        color:  {
                            if(item_mouse.containsMouse){
                                return FluTheme.isDark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(234/255,234/255,234/255,1)
                            }
                            return FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(243/255,241/255,240/255,1)
                        }
                        radius: 3
                        MouseArea{
                            id:item_mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                input_popup.close()
                                input.text = modelData
                            }
                        }
                        FluText{
                            text:modelData
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 10
                            }
                        }
                    }
                }
            }
        }
    }

    onTextChanged: {
        searchData()
    }

    function searchData(){
        var result = []
        values.map(function(item){
            if(item.indexOf(input.text)!==-1){
                result.push(item)
            }
        })
        list_view.model = result
    }

}

