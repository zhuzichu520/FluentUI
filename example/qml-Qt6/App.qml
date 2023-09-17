import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Window {
    id: app
    flags: Qt.SplashScreen

    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }

    FluHttpInterceptor{
        id:interceptor
        function onIntercept(request){
            if(request.method === "get"){
                request.params["method"] = "get"
            }
            if(request.method === "post"){
                request.params["method"] = "post"
            }
            request.headers["token"] ="yyds"
            request.headers["os"] ="pc"
            console.debug(JSON.stringify(request))
            return request
        }
    }

    Component.onCompleted: {
        FluApp.init(app)
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
        FluApp.httpInterceptor = interceptor
        FluApp.run()
    }
}
