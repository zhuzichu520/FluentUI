import QtQuick
import QtQuick.Controls
import FluentUI

QtObject {
    id:control
    property string name
    signal triggered(var data)
    Component.onCompleted: {
        FluEventBus.register(control)
    }
    Component.onDestruction: {
        FluEventBus.unregister(control)
    }
}
