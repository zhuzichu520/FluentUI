import QtQuick
import FluentUI

FluObject {
    readonly property string key : FluApp.uuid()
    property string title
    property int icon
    property bool isExpand: false
    property var parent
    property int idx
}
