import QtQuick

QtObject {
    readonly property int flag : 1
    readonly property string key : FluApp.uuid()
    property string title
    property var parent
    property int idx
}
