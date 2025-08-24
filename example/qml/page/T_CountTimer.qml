import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("CountTimer")

    FluFrame {
        Layout.fillWidth: true
        padding: 10
        ColumnLayout {
            RowLayout {
                FluCountTimer {
                    id: t1
                    value: 25 * 3600 * 1000
                    interval: 33
                    format: "hh:mm:ss.zzz"
                    Component.onCompleted: {
                        t1.start()
                    }
                }
                FluText {
                    text: qsTr("Countdown milliseconds: %1").arg(t1.time)
                }
            }
            RowLayout {
                FluCountTimer {
                    id: t2
                    value: 10000
                    Component.onCompleted: {
                        t2.start()
                    }
                }
                FluText {
                    text: qsTr("Countdown seconds: %1").arg(t2.time)
                }
                FluButton {
                    text: t2.running ? "Stop" : "Start"
                    onClicked: {
                        if (t2.running) {
                            t2.stop()
                        } else {
                            t2.start()
                        }
                    }
                }
                FluButton {
                    text: "Reset"
                    onClicked: {
                        t2.reset(10000)
                    }
                }
            }
            RowLayout {
                FluCountTimer {
                    id: t3
                    countType: FluCountTimer.Countup
                    Component.onCompleted: {
                        t3.start()
                    }
                }
                FluText {
                    text: qsTr("Countup seconds: %1").arg(t3.time)
                }
                FluButton {
                    text: t3.running ? "Stop" : "Start"
                    onClicked: {
                        if (t3.running) {
                            t3.stop()
                        } else {
                            t3.start()
                        }
                    }
                }
                FluButton {
                    text: "Reset"
                    onClicked: {
                        t3.reset(0)
                    }
                }
            }
        }
    }
    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluCountTimer {
    countType: FluCountTimer.Countdown
    value: 24 * 3600 * 1000
    interval: 33
    format: "hh:mm:ss.zzz"
    Component.onCompleted: {
        start()
    }
}'
    }
}
