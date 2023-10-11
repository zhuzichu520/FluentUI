pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView

    id:footer_items

    FluPaneItemSeparator{}

    FluPaneItem{
        title:Lang.about
        icon:FluentIcons.Contact
        onDropped: { FluApp.navigate("/about") }
        onTapListener:function(){
            FluApp.navigate("/about")
        }
    }

    FluPaneItem{
        title:Lang.settings
        icon:FluentIcons.Settings
        url:"qrc:/example/qml/page/T_Settings.qml"
        onDropped:{ FluApp.navigate("/pageWindow",{title:title,url:url}) }
        onTap:{
            navigationView.push(url)
        }
    }

}
