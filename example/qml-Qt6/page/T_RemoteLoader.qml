import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluPage{
    launchMode: FluPageType.SingleTop
    FluRemoteLoader{
        anchors.fill: parent
        source: "https://zhu-zichu.gitee.io/T_RemoteLoader.qml"
    }
}
