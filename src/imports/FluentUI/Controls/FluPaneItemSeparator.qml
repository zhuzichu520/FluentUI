import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string key : FluTools.uuid()
    property int _idx
    property var parent
    property real spacing
    property int size:1
}
