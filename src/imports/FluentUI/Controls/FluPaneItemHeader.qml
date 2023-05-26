import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0


QtObject {
    readonly property string key : FluTools.uuid()
    property string title
    property var parent
    property int idx
}
