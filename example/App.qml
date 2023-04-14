import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls  2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import FluentUI 1.0

Window {
    id:app
    color: "#00000000"
    //初始化一个MediaPlayer，解决macos切换到T_MediaPalyer页面崩溃问题
    MediaPlayer{}
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.frameless = ("windows" === Qt.platform.os)
        FluTheme.dark = false
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
