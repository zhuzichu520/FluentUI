import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string key : FluTools.uuid()
    property int _idx
    property var _ext
    property var _parent
    property string title
    property int order : 0
    property var url
    property bool disabled: false
    property int icon
    property bool iconVisible: true
    property Component infoBadge
    property bool recentlyAdded: false
    property bool recentlyUpdated: false
    property string desc
    property var image
    property int count: 0
    property var onTapListener
    property Component iconDelegate
    property Component menuDelegate
    property Component editDelegate
    property bool showEdit
    signal tap
    signal dropped(var drag)
}
