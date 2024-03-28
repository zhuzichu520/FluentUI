import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    property string key
    property int _idx
    property bool visible: true
    property string title
    property var parent
    Component.onCompleted: {
        key = FluTools.uuid()
    }
}
