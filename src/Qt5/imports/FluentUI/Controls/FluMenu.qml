import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.Menu {
    property bool animationEnabled: true
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    margins: 0
    overlap: 1
    spacing: 0
    delegate: FluMenuItem { }
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from:0
            to:1
            duration: FluTheme.animationEnabled && control.animationEnabled ? 83 : 0
        }
    }
    exit:Transition {
        NumberAnimation {
            property: "opacity"
            from:1
            to:0
            duration: FluTheme.animationEnabled && control.animationEnabled ? 83 : 0
        }
    }
    contentItem: ListView {
        implicitHeight: contentHeight
        model: control.contentModel
        interactive: Window.window
                     ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height
                     : false
        clip: true
        currentIndex: control.currentIndex
        ScrollIndicator.vertical: ScrollIndicator {}
    }
    background: Rectangle {
        implicitWidth: 150
        implicitHeight: 36
        color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1)
        border.width: 1
        radius: 5
        FluShadow{}
    }
    T.Overlay.modal: Rectangle {
        color: FluTools.withOpacity(control.palette.shadow, 0.5)
    }
    T.Overlay.modeless: Rectangle {
        color: FluTools.withOpacity(control.palette.shadow, 0.12)
    }
}
