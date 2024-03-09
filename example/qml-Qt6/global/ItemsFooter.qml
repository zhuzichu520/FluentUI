pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView
    property var paneItemMenu

    id:footer_items

    FluPaneItemSeparator{}

    FluPaneItem{
        title:qsTr("About")
        icon:FluentIcons.Contact
        onTapListener:function(){
            FluApp.navigate("/about")
        }
    }

    FluPaneItem{
        title:qsTr("Settings")
        menuDelegate: paneItemMenu
        icon:FluentIcons.Settings
        url:"qrc:/example/qml/page/T_Settings.qml"
        onTap:{
            navigationView.push(url)
        }
    }

}
