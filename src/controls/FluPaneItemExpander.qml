import QtQuick 2.15
import FluentUI 1.0

FluObject {
    readonly property string key : FluApp.uuid()
    property string title
    property var icon
    property Component cusIcon
    property bool isExpand: false
    property var parent
    property int idx
}
