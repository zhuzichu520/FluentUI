import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string key : FluTools.uuid()
    property int _idx
    property var _ext
    property var _parent
    property string title
    property var url
    property bool disabled: false
    property int icon
    property bool iconVisible: true
    property Component infoBadge
    property int count: 0
    property var onTapListener
    property Component iconDelegate
    property Component menuDelegate
    property Component editDelegate
    property var extra
    property bool showEdit
    signal tap
}
