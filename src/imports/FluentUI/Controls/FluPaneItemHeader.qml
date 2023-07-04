import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    readonly property string _key : FluTools.uuid()
    property int _idx
    property string title
    property var parent
}
