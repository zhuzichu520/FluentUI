import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

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
        function onUseSystemAppBarChanged(){
            SettingsHelper.saveUseSystemAppBar(FluApp.useSystemAppBar)
        }
    }

    Connections{
        target: TranslateHelper
        function onCurrentChanged(){
            SettingsHelper.saveLanguage(TranslateHelper.current)
        }
    }

    Component.onCompleted: {
        FluNetwork.openLog = false
        FluNetwork.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app)
        FluApp.windowIcon = "qrc:/example/res/image/favicon.ico"
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/":"qrc:/example/qml/window/MainWindow.qml",
            "/about":"qrc:/example/qml/window/AboutWindow.qml",
            "/login":"qrc:/example/qml/window/LoginWindow.qml",
            "/hotload":"qrc:/example/qml/window/HotloadWindow.qml",
            "/crash":"qrc:/example/qml/window/CrashWindow.qml",
            "/fluentInitalizr":"qrc:/example/qml/window/FluentInitalizrWindow.qml",
            "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml",
            "/pageWindow":"qrc:/example/qml/window/PageWindow.qml"
        }
        var args = Qt.application.arguments
        if(args.length>=2 && args[1].startsWith("-crashed=")){
            FluApp.navigate("/crash",{crashFilePath:args[1].replace("-crashed=","")})
        }else{
            FluApp.navigate("/")
        }
    }
}
