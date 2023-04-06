pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView

    FluPaneItem{
        title:"Home"
        icon:FluentIcons.Home
        onTap:{
            navigationView.push("qrc:/T_Home.qml")
        }
    }

    FluPaneItemExpander{
        title:"Basic input"
        icon:FluentIcons.CheckboxComposite
        FluPaneItem{
            title:"Buttons"
            image:"qrc:/res/image/control/Button.png"
            recentlyUpdated:true
            desc:"A control that responds to user input and raisesa Click event."
            onTap:{
                navigationView.push("qrc:/T_Buttons.qml")
            }
        }
        FluPaneItem{
            title:"Slider"
            image:"qrc:/res/image/control/Slider.png"
            recentlyUpdated:true
            desc:"A control that lets the user select from a rangeof values by moving a Thumb control along atrack."
            onTap:{
                navigationView.push("qrc:/T_Slider.qml")
            }
        }
        FluPaneItem{
            title:"CheckBox"
            image:"qrc:/res/image/control/Checkbox.png"
            recentlyUpdated:true
            desc:"A control that a user can select or clear."
            onTap:{
                navigationView.push("qrc:/T_CheckBox.qml")
            }
        }
        FluPaneItem{
            title:"ToggleSwitch"
            onTap:{
                navigationView.push("qrc:/T_ToggleSwitch.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Form"
        icon:FluentIcons.GridView
        FluPaneItem{
            title:"TextBox"
            onTap:{
                navigationView.push("qrc:/T_TextBox.qml")
            }
        }
        FluPaneItem{
            title:"TimePicker"
            onTap:{
                navigationView.push("qrc:/T_TimePicker.qml")
            }
        }
        FluPaneItem{
            title:"DatePicker"
            onTap:{
                navigationView.push("qrc:/T_DatePicker.qml")
            }
        }
        FluPaneItem{
            title:"CalendarPicker"
            onTap:{
                navigationView.push("qrc:/T_CalendarPicker.qml")
            }
        }
        FluPaneItem{
            title:"ColorPicker"
            onTap:{
                navigationView.push("qrc:/T_ColorPicker.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Surface"
        icon:FluentIcons.SurfaceHub
        FluPaneItem{
            title:"InfoBar"
            image:"qrc:/res/image/control/InfoBar.png"
            recentlyUpdated:true
            desc:"An inline message to display app-wide statuschange information."
            onTap:{
                navigationView.push("qrc:/T_InfoBar.qml")
            }
        }
        FluPaneItem{
            title:"Progress"
            onTap:{
                navigationView.push("qrc:/T_Progress.qml")
            }
        }
        FluPaneItem{
            title:"Badge"
            onTap:{
                navigationView.push("qrc:/T_Badge.qml")
            }
        }
        FluPaneItem{
            title:"Rectangle"
            onTap:{
                navigationView.push("qrc:/T_Rectangle.qml")
            }
        }
        FluPaneItem{
            title:"Carousel"
            onTap:{
                navigationView.push("qrc:/T_Carousel.qml")
            }
        }
        FluPaneItem{
            title:"Expander"
            onTap:{
                navigationView.push("qrc:/T_Expander.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Popus"
        icon:FluentIcons.ButtonMenu
        FluPaneItem{
            title:"Dialog"
            onTap:{
                navigationView.push("qrc:/T_Dialog.qml")
            }
        }
        FluPaneItem{
            title:"Tooltip"
            onTap:{
                navigationView.push("qrc:/T_Tooltip.qml")
            }
        }
        FluPaneItem{
            title:"Menu"
            onTap:{
                navigationView.push("qrc:/T_Menu.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Navigation"
        icon:FluentIcons.AllApps
        FluPaneItem{
            title:"Pivot"
            image:"qrc:/res/image/control/Pivot.png"
            recentlyAdded:true
            order:3
            desc:"Presents information from different sources in atabbed view."
            onTap:{
                navigationView.push("qrc:/T_Pivot.qml")
            }
        }
        FluPaneItem{
            title:"TabView"
            image:"qrc:/res/image/control/TabView.png"
            recentlyAdded:true
            order:1
            desc:"A control that displays a collection of tabs thatcan be used to display several documents."
            onTap:{
                navigationView.push("qrc:/T_TabView.qml")
            }
        }
        FluPaneItem{
            title:"TreeView"
            onTap:{
                navigationView.push("qrc:/T_TreeView.qml")
            }
        }
        FluPaneItem{
            title:"MultiWindow"
            onTap:{
                navigationView.push("qrc:/T_MultiWindow.qml")
            }
        }
        FluPaneItem{
            title:"FlipView"
            image:"qrc:/res/image/control/FlipView.png"
            recentlyAdded:true
            order:2
            desc:"Presents a collection of items that the user canflip through, one item at a time."
            onTap:{
                navigationView.push("qrc:/T_FlipView.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Theming"
        icon:FluentIcons.Brightness
        FluPaneItem{
            title:"Theme"
            onTap:{
                navigationView.push("qrc:/T_Theme.qml")
            }
        }
        FluPaneItem{
            title:"Typography"
            onTap:{
                navigationView.push("qrc:/T_Typography.qml")
            }
        }
        FluPaneItem{
            title:"Awesome"
            onTap:{
                navigationView.push("qrc:/T_Awesome.qml")
            }
        }
    }

    FluPaneItemExpander{
        title:"Media"
        icon:FluentIcons.Media
        FluPaneItem{
            title:"MediaPlayer"
            image:"qrc:/res/image/control/MediaPlayerElement.png"
            recentlyAdded:true
            order:0
            desc:"A control to display video and image content."
            onTap:{
                navigationView.push("qrc:/T_MediaPlayer.qml")
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
                arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }

    function startPageByItem(data){
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item =  items[i]
            if(item.key === data.key){
                if(navigationView.getCurrentIndex() === i){
                    return
                }
                item.tap()
                navigationView.setCurrentIndex(i)
                if(item.parent){
                    item.parent.isExpand = true
                }
                return
            }
        }
    }

}
