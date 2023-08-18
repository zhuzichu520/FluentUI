pragma Singleton

import QtQuick
import FluentUI

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
        title:lang.home
        infoBadge:FluBadge{
            count: item_home.count
        }
        icon:FluentIcons.Home
        onTap:{
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push("qrc:/example/qml/page/T_Home.qml")
        }
        rightMenu: FluMenu{
            property string renameText : "重命名"
            id:nav_item_right_menu
            enableAnimation: false
            width: 120

            FluMenuItem{
                text: nav_item_right_menu.renameText
                visible: true
                onClicked: {
                    item_home.editable = true;

                }
            }
        }
        onTitleEdited:function(newText){
            rename(item_home,newText)
        }
    }

    FluPaneItemExpander{
        id:item_expander_basic_input
        title:lang.basic_input
        icon:FluentIcons.CheckboxComposite

        rightMenu: FluMenu{
            property string renameText : "重命名"
            id:nav_item_expander_right_menu
            enableAnimation: false
            width: 120

            FluMenuItem{
                text: nav_item_expander_right_menu.renameText
                visible: true
                onClicked: {
                    item_expander_basic_input.editable = true;

                }
            }
        }
        onTitleEdited:function(newText){ rename(item_expander_basic_input,newText)}

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
            onTap:{
                item_buttons.count = 0
                navigationView.push("qrc:/example/qml/page/T_Buttons.qml")
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
            onTap:{
                item_text.count = 0
                navigationView.push("qrc:/example/qml/page/T_Text.qml")
            }
        }
        FluPaneItem{
            title:"Image"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Image.qml")
            }
        }
        FluPaneItem{
            title:"Slider"
            image:"qrc:/example/res/image/control/Slider.png"
            recentlyUpdated:true
            desc:"A control that lets the user select from a rangeof values by moving a Thumb control along atrack."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Slider.qml")
            }
        }
        FluPaneItem{
            title:"CheckBox"
            image:"qrc:/example/res/image/control/Checkbox.png"
            recentlyUpdated:true
            desc:"A control that a user can select or clear."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_CheckBox.qml")
            }
        }
        FluPaneItem{
            title:"RadioButton"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_RadioButton.qml")
            }
        }
        FluPaneItem{
            title:"ToggleSwitch"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_ToggleSwitch.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:lang.form
        icon:FluentIcons.GridView
        FluPaneItem{
            title:"TextBox"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_TextBox.qml")
            }
        }
        FluPaneItem{
            title:"TimePicker"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_TimePicker.qml")
            }
        }
        FluPaneItem{
            title:"DatePicker"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_DatePicker.qml")
            }
        }
        FluPaneItem{
            title:"CalendarPicker"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_CalendarPicker.qml")
            }
        }
        FluPaneItem{
            title:"ColorPicker"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_ColorPicker.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:lang.surface
        icon:FluentIcons.SurfaceHub
        FluPaneItem{
            title:"InfoBar"
            image:"qrc:/example/res/image/control/InfoBar.png"
            recentlyUpdated:true
            desc:"An inline message to display app-wide statuschange information."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_InfoBar.qml")
            }
        }
        FluPaneItem{
            title:"Progress"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Progress.qml")
            }
        }
        FluPaneItem{
            title:"RatingControl"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_RatingControl.qml")
            }
        }
        FluPaneItem{
            title:"Badge"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Badge.qml")
            }
        }
        FluPaneItem{
            title:"Rectangle"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Rectangle.qml")
            }
        }
        FluPaneItem{
            title:"StatusView"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_StatusView.qml")
            }
        }
        FluPaneItem{
            title:"Carousel"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Carousel.qml")
            }
        }
        FluPaneItem{
            title:"Expander"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Expander.qml")
            }
        }
        FluPaneItem{
            title:"Watermark"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Watermark.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:lang.popus
        icon:FluentIcons.ButtonMenu
        FluPaneItem{
            title:"Dialog"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Dialog.qml")
            }
        }
        FluPaneItem{
            id:item_combobox
            title:"ComboBox"
            count: 9
            infoBadge:FluBadge{
                count: item_combobox.count
                color: Qt.rgba(250/255,173/255,20/255,1)
            }
            onTap:{
                item_combobox.count = 0
                navigationView.push("qrc:/example/qml/page/T_ComboBox.qml")
            }
        }
        FluPaneItem{
            title:"Tooltip"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Tooltip.qml")
            }
        }
        FluPaneItem{
            title:"Menu"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Menu.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:lang.navigation
        icon:FluentIcons.AllApps
        FluPaneItem{
            title:"Pivot"
            image:"qrc:/example/res/image/control/Pivot.png"
            recentlyAdded:true
            order:3
            desc:"Presents information from different sources in atabbed view."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Pivot.qml")
            }
        }
        FluPaneItem{
            title:"BreadcrumbBar"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_BreadcrumbBar.qml")
            }
        }
        FluPaneItem{
            title:"TabView"
            image:"qrc:/example/res/image/control/TabView.png"
            recentlyAdded:true
            order:1
            desc:"A control that displays a collection of tabs thatcan be used to display several documents."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_TabView.qml")
            }
        }
        FluPaneItem{
            title:"TreeView"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_TreeView.qml")
            }
        }
        FluPaneItem{
            title:"TableView"
            image:"qrc:/example/res/image/control/DataGrid.png"
            recentlyAdded:true
            order:4
            desc:"The TableView control provides a flexible way to display a collection of data in rows and columns"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_TableView.qml")
            }
        }
        FluPaneItem{
            title:"Pagination"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Pagination.qml")
            }
        }
        FluPaneItem{
            title:"MultiWindow"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_MultiWindow.qml")
            }
        }
        FluPaneItem{
            title:"FlipView"
            image:"qrc:/example/res/image/control/FlipView.png"
            recentlyAdded:true
            order:2
            desc:"Presents a collection of items that the user canflip through, one item at a time."
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_FlipView.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:lang.theming
        icon:FluentIcons.Brightness
        FluPaneItem{
            title:"Acrylic"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Acrylic.qml")
            }
        }
        FluPaneItem{
            title:"Theme"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Theme.qml")
            }
        }
        FluPaneItem{
            title:"Typography"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Typography.qml")
            }
        }
        FluPaneItem{
            title:"Awesome"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Awesome.qml")
            }
        }
    }

    FluPaneItemSeparator{
        spacing:20
        size:1
    }

    FluPaneItemExpander{
        title:lang.other
        icon:FluentIcons.Shop
        FluPaneItem{
            title:"Http"
            onTap:{
                navigationView.push("qrc:/example/qml/page/T_Http.qml")
            }
        }
        FluPaneItem{
            id:item_other
            title:"RemoteLoader"
            count: 99
            infoBadge:FluBadge{
                count: item_other.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            onTap:{
                item_other.count = 0
                navigationView.push("qrc:/example/qml/page/T_RemoteLoader.qml")
            }
        }
        FluPaneItem{
            title:"HotLoader"
            tapFunc:function(){
                 FluApp.navigate("/hotload")
            }
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
