import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    id: app

    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }

    Connections{
        target: FluApp
        function onVsyncChanged(){
            SettingsHelper.saveVsync(FluApp.vsync)
        }
        function onUseSystemAppBarChanged(){
            SettingsHelper.saveUseSystemAppBar(FluApp.useSystemAppBar)
        }
    }

    Component.onCompleted: {
        FluNetwork.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app)
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluApp.vsync = SettingsHelper.getVsync()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/":"qrc:/example/qml/window/MainWindow.qml",
            "/about":"qrc:/example/qml/window/AboutWindow.qml",
            "/login":"qrc:/example/qml/window/LoginWindow.qml",
            "/hotload":"qrc:/example/qml/window/HotloadWindow.qml",
            "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml",
            "/pageWindow":"qrc:/example/qml/window/PageWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
