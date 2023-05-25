import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FluentUI 1.0
import FluentGlobal 1.0 as G

Window {
    id:app
    Component.onCompleted: {
        G.FluApp.init(app)
        G.FluTheme.darkMode = FluDarkMode.System
        G.FluApp.routes = {
            "/":"qrc:/example/qml/window/MainWindow.qml",
            "/about":"qrc:/example/qml/window/AboutWindow.qml",
            "/login":"qrc:/example/qml/window/LoginWindow.qml",
            "/media":"qrc:/example/qml/window/MediaWindow.qml",
            "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml"
        }
        G.FluApp.initialRoute = "/"
        G.FluApp.run()
    }
}
