pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{

    property var navigationView

    function rename(item, newName){
        if(newName && newName.trim().length>0){
            item.title = newName;
        }
    }

    FluPaneItem{
        id:item_home
        count: 9
        title:Lang.home
        infoBadge:FluBadge{
            count: item_home.count
        }
        icon:FluentIcons.Home
        url:"qrc:/example/qml/page/T_Home.qml"
        onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push(url)
        }
        editDelegate: FluTextBox{
            text:item_home.title
        }
        menuDelegate: FluMenu{
            id:nav_item_right_menu
            width: 120
            FluMenuItem{
                text: "重命名"
                visible: true
                onClicked: {
                    item_home.showEdit = true
                }
            }
        }
    }

    FluPaneItemExpander{
        id:item_expander_basic_input
        title:Lang.basic_input
        icon:FluentIcons.CheckboxComposite
        editDelegate: FluTextBox{
            text:item_expander_basic_input.title
        }
        menuDelegate: FluMenu{
            FluMenuItem{
                text: "重命名"
                visible: true
                onClicked: {
                    item_expander_basic_input.showEdit = true
                }
            }
        }
        FluPaneItem{
            id:item_buttons
            count: 99
            infoBadge:FluBadge{
                count: item_buttons.count
            }
            title:"Buttons"
            image:"qrc:/example/res/image/control/Button.png"
            recentlyUpdated:true
            desc:"A control that responds to user input and raisesa Click event."
            url:"qrc:/example/qml/page/T_Buttons.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{
                item_buttons.count = 0
                navigationView.push(url)
            }
        }
        FluPaneItem{
            id:item_text
            title:"Text"
            count: 5
            infoBadge:FluBadge{
                count: item_text.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            url:"qrc:/example/qml/page/T_Text.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{
                item_text.count = 0
                navigationView.push(url)
            }
        }
        FluPaneItem{
            title:"Image"
            url:"qrc:/example/qml/page/T_Image.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Slider"
            image:"qrc:/example/res/image/control/Slider.png"
            recentlyUpdated:true
            desc:"A control that lets the user select from a rangeof values by moving a Thumb control along atrack."
            url:"qrc:/example/qml/page/T_Slider.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"CheckBox"
            image:"qrc:/example/res/image/control/Checkbox.png"
            recentlyUpdated:true
            desc:"A control that a user can select or clear."
            url:"qrc:/example/qml/page/T_CheckBox.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"RadioButton"
            url:"qrc:/example/qml/page/T_RadioButton.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"ToggleSwitch"
            url:"qrc:/example/qml/page/T_ToggleSwitch.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
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
            url:"qrc:/example/qml/page/T_TextBox.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TimePicker"
            url:"qrc:/example/qml/page/T_TimePicker.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"DatePicker"
            url:"qrc:/example/qml/page/T_DatePicker.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"CalendarPicker"
            url:"qrc:/example/qml/page/T_CalendarPicker.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"ColorPicker"
            url:"qrc:/example/qml/page/T_ColorPicker.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.surface
        icon:FluentIcons.SurfaceHub
        FluPaneItem{
            title:"InfoBar"
            image:"qrc:/example/res/image/control/InfoBar.png"
            recentlyUpdated:true
            desc:"An inline message to display app-wide statuschange information."
            url:"qrc:/example/qml/page/T_InfoBar.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Progress"
            url:"qrc:/example/qml/page/T_Progress.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"RatingControl"
            url:"qrc:/example/qml/page/T_RatingControl.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Badge"
            url:"qrc:/example/qml/page/T_Badge.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Rectangle"
            url:"qrc:/example/qml/page/T_Rectangle.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Clip"
            url:"qrc:/example/qml/page/T_Clip.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"StatusView"
            url:"qrc:/example/qml/page/T_StatusView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Carousel"
            url:"qrc:/example/qml/page/T_Carousel.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Expander"
            url:"qrc:/example/qml/page/T_Expander.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"StaggeredView"
            url:"qrc:/example/qml/page/T_StaggeredView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Watermark"
            url:"qrc:/example/qml/page/T_Watermark.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.popus
        icon:FluentIcons.ButtonMenu
        FluPaneItem{
            title:"Dialog"
            url:"qrc:/example/qml/page/T_Dialog.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            id:item_combobox
            title:"ComboBox"
            count: 9
            infoBadge:FluBadge{
                count: item_combobox.count
                color: Qt.rgba(250/255,173/255,20/255,1)
            }
            url:"qrc:/example/qml/page/T_ComboBox.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{
                item_combobox.count = 0
                navigationView.push("qrc:/example/qml/page/T_ComboBox.qml")
            }
        }
        FluPaneItem{
            title:"Tooltip"
            url:"qrc:/example/qml/page/T_Tooltip.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Menu"
            url:"qrc:/example/qml/page/T_Menu.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.navigation
        icon:FluentIcons.AllApps
        FluPaneItem{
            title:"Pivot"
            image:"qrc:/example/res/image/control/Pivot.png"
            recentlyAdded:true
            order:3
            desc:"Presents information from different sources in atabbed view."
            url:"qrc:/example/qml/page/T_Pivot.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"BreadcrumbBar"
            url:"qrc:/example/qml/page/T_BreadcrumbBar.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TabView"
            image:"qrc:/example/res/image/control/TabView.png"
            recentlyAdded:true
            order:1
            desc:"A control that displays a collection of tabs thatcan be used to display several documents."
            url:"qrc:/example/qml/page/T_TabView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TreeView"
            url:"qrc:/example/qml/page/T_TreeView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"TableView"
            image:"qrc:/example/res/image/control/DataGrid.png"
            recentlyAdded:true
            order:4
            desc:"The TableView control provides a flexible way to display a collection of data in rows and columns"
            url:"qrc:/example/qml/page/T_TableView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Pagination"
            url:"qrc:/example/qml/page/T_Pagination.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"MultiWindow"
            url:"qrc:/example/qml/page/T_MultiWindow.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"FlipView"
            image:"qrc:/example/res/image/control/FlipView.png"
            recentlyAdded:true
            order:2
            desc:"Presents a collection of items that the user canflip through, one item at a time."
            url:"qrc:/example/qml/page/T_FlipView.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:Lang.theming
        icon:FluentIcons.Brightness
        FluPaneItem{
            title:"Acrylic"
            url:"qrc:/example/qml/page/T_Acrylic.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Theme"
            url:"qrc:/example/qml/page/T_Theme.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Typography"
            url:"qrc:/example/qml/page/T_Typography.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Awesome"
            url:"qrc:/example/qml/page/T_Awesome.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    FluPaneItemExpander{
        title:"PaneItemExpander Disabled"
        icon: FluentIcons.Send
        disabled: true
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
            url:"qrc:/example/qml/page/T_QRCode.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Tour"
            url:"qrc:/example/qml/page/T_Tour.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Timeline"
            url:"qrc:/example/qml/page/T_Timeline.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Screenshot(Todo)"
            url:"qrc:/example/qml/page/T_Screenshot.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Captcha"
            url:"qrc:/example/qml/page/T_Captcha.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Chart"
            url:"qrc:/example/qml/page/T_Chart.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            title:"Http"
            url:"qrc:/example/qml/page/T_Http.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
        FluPaneItem{
            id:item_other
            title:"RemoteLoader"
            count: 99
            infoBadge:FluBadge{
                count: item_other.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            url:"qrc:/example/qml/page/T_RemoteLoader.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
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
            onDropped:{ FluApp.navigate("/hotload") }
        }
        FluPaneItem{
            title:"3D"
            url:"qrc:/example/qml/page/T_3D.qml"
            onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
            onTap:{ navigationView.push(url) }
        }
    }

    function getRecentlyAddedData(){
        var arr = []
        for(var i=0;i<children.length;i++){
            var item = children[i]
            if(item instanceof FluPaneItem && item.recentlyAdded){
                arr.push(item)
            }
            if(item instanceof FluPaneItemExpander){
                for(var j=0;j<item.children.length;j++){
                    var itemChild = item.children[j]
                    if(itemChild instanceof FluPaneItem && itemChild.recentlyAdded){
                        arr.push(itemChild)
                    }
                }
            }
        }
        arr.sort(function(o1,o2){ return o2.order-o1.order })
        return arr
    }

    function getRecentlyUpdatedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.recentlyUpdated){
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
