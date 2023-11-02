import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Rectangle {
    property color dividerColor: FluTheme.dark ? Qt.rgba(77/255,77/255,77/255,1) : Qt.rgba(239/255,239/255,239/255,1)
    property color hoverColor: FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(61/255,61/255,61/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property int hourFormat: FluTimePickerType.H
    property int isH: hourFormat === FluTimePickerType.H
    property var current
    signal accepted()
    id:control
    color: {
        if(mouse_area.containsMouse){
            return hoverColor
        }
        return normalColor
    }
    height: 30
    width: 300
    radius: 4
    border.width: 1
    border.color: dividerColor
    Component.onCompleted: {
        if(current){
            var now = current;
            var hour
            var ampm;
            if(isH){
                hour  = now.getHours();
                if(hour>12){
                    ampm = "下午"
                    hour = hour-12
                }else{
                    ampm = "上午"
                }
            }else{
                hour = now.getHours();
            }
            hour = text_hour.text === "时"? hour.toString().padStart(2, '0') : text_hour.text
            var minute = text_minute.text === "分"? now.getMinutes().toString().padStart(2, '0') : text_minute.text
            ampm = text_ampm.text === "AM/PM"?ampm:text_ampm.text
            text_hour.text = hour
            text_minute.text = minute
            if(isH){
                text_ampm.text = ampm
            }
        }
    }
    Item{
        id:d
        property var window: Window.window
        property bool changeFlag: true
        property var rowData: ["","",""]
        visible: false


    }
    MouseArea{
        id:mouse_area
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            popup.showPopup()
        }
    }
    Rectangle{
        id:divider_1
        width: 1
        x: isH ? parent.width/3 : parent.width/2
        height: parent.height
        color: dividerColor
    }
    Rectangle{
        id:divider_2
        width: 1
        x:parent.width*2/3
        height: parent.height
        color: dividerColor
        visible: isH
    }
    FluText{
        id:text_hour
        anchors{
            left: parent.left
            right: divider_1.left
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"时"
    }
    FluText{
        id:text_minute
        anchors{
            left: divider_1.right
            right: isH ? divider_2.left : parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"分"
    }
    FluText{
        id:text_ampm
        visible: isH
        anchors{
            left: divider_2.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"AM/PM"
    }
    Menu{
        id:popup
        width: container.width
        height: container.height
        modal: true
        Overlay.modal: Item {}
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: FluTheme.enableAnimation ? 83 : 0
            }
        }
        exit:Transition {
            NumberAnimation {
                property: "opacity"
                from:1
                to:0
                duration: FluTheme.enableAnimation ? 83 : 0
            }
        }
        background:Item{
            FluShadow{
                radius: 4
            }
        }
        contentItem: Item{
            clip: true
            Rectangle{
                id:container
                height: 340
                width: 300
                radius: 4
                color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
                MouseArea{
                    anchors.fill: parent
                }
                RowLayout{
                    id:layout_content
                    spacing: 0
                    width: parent.width
                    height: 300
                    Component{
                        id:list_delegate
                        Item{
                            height:38
                            width:getListView().width
                            function getListView(){
                                if(type === 0)
                                    return list_view_1
                                if(type === 1)
                                    return list_view_2
                                if(type === 2)
                                    return list_view_3
                            }
                            Rectangle{
                                anchors.fill: parent
                                anchors.topMargin: 2
                                anchors.bottomMargin: 2
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5
                                color:  {
                                    if(getListView().currentIndex === position){
                                        return  item_mouse.containsMouse ? Qt.darker(FluTheme.primaryColor,1.1) : FluTheme.primaryColor
                                    }
                                    if(item_mouse.containsMouse){
                                        return FluTheme.dark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                                    }
                                    return FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(0,0,0,0)
                                }
                                radius: 3
                                MouseArea{
                                    id:item_mouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        getListView().currentIndex = position
                                        if(type === 0){
                                            text_hour.text = model
                                        }
                                        if(type === 1){
                                            text_minute.text = model
                                        }
                                        if(type === 2){
                                            text_ampm.text = model
                                        }
                                    }
                                }
                                FluText{
                                    text:model
                                    color: {
                                        if(getListView().currentIndex === position){
                                            if(FluTheme.dark){
                                                return Qt.rgba(0,0,0,1)
                                            }else{
                                                return Qt.rgba(1,1,1,1)
                                            }
                                        }else{
                                            return FluTheme.dark ? "#FFFFFF" : "#1A1A1A"
                                        }
                                    }
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                    ListView{
                        id:list_view_1
                        width: isH ? 100 : 150
                        height: parent.height
                        boundsBehavior:Flickable.StopAtBounds
                        ScrollBar.vertical: FluScrollBar {}
                        preferredHighlightBegin: 0
                        preferredHighlightEnd: 0
                        highlightMoveDuration: 0
                        model: isH ? generateArray(1,12) : generateArray(0,23)
                        clip: true
                        delegate: FluLoader{
                            property var model: modelData
                            property int type:0
                            property int position:index
                            sourceComponent: list_delegate
                        }
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                        color: dividerColor
                    }
                    ListView{
                        id:list_view_2
                        width:  isH ? 100 : 150
                        height: parent.height
                        model: generateArray(0,59)
                        clip: true
                        preferredHighlightBegin: 0
                        preferredHighlightEnd: 0
                        highlightMoveDuration: 0
                        ScrollBar.vertical: FluScrollBar {}
                        boundsBehavior:Flickable.StopAtBounds
                        delegate: FluLoader{
                            property var model: modelData
                            property int type:1
                            property int position:index
                            sourceComponent: list_delegate
                        }
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                        color: dividerColor
                        visible: isH
                    }
                    ListView{
                        id:list_view_3
                        width: 100
                        height: 76
                        model: ["上午","下午"]
                        clip: true
                        visible: isH
                        preferredHighlightBegin: 0
                        preferredHighlightEnd: 0
                        highlightMoveDuration: 0
                        ScrollBar.vertical: FluScrollBar {}
                        Layout.alignment: Qt.AlignVCenter
                        boundsBehavior:Flickable.StopAtBounds
                        delegate: FluLoader{
                            property var model: modelData
                            property int type:2
                            property int position:index
                            sourceComponent: list_delegate
                        }
                    }
                }
                Rectangle{
                    width: parent.width
                    height: 1
                    anchors.top: layout_content.bottom
                    color: dividerColor
                }
                Rectangle{
                    id:layout_actions
                    height: 40
                    radius: 5
                    color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
                    anchors{
                        bottom:parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    Item {
                        id:divider
                        width: 1
                        height: parent.height
                        anchors.centerIn: parent
                    }
                    FluButton{
                        anchors{
                            left: parent.left
                            leftMargin: 20
                            rightMargin: 10
                            right: divider.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: "取消"
                        onClicked: {
                            popup.close()
                        }
                    }
                    FluFilledButton{
                        anchors{
                            right: parent.right
                            left: divider.right
                            rightMargin: 20
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        text: "确定"
                        onClicked: {
                            d.changeFlag = false
                            popup.close()
                            const hours = text_hour.text
                            const minutes = text_minute.text
                            const period = text_ampm.text
                            const date = new Date()
                            var hours24 = parseInt(hours);
                            if(control.hourFormat === FluTimePickerType.H){
                                if (hours === "12") {
                                    hours24 = (period === "上午") ? 0 : 12;
                                } else {
                                    hours24 = (period === "上午") ? hours24 : hours24 + 12;
                                }
                            }
                            date.setHours(hours24);
                            date.setMinutes(parseInt(minutes));
                            date.setSeconds(0);
                            current = date
                            control.accepted()
                        }
                    }
                }
            }
        }
        y:35
        function showPopup() {
            d.changeFlag = true
            d.rowData[0] = text_hour.text
            d.rowData[1] = text_minute.text
            d.rowData[2] = text_ampm.text
            var now = new Date();
            var hour
            var ampm;
            if(isH){
                hour  = now.getHours();
                if(hour>12){
                    ampm = "下午"
                    hour = hour-12
                }else{
                    ampm = "上午"
                }
            }else{
                hour = now.getHours();
            }
            hour = text_hour.text === "时"? hour.toString().padStart(2, '0') : text_hour.text
            var minute = text_minute.text === "分"? now.getMinutes().toString().padStart(2, '0') : text_minute.text
            ampm = text_ampm.text === "AM/PM"?ampm:text_ampm.text
            list_view_1.currentIndex = list_view_1.model.indexOf(hour);
            list_view_2.currentIndex = list_view_2.model.indexOf(minute);
            list_view_3.currentIndex = list_view_3.model.indexOf(ampm);
            text_hour.text = hour
            text_minute.text = minute
            if(isH){
                text_ampm.text = ampm
            }
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+container.height){
                popup.y = control.height
            } else if(pos.y>container.height){
                popup.y = -container.height
            } else {
                popup.y = d.window.height-(pos.y+container.height)
            }
            popup.open()
        }
        onClosed: {
            if(d.changeFlag){
                text_hour.text = d.rowData[0]
                text_minute.text = d.rowData[1]
                text_ampm.text = d.rowData[2]
            }
        }
    }
    function generateArray(start, n) {
        var arr = [];
        for (var i = start; i <= n; i++) {
            arr.push(i.toString().padStart(2, '0'));
        }
        return arr;
    }
}

