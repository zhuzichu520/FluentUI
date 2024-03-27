import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

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
