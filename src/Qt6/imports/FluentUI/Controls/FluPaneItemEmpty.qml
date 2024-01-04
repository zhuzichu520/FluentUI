import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string key : FluTools.uuid()
    property int _idx
    property var _ext
    property var _parent
    property bool visible: true
}
