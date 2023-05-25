import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "qrc:///example/qml/global/"

FluWindow {

    id:window
    title: "FluentUI"
    width: 1000
    height: 640
    closeDestory:false
    minimumWidth: 520
    minimumHeight: 460
    launchMode: FluWindow.SingleTask
    visible: true

    Component.onCompleted: {
//        FluApp.init(window)
    }

    FluNavigationView2{
        id:nav_view
        anchors.fill: parent
        items: ItemsOriginal
        footerItems:ItemsFooter
        z:11
        displayMode:MainEvent.displayMode
        logo: "qrc:/example/res/image/favicon.ico"
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
        actionItem:Item{
            height: 40
            width: 148
            RowLayout{
                anchors.centerIn: parent
                spacing: 5
                FluText{
                    text:lang.dark_mode
                }
                FluToggleSwitch{
                    selected: FluTheme.dark
                    clickFunc:function(){
                        if(FluTheme.dark){
                            FluTheme.darkMode = FluDarkMode.Light
                        }else{
                            FluTheme.darkMode = FluDarkMode.Dark
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            ItemsFooter.navigationView = nav_view
//            nav_view.setCurrentIndex(0)
        }
    }

}
