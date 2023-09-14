import QtQuick

QtObject {
    property string key
    property string title
    property var children: []
    property int depth: 0
    property bool isExpanded: true
    property var __parent
}
