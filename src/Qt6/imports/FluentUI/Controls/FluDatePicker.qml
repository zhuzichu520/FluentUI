import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluButton {
    property bool showYear: true
    property var current
    property string yearText: qsTr("Year")
    property string monthText: qsTr("Month")
    property string dayText: qsTr("Day")
    property string cancelText: qsTr("Cancel")
    property string okText: qsTr("OK")
    signal accepted()
    id:control
    implicitHeight: 30
    implicitWidth: 300
    Component.onCompleted: {
        if(current){
            const now = current;
            var year = text_year.text === control.yearText? now.getFullYear() : Number(text_year.text);
            var month = text_month.text === control.monthText? now.getMonth() + 1 : Number(text_month.text);
            var day =  text_day.text === control.dayText ? now.getDate() : Number(text_day.text);
            text_year.text = year
            text_month.text = month
            text_day.text = day
        }
    }
    Item{
        id:d
        property var window: Window.window
        property bool changeFlag: true
        property var rowData: ["","",""]
        visible: false
    }
    onClicked: {
        popup.showPopup()
    }
    Rectangle{
        id:divider_1
        width: 1
        x:  parent.width/3
        height: parent.height
        color: control.dividerColor
        visible: showYear
    }
    Rectangle{
        id:divider_2
        width: 1
        x: showYear ? parent.width*2/3 :  parent.width/2
        height: parent.height
        color: control.dividerColor
    }
    FluText{
        id:text_year
        anchors{
            left: parent.left
            right: divider_1.left
            top: parent.top
            bottom: parent.bottom
        }
        visible: showYear
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:control.yearText
        color: control.textColor
    }
    FluText{
        id:text_month
        anchors{
            left: showYear ? divider_1.right : parent.left
            right: divider_2.left
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:control.monthText
        color: control.textColor
    }
    FluText{
        id:text_day
        anchors{
            left: divider_2.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:control.dayText
        color: control.textColor
    }
    Menu{
        id:popup
        modal: true
        width: container.width
        height: container.height
        Overlay.modal: Item {}
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: FluTheme.animationEnabled ? 83 : 0
            }
        }
        exit:Transition {
            NumberAnimation {
                property: "opacity"
                from:1
                to:0
                duration: FluTheme.animationEnabled ? 83 : 0
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
                radius: 4
                width: 300
                height: 340
                color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
                MouseArea{
                    anchors.fill: parent
                }
                FluShadow{
                    radius: 4
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
                                        return  item_mouse.containsMouse ? Qt.lighter(FluTheme.primaryColor,1.1): FluTheme.primaryColor
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
                                            text_year.text = model
                                            list_view_2.model = generateMonthArray(1,12)
                                            text_month.text = list_view_2.model[list_view_2.currentIndex]

                                            list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex],list_view_2.model[list_view_2.currentIndex])
                                            text_day.text = list_view_3.model[list_view_3.currentIndex]
                                        }
                                        if(type === 1){
                                            text_month.text = model
                                            list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex],list_view_2.model[list_view_2.currentIndex])
                                            text_day.text = list_view_3.model[list_view_3.currentIndex]

                                        }
                                        if(type === 2){
                                            text_day.text = model
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
                        width: 100
                        height: parent.height
                        boundsBehavior:Flickable.StopAtBounds
                        ScrollBar.vertical: FluScrollBar {}
                        model: generateYearArray(1924,2048)
                        clip: true
                        preferredHighlightBegin: 0
                        preferredHighlightEnd: 0
                        highlightMoveDuration: 0
                        visible: showYear
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
                        color: control.dividerColor
                    }
                    ListView{
                        id:list_view_2
                        width: showYear ? 100 : 150
                        height: parent.height
                        clip: true
                        ScrollBar.vertical: FluScrollBar {}
                        preferredHighlightBegin: 0
                        preferredHighlightEnd: 0
                        highlightMoveDuration: 0
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
                        color: control.dividerColor
                    }
                    ListView{
                        id:list_view_3
                        width:  showYear ? 100 : 150
                        height: parent.height
                        clip: true
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
                    color: control.dividerColor
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
                        text: control.cancelText
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
                        text: control.okText
                        onClicked: {
                            d.changeFlag = false
                            popup.close()
                            const year = text_year.text
                            const month = text_month.text
                            const day = text_day.text
                            const date = new Date()
                            date.setFullYear(parseInt(year));
                            date.setMonth(parseInt(month) - 1);
                            date.setDate(parseInt(day));
                            date.setHours(0);
                            date.setMinutes(0);
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
            d.rowData[0] = text_year.text
            d.rowData[1] = text_month.text
            d.rowData[2] = text_day.text
            const now = new Date();
            var year = text_year.text === control.yearText? now.getFullYear() : Number(text_year.text);
            var month = text_month.text === control.monthText? now.getMonth() + 1 : Number(text_month.text);
            var day =  text_day.text === control.dayText ? now.getDate() : Number(text_day.text);
            list_view_1.currentIndex = list_view_1.model.indexOf(year)
            text_year.text = year
            list_view_2.model = generateMonthArray(1,12)
            list_view_2.currentIndex = list_view_2.model.indexOf(month)
            text_month.text = month
            list_view_3.model = generateMonthDaysArray(year,month)
            list_view_3.currentIndex = list_view_3.model.indexOf(day)
            text_day.text = day
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
                text_year.text = d.rowData[0]
                text_month.text = d.rowData[1]
                text_day.text = d.rowData[2]
            }
        }
    }
    function generateYearArray(startYear, endYear) {
        const yearArray = [];
        for (let year = startYear; year <= endYear; year++) {
            yearArray.push(year);
        }
        return yearArray;
    }
    function generateMonthArray(startMonth, endMonth) {
        const monthArray = [];
        for (let month = startMonth; month <= endMonth; month++) {
            monthArray.push(month);
        }
        return monthArray;
    }
    function generateMonthDaysArray(year, month) {
        const monthDaysArray = [];
        const lastDayOfMonth = new Date(year, month, 0).getDate();
        for (let day = 1; day <= lastDayOfMonth; day++) {
            monthDaysArray.push(day);
        }
        return monthDaysArray;
    }
}
