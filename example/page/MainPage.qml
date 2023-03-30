import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
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
        z:10
        showDark: true
    }


    FluNavigationView{
        id:nav_view
        anchors.fill: parent
        items: ItemsOriginal
        footerItems:ItemsFooter
        logo: "qrc:/res/image/favicon.ico"
        z: 11
        title:"FluentUI"
        autoSuggestBox:FluAutoSuggestBox{
            width: 280
            anchors.centerIn: parent
            iconSource: FluentIcons.Zoom
            items: ItemsOriginal.getSearchData()
            placeholderText: "查找"
            onItemClicked:
                (data)=>{
                    ItemsOriginal.startPageByItem(data)
                }
        }
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            nav_view.setCurrentIndex(0)
            nav_view.push("qrc:/T_Home.qml")
        }
    }

}
