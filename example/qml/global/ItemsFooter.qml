pragma Singleton

import QtQuick 2.12
import FluentUI 1.0

FluObject{

    property var navigationView

    id:footer_items

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
