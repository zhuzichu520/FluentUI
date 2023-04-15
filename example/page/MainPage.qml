import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "qrc:///global/"

FluWindow {
    id:window
    width: 1000
    height: 640
    title: "FluentUI"
    closeDestory:false
    minimumWidth: 520
    minimumHeight: 460

    FluAppBar{
        id:appbar
        z:9
        showDark: true
        width:parent.width
        darkText: lang.dark_mode
    }

    SystemTrayIcon {
        visible: true
        icon.source: "qrc:/res/image/favicon.ico"

        onActivated: {
            window.show()
            window.raise()
            window.requestActivate()
        }
    }


    FluNavigationView{
        id:nav_view
        anchors.fill: parent
        items: ItemsOriginal
        footerItems:ItemsFooter
        z:11
        displayMode:MainEvent.displayMode
        logo: "qrc:/res/image/favicon.ico"
        title:"FluentUI"
        autoSuggestBox:FluAutoSuggestBox{
            width: 280
            anchors.centerIn: parent
            iconSource: FluentIcons.Search
            items: ItemsOriginal.getSearchData()
            placeholderText: lang.search
            onItemClicked:
                (data)=>{
                    ItemsOriginal.startPageByItem(data)
                }
        }
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            ItemsFooter.navigationView = nav_view
            nav_view.setCurrentIndex(0)
        }
    }

}
