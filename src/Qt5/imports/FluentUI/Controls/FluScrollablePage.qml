import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluPage {
    id: control
    property bool autoResetScroll: false
    default property alias content: container.data

    Flickable{
        id: flickable
        clip: true
        anchors.fill: parent
        ScrollBar.vertical: FluScrollBar {
            id: bar
        }
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: container.height
        ColumnLayout {
            id: container
            width: parent.width - bar.width
            spacing: control.spacing
        }
    }

    function resetScroll() {
        flickable.contentY = 0;
    }

    StackView.onActivated: {
        if (autoResetScroll) {
            resetScroll(); // Call this function to reset the scroll position to the top
        }
    }
}
