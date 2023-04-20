pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{
    id:footer_items

    property var navigationView

    FluPaneItemSeparator{}
    FluPaneItem{
        title:lang.about
        icon:FluentIcons.Contact
        tapFunc:function(){
            FluApp.navigate("/about")
        }
    }
    FluPaneItem{
        title:lang.settings
        icon:FluentIcons.Settings
        onTap:{
            navigationView.push("qrc:/T_Settings.qml")
        }
    }
}
