import QtQuick
import FluentUI

QtObject {
    readonly property string key : FluApp.uuid()
    property string title
    property int icon
    property bool recentlyAdded: false
    property bool recentlyUpdated: false
    property string desc
    property var image
    signal tap
    signal repTap
}
