import QtQuick

QtObject {
    readonly property string key : FluApp.uuid()
    property var parent
    property int idx
}
