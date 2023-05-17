import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import FluentUI

Window {
    id:app
    MediaPlayer{}
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.darkMode = FluDarkMode.System
        FluApp.routes = {
            "/":"qrc:/example/qml/window/MainWindow.qml",
            "/about":"qrc:/example/qml/window/AboutWindow.qml",
            "/login":"qrc:/example/qml/window/LoginWindow.qml",
            "/media":"qrc:/example/qml/window/MediaWindow.qml",
            "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
