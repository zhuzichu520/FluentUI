import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

QtObject {
    readonly property string key : FluTools.uuid()
    property int _idx
    property var _ext
    property string title
    property int order : 0
    property int icon
    property var url
    property bool disabled: false
    property Component cusIcon
    property Component infoBadge
    property bool recentlyAdded: false
    property bool recentlyUpdated: false
    property string desc
    property var image
    property var parent
    property int count: 0
    signal tap
    property var onTapListener
    property Component menuDelegate
    property Component editDelegate
    property bool showEdit
    signal dropped(var drag)
}
