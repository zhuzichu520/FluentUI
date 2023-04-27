import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string key : FluApp.uuid()
    property string title
    property var parent
    property int idx
}
