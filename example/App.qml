import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Window {
    id:app
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.frameless = ("windows" === Qt.platform.os)
        FluTheme.darkMode = FluDarkMode.System
        FluApp.routes = {
            "/":"qrc:/page/MainPage.qml",
            "/about":"qrc:/page/AboutPage.qml",
            "/login":"qrc:/page/LoginPage.qml",
            "/chat":"qrc:/page/ChatPage.qml",
            "/media":"qrc:/page/MediaPage.qml",
            "/singleTaskWindow":"qrc:/page/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/page/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/page/SingleInstanceWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
