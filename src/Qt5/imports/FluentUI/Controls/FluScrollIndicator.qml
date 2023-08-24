import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.ScrollIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2

    contentItem: Rectangle {
        implicitWidth: 2
        implicitHeight: 2

        color: control.palette.mid
        visible: control.size < 1.0
        opacity: 0.0

        states: State {
            name: "active"
            when: control.active
            PropertyChanges {
                target: control
                contentItem.opacity: 0.75
            }
        }

        transitions: [
            Transition {
                from: "active"
                SequentialAnimation {
                    PauseAnimation {
                        duration: 450
                    }
                    NumberAnimation {
                        target: control.contentItem
                        duration: 200
                        property: "opacity"
                        to: 0.0
                    }
                }
            }
        ]
    }
}
