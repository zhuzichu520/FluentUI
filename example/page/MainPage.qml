import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls  2.15
import QtQuick.Layouts 1.15
import "qrc:///global/"
import FluentUI 1.0

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
