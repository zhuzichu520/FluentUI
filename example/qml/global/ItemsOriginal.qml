pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{

    property var navigationView
    property var paneItemMenu

    function rename(item, newName){
        if(newName && newName.trim().length>0){
            item.title = newName;
        }
    }

    FluPaneItem{
        id:item_home
        count: 9
        title:Lang.home
        menuDelegate: paneItemMenu
        infoBadge:FluBadge{
            count: item_home.count
        }
        icon:FluentIcons.Home
        url:"qrc:/example/qml/page/T_Home.qml"
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push(url)
        }
    }

    FluPaneItemExpander{
        title:"PaneItemExpander Disabled"
        iconVisible: false
        disabled: true
    }

    FluPaneItemExpander{
        id:item_expander_basic_input
        title:Lang.basic_input
        icon:FluentIcons.CheckboxComposite
        FluPaneItem{
            id:item_buttons
            count: 99
            infoBadge:FluBadge{
                count: item_buttons.count
            }
            title:"Buttons"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/Button.png",recentlyUpdated:true,desc:"A control that responds to user input and raisesa Click event."})
            url:"qrc:/example/qml/page/T_Buttons.qml"
            onTap:{
                item_buttons.count = 0
                navigationView.push(url)
            }
        }
        FluPaneItem{
            id:item_text
            title:"Text"
            menuDelegate: paneItemMenu
            count: 5
            infoBadge:FluBadge{
                count: item_text.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            url:"qrc:/example/qml/page/T_Text.qml"
            onTap:{
                item_text.count = 0
                navigationView.push(url)
            }
        }
        FluPaneItem{
            title:"Image"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Image.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Slider"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/Slider.png",recentlyUpdated:true,desc:"A control that lets the user select from a rangeof values by moving a Thumb control along atrack."})
            url:"qrc:/example/qml/page/T_Slider.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"CheckBox"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/Checkbox.png",recentlyUpdated:true,desc:"A control that a user can select or clear."})
            url:"qrc:/example/qml/page/T_CheckBox.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"RadioButton"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_RadioButton.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"ToggleSwitch"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_ToggleSwitch.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"PaneItem Disabled"
            disabled: true
            icon: FluentIcons.Error
        }
    }

    FluPaneItemExpander{
        title:Lang.form
        icon:FluentIcons.GridView
        FluPaneItem{
            title:"TextBox"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_TextBox.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TimePicker"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_TimePicker.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"DatePicker"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_DatePicker.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"CalendarPicker"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_CalendarPicker.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"ColorPicker"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_ColorPicker.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"ShortcutPicker"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_ShortcutPicker.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.surface
        icon:FluentIcons.SurfaceHub
        FluPaneItem{
            title:"InfoBar"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/InfoBar.png",recentlyUpdated:true,desc:"An inline message to display app-wide statuschange information."})
            url:"qrc:/example/qml/page/T_InfoBar.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Progress"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Progress.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"RatingControl"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_RatingControl.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Badge"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Badge.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Rectangle"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Rectangle.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Clip"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Clip.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Carousel"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Carousel.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Expander"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Expander.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Watermark"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Watermark.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.layout
        icon:FluentIcons.DockLeft
        FluPaneItem{
            title:"StaggeredLayout"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_StaggeredLayout.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"SplitLayout"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_SplitLayout.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"StatusLayout"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_StatusLayout.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.popus
        icon:FluentIcons.ButtonMenu
        FluPaneItem{
            title:"Dialog"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Dialog.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            id:item_combobox
            title:"ComboBox"
            menuDelegate: paneItemMenu
            count: 9
            infoBadge:FluBadge{
                count: item_combobox.count
                color: Qt.rgba(250/255,173/255,20/255,1)
            }
            url:"qrc:/example/qml/page/T_ComboBox.qml"
            onTap:{
                item_combobox.count = 0
                navigationView.push("qrc:/example/qml/page/T_ComboBox.qml")
            }
        }
        FluPaneItem{
            title:"Tooltip"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Tooltip.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Menu"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Menu.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.navigation
        icon:FluentIcons.AllApps
        FluPaneItem{
            title:"Pivot"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/Pivot.png",order:3,recentlyAdded:true,desc:"Presents information from different sources in atabbed view."})
            url:"qrc:/example/qml/page/T_Pivot.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"BreadcrumbBar"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_BreadcrumbBar.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TabView"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/TabView.png",order:1,recentlyAdded:true,desc:"A control that displays a collection of tabs thatcan be used to display several documents."})
            url:"qrc:/example/qml/page/T_TabView.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TreeView"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_TreeView.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TableView"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/DataGrid.png",order:4,recentlyAdded:true,desc:"The TableView control provides a flexible way to display a collection of data in rows and columns"})
            url:"qrc:/example/qml/page/T_TableView.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Pagination"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Pagination.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"MultiWindow"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_MultiWindow.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"FlipView"
            menuDelegate: paneItemMenu
            extra:({image:"qrc:/example/res/image/control/FlipView.png",order:2,recentlyAdded:true,desc:"Presents a collection of items that the user canflip through, one item at a time."})
            url:"qrc:/example/qml/page/T_FlipView.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.theming
        icon:FluentIcons.Brightness
        FluPaneItem{
            title:"Acrylic"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Acrylic.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Theme"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Theme.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Typography"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Typography.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Awesome"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Awesome.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title: Lang.chart
        icon:FluentIcons.AreaChart
        FluPaneItem{
            title:Lang.bar_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_BarChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.line_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_LineChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.pie_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_PieChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.polar_area_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_PolarAreaChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.bubble_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_BubbleChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.scatter_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_ScatterChart.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:Lang.radar_chart
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/chart/T_RadarChart.qml"
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemSeparator{
        spacing:10
        size:1
    }

    FluPaneItemExpander{
        title:Lang.other
        icon:FluentIcons.Shop
        FluPaneItem{
            title:"QRCode"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_QRCode.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Tour"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Tour.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Timeline"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Timeline.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Screenshot(Todo)"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Screenshot.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Captcha"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Captcha.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Network"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_Network.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            id:item_other
            title:"RemoteLoader"
            menuDelegate: paneItemMenu
            count: 99
            infoBadge:FluBadge{
                count: item_other.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            url:"qrc:/example/qml/page/T_RemoteLoader.qml"
            onTap:{
                item_other.count = 0
                navigationView.push("qrc:/example/qml/page/T_RemoteLoader.qml")
            }
        }
        FluPaneItem{
            title:"HotLoader"
            onTapListener:function(){
                FluApp.navigate("/hotload")
            }
        }
        FluPaneItem{
            title:"3D"
            menuDelegate: paneItemMenu
            url:"qrc:/example/qml/page/T_3D.qml"
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Test Crash"
            visible: FluTools.isWin()
            onTapListener: function(){
                AppInfo.testCrash()
            }
        }
    }

    function getRecentlyAddedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyAdded){
                arr.push(item)
            }
        }
        arr.sort(function(o1,o2){ return o2.extra.order-o1.extra.order })
        return arr
    }

    function getRecentlyUpdatedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyUpdated){
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData(){
        if(!navigationView){
            return
        }
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem){
                if (item.parent instanceof FluPaneItemExpander)
                {
                    arr.push({title:`${item.parent.title} -> ${item.title}`,key:item.key})
                }
                else
                    arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }

    function startPageByItem(data){
        navigationView.startPageByItem(data)
    }

}
