import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {

    id:control
    property int displayMode: FluCalenderView.Month

    property var date: new Date()

    property var currentDate : new Date()

    enum DisplayMode {
        Month,
        Year,
        Decade
    }

    Component.onCompleted: {
        updateMouth(date)
    }

    function createItemWeek(name){
        return {type:0,name:name}
    }

    function createItemDay(date){
        return {type:1,date:date}
    }

    function createItemMonth(name){
        return {type:2,name:name}
    }


    function updateYear(data){
        list_model.clear()
        var year = date.getFullYear()
        var month = date.getMonth()
        var nextMonthYear = year
        var nextMonth = month + 1
        if (month === 11) {
            nextMonthYear = year + 1
            nextMonth = 0
        }

        for(var i = 0 ; i< 12 ;i++){
            list_model.append(createItemMonth((i+1)+"月"));
        }
        list_model.append(createItemMonth("1月"));
        list_model.append(createItemMonth("2月"));
        list_model.append(createItemMonth("3月"));
        list_model.append(createItemMonth("4月"));
    }

    function updateMouth(date){
        list_model.clear()
        list_model.append([createItemWeek("一"),createItemWeek("二"),createItemWeek("三"),createItemWeek("四"),createItemWeek("五"),createItemWeek("六"),createItemWeek("日")])
        var year = date.getFullYear()
        var month = date.getMonth()
        var day =  date.getDate()
        var firstDayOfMonth = new Date(year, month, 1)
        var dayOfWeek = firstDayOfMonth.getDay()
        var headerSize = (dayOfWeek===0?7:dayOfWeek)-1
        if(headerSize!==0){
            var lastMonthYear = year;
            var lastMonthMonth = month - 1
            if (month === 0) {
                lastMonthYear = year - 1
                lastMonthMonth = 11
            }
            var lastMonthDays = new Date(lastMonthYear, lastMonthMonth+1, 0).getDate()
            for (var i = headerSize-1; i >= 0; i--) {
                list_model.append(createItemDay(new Date(lastMonthYear, lastMonthMonth,lastMonthDays-i)))
            }
        }
        const lastDayOfMonth = new Date(year, month+1, 0).getDate()
        for (let day = 1; day <= lastDayOfMonth; day++) {
            list_model.append(createItemDay(new Date(year, month,day)))
        }
        var footerSize = 49-list_model.count
        var nextMonthYear = year
        var nextMonth = month + 1
        if (month === 11) {
            nextMonthYear = year + 1
            nextMonth = 0
        }
        const nextDayOfMonth = new Date(nextMonthYear, nextMonth+1, 0).getDate()
        for (let j = 1; j <= nextDayOfMonth; j++) {
            list_model.append(createItemDay(new Date(nextMonthYear, nextMonth,j)))
        }
        title.text = year+"年"+(month+1)+"月"
    }


    Component{
        id:com_week
        Item{
            height: 40
            width: 40
            FluText{
                text:name
                anchors.centerIn: parent
            }
        }
    }

    Component{
        id:com_month
        Item{
//            property bool isYear: control.date.getFullYear() === date.getFullYear()
//            property bool isMonth: control.currentDate.getFullYear() === date.getFullYear() && control.currentDate.getMonth()
            height: 70
            width: 70

            Rectangle{
                id:backgound_selected
                anchors.centerIn: parent
                width: 50
                height: 50
                radius: 25
                visible: false
                color: FluTheme.primaryColor.dark
            }

            FluText{
                text:name
                anchors.centerIn: parent
                color: {
//                    if(isMonth){
//                        return "#FFFFFF"
//                    }
//                    if(isYear){
//                        return FluTheme.isDark ? "#FFFFFF" : "#1A1A1A"
//                    }
                    return Qt.rgba(150/255,150/255,150/255,1)
                }
            }
        }
    }


    Component{
        id:com_day
        Button{
            id:item_control
            property bool isMonth: control.date.getMonth() === date.getMonth()
            property bool isDay: control.currentDate.getFullYear() === date.getFullYear() && control.currentDate.getMonth() === date.getMonth() && control.currentDate.getDate() === date.getDate()
            height: 40
            width: 40
            onClicked: {
                currentDate = date
            }
            background: Item{
                Rectangle{
                    width: 36
                    height: 36
                    radius: 4
                    anchors.centerIn: parent
                    color:{
                        if(FluTheme.isDark){
                            if(item_control.hovered){
                                return Qt.rgba(1,1,1,0.05)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(item_control.hovered){
                                return Qt.rgba(0,0,0,0.05)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                }
                Rectangle{
                    id:backgound_selected
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    radius: 15
                    visible: isDay
                    color: FluTheme.primaryColor.dark
                }
                FluText{
                    text:date.getDate()
                    anchors.centerIn: parent
                    color: {
                        if(isDay){
                            return "#FFFFFF"
                        }
                        if(isMonth){
                            return FluTheme.isDark ? "#FFFFFF" : "#1A1A1A"
                        }
                        return Qt.rgba(150/255,150/255,150/255,1)
                    }
                }
            }
            contentItem: Item{}
        }
    }

    FluArea{
        width: 280
        height: 325
        radius: 5

        FluShadow{
            radius: 5
        }

        Rectangle{
            id:layout_divider
            height: 1
            width: parent.width
            color: FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
            anchors{
                top: parent.top
                topMargin: 45
            }
        }

        Item{
            id:layout_top
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: layout_divider.top
            }

            FluTextButton{
                id:title
                leftPadding: 0
                rightPadding: 0
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 14
                }
                onClicked:{
                    displayMode = FluCalenderView.Year
                    updateYear(data)
                }
            }

            FluIconButton{
                id:icon_up
                iconSource: FluentIcons.CaretUpSolid8
                iconSize: 10
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: icon_down.left
                    rightMargin: 14
                }
                onClicked: {
                    var year = date.getFullYear()
                    var month = date.getMonth()
                    var lastMonthYear = year;
                    var lastMonthMonth = month - 1
                    if (month === 0) {
                        lastMonthYear = year - 1
                        lastMonthMonth = 11
                    }
                    date = new Date(lastMonthYear,lastMonthMonth,1)
                    updateMouth(date)
                }
            }

            FluIconButton{
                id:icon_down
                iconSource: FluentIcons.CaretDownSolid8
                iconSize: 10
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 8
                }
                onClicked: {
                    var year = date.getFullYear()
                    var month = date.getMonth()
                    var nextMonthYear = year
                    var nextMonth = month + 1
                    if (month === 11) {
                        nextMonthYear = year + 1
                        nextMonth = 0
                    }
                    date = new Date(nextMonthYear,nextMonth,1)
                    updateMouth(date)
                }
            }
        }

        ListModel {
            id:list_model
        }

        Item{
            id:layout_bottom
            anchors{
                left: parent.left
                right: parent.right
                top: layout_divider.bottom
                bottom: parent.bottom
            }

            GridView{
                model: list_model
                anchors.fill: parent
                cellHeight: displayMode === FluCalenderView.Month ? 40 : 70
                cellWidth: displayMode === FluCalenderView.Month ? 40 : 70
                delegate: Loader{
                    property var modelData : model
                    property var name : model.name
                    property var date : model.date
                    sourceComponent: {
                        if(model.type === 0){
                            return com_week
                        }
                        if(model.type === 1){
                            return com_day
                        }
                        if(model.type === 2){
                            return com_month
                        }
                        return com_day
                    }
                }
            }
        }
    }
}
