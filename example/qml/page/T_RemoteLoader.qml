import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluPage{
    pageMode: FluNavigationView.SingleTop
    FluRemoteLoader{
        anchors.fill: parent
        source: "https://zhu-zichu.gitee.io/T_RemoteLoader.qml"
    }
}
