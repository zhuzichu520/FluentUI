import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluClip {
    id: control
    default property alias content: container.data
    property alias spacing: container.spacing
    property alias backgroundItem: backgroundLoader.sourceComponent
    property alias backgroundAcrylic: acrylic
    property string backgroundSizeMode: "auto" // auto, cover, fixed
    property real backgroundMinHeight: -1
    property real speed: 0.5
    width: 400
    height: 300
    clip: true
    Item {
        width: parent.width
        height: {
            let h = 0
            switch (control.backgroundSizeMode) {
            case "auto":
                if (flickable.contentHeight > control.height) {
                    h = control.height + (flickable.contentHeight - control.height) * control.speed
                } else {
                    h = control.height
                }
                break
            case "fixed":
                h = control.height
                break
            case "cover":
            default:
                h = Math.max(control.height, flickable.contentHeight)
                break
            }
            return Math.max(h, backgroundMinHeight)
        }
        y: {
            if (control.backgroundSizeMode === "fixed") {
                return 0
            }
            return -flickable.contentY * control.speed
        }
        FluLoader {
            id: backgroundLoader
            anchors.fill: parent
        }
        FluAcrylic {
            id: acrylic
            anchors.fill: parent
            target: backgroundLoader.item
            tintOpacity: 0
            blurRadius: 0
        }
    }
    Flickable {
        id: flickable
        anchors.fill: parent
        ScrollBar.vertical: FluScrollBar {}
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: container.height
        ColumnLayout {
            id: container
            width: flickable.width
        }
    }
}
