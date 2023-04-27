pragma Singleton

import QtQuick
import FluentUI

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
            navigationView.push("qrc:/example/qml/page/T_Settings.qml")
        }
    }
}
