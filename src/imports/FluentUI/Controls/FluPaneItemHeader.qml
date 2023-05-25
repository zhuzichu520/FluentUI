import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G

QtObject {
    readonly property string key : G.FluTools.uuid()
    property string title
    property var parent
    property int idx
}
