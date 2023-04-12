import QtQuick
import FluentUI

FluObject {
    readonly property string key : FluApp.uuid()
    property string title
    property var icon
    property Component cusIcon
    property bool isExpand: false
    property var parent
    property int idx
}
