import QtQuick
import FluentUI

FluObject {
    readonly property int flag : 3
    readonly property string key : FluApp.uuid()
    property string title
    property int icon
    property bool isExpand: false
    property var parent
    property int idx
    signal tap
    signal repTap
}
