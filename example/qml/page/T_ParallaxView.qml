import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("ParallaxView")

    FluFrame {
        Layout.fillWidth: true
        padding: 10
        ColumnLayout {
            anchors {
                left: parent.left
                right: parent.right
            }
            RowLayout {
                FluText {
                    text: qsTr("Background size mode:")
                }
                FluComboBox {
                    id: mode_box
                    textRole: "key"
                    valueRole: "value"
                    model: ListModel {
                        ListElement {
                            key: qsTr("Auto")
                            value: "auto"
                        }
                        ListElement {
                            key: qsTr("Cover")
                            value: "cover"
                        }
                        ListElement {
                            key: qsTr("Fixed")
                            value: "fixed"
                        }
                    }
                }
            }
            RowLayout {
                FluText {
                    text: qsTr("Speed:")
                }
                FluSlider{
                    id: speed_slider
                    from: 0
                    to: 1
                    stepSize: 0.1
                    value: 0.5
                }
            }
            FluParallaxView {
                id: view1
                width: 1920 / 4
                height: 1200 / 4
                backgroundSizeMode: mode_box.currentValue
                speed: speed_slider.value
                backgroundItem: FluImage {
                    source: "qrc:/example/res/image/bg_scenic.jpg"
                    sourceSize: Qt.size(2 * width, 2 * height)
                }
                backgroundAcrylic.blurRadius: 16
                Repeater {
                    model: 20
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: view1.height / 10
                        FluText {
                            anchors.centerIn: parent
                            text: "Item %1".arg(index + 1)
                            color: FluColors.Grey10
                        }
                    }
                }
            }
        }
    }
    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluParallaxView {
    id: view1
    width: 1920 / 4
    height: 1200 / 4
    backgroundItem: FluImage {
        source: "qrc:/example/res/image/bg_scenic.jpg"
        sourceSize: Qt.size(2 * width, 2 * height)
    }
    backgroundAcrylic.blurRadius: 16
    Repeater {
        model: 20
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: view1.height / 10
            FluText {
                anchors.centerIn: parent
                text: "Item %1".arg(index + 1)
                color: FluColors.Grey10
            }
        }
    }
}'
    }

    FluFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: view2.height + topPadding + bottomPadding
        Layout.topMargin: 20
        padding: 10
        FluParallaxView {
            id: view2
            width: 1920 / 4
            height: 1200 / 4
            radius: [8, 8, 8, 8]
            backgroundItem: Rectangle {
                gradient: Gradient.RainyAshville
            }
            Repeater {
                model: 50
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: view2.height / 10
                    FluText {
                        anchors.centerIn: parent
                        text: "Item %1".arg(index + 1)
                        color: FluColors.Grey10
                    }
                }
            }
        }
    }
    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluParallaxView {
    id: view2
    width: 1920 / 4
    height: 1200 / 4
    radius: [8, 8, 8, 8]
    backgroundItem: Rectangle {
        gradient: Gradient.RainyAshville
    }
    Repeater {
        model: 50
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: view2.height / 10
            FluText {
                anchors.centerIn: parent
                text: "Item %1".arg(index + 1)
                color: FluColors.Grey10
            }
        }
    }
}'
    }
}
