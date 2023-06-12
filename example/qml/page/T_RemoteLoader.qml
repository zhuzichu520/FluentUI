import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluRemoteLoader{
    property int pageMode: FluNavigationView.Standard
    property string url: ''
    source: "https://zhu-zichu.gitee.io/T_RemoteLoader.qml"
}
