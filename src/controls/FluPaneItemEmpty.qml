import QtQuick 2.15

QtObject {
    readonly property string key : FluApp.uuid()
    property var parent
    property int idx
}
