import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

QtObject {
    property string key
    property int _idx
    property var _ext
    property var _parent
    property bool visible: true
    Component.onCompleted: {
        key = FluTools.uuid()
    }
}
