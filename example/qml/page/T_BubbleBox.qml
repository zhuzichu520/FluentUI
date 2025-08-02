import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("BubbleBox")

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: grid.height + topPadding + bottomPadding
        padding: 10
        Grid {
            id: grid
            width: parent.width
            columns: 2
            spacing: 20
            RowLayout {
                FluText {
                    text: qsTr("bubblebox offset:")
                }
                FluSlider {
                    id: boxSlider
                    value: 0.5
                    stepSize: 0.1
                    from: 0
                    to: 1
                }
            }
            RowLayout {
                FluText {
                    text: qsTr("traingle offset:")
                }
                FluSlider {
                    id: traingleSlider
                    value: 0.5
                    stepSize: 0.1
                    from: 0
                    to: 1
                }
            }
            RowLayout {
                FluText {
                    text: qsTr("direction:")
                }
                FluComboBox {
                    id: directionBox
                    textRole: "key"
                    valueRole: "value"
                    model: ListModel {
                        ListElement {
                            key: qsTr("top")
                            value: "top"
                        }
                        ListElement {
                            key: qsTr("right")
                            value: "right"
                        }
                        ListElement {
                            key: qsTr("bottom")
                            value: "bottom"
                        }
                        ListElement {
                            key: qsTr("left")
                            value: "left"
                        }
                    }
                }
            }
        }
    }

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 200 + topPadding + bottomPadding + bubbleBox.triangleHeight
        padding: 10
        FluButton {
            id: btn
            anchors.centerIn: parent
            text: qsTr("Standard Button")
        }
        FluBubbleBox {
            id: bubbleBox
            width: 150
            height: 50
            attachTarget: btn
            attachDirection: directionBox.currentValue
            targetAlignRatio: boxSlider.value
            triangleWidth: 30
            triangleHeight: 20
            triangleOffsetRatio: traingleSlider.value
            FluText {
                anchors.centerIn: parent
                text: qsTr("BubbleBox")
            }
        }
    }
    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluButton {
    id: btn
    anchors.centerIn: parent
    text: "Button"
}
FluBubbleBox {
    id: bubbleBox
    width: 150
    height: 50
    attachTarget: btn
    attachDirection: "top"
    targetAlignRatio: 0.5
    triangleWidth: 30
    triangleHeight: 20
    triangleOffsetRatio: 0.5
    FluText {
        anchors.centerIn: parent
        text: "BubbleBox"
    }
}'
    }
}
