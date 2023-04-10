import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:///global/"
import FluentUI

FluWindow {
    id:rootwindow
    width: 1000
    height: 640
    title: "FluentUI"
    minimumWidth: 520
    minimumHeight: 460

    FluAppBar{
        id:appbar
        z:9
        showDark: true
        width:parent.width
        darkText: "Dark Mode"
    }

    FluNavigationView2{
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
            iconSource: FluentIcons.Zoom
            items: ItemsOriginal.getSearchData()
            placeholderText: "Search"
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
