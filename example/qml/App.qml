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
            "/":"qrc:/qml/window/MainWindow.qml",
            "/about":"qrc:/qml/window/AboutWindow.qml",
            "/login":"qrc:/qml/window/LoginWindow.qml",
            "/chat":"qrc:/qml/window/ChatWindow.qml",
            "/media":"qrc:/qml/window/MediaWindow.qml",
            "/singleTaskWindow":"qrc:/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/qml/window/SingleInstanceWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
