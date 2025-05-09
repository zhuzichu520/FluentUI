import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Badge")

    FluFrame{
        Layout.fillWidth: true
        height: 120
        padding: 10

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            FluText{
                wrapMode: Text.WrapAnywhere
                width: parent.width
                text: qsTr("It usually appears in the upper right corner of the notification icon or avatar to display the number of messages that need to be processed")
            }
            Flow{
                width: parent.width
                spacing: 20
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:0
                    }
                }

                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:5
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:50
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:1000
                        max: 999
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        isDot:true
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:99
                        color: Qt.rgba(250/255,173/255,20/255,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:99
                        color: Qt.rgba(82/255,196/255,26/255,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        showZero: true
                        count:100
                        color: Qt.rgba(84/255,169/255,1,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "bottomLeft"
                        showZero: true
                        count:100
                        color: Qt.rgba(84/255,169/255,1,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topLeft"
                        showZero: true
                        count:100
                        color: Qt.rgba(84/255,169/255,1,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "bottomRight"
                        showZero: true
                        count:100
                        color: Qt.rgba(84/255,169/255,1,1)
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        position: "topRight"
                        count: "NEW"
                        color: Qt.rgba(84/255,169/255,1,1)
                    }
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'Rectangle{
    width: 40
    height: 40
    radius: 8
    color: Qt.rgba(191/255,191/255,191/255,1)
    FluBadge{
        position: "topRight"
        count: 100
        max: 99
        isDot: false
        color: Qt.rgba(82/255,196/255,26/255,1)
    }
}'
    }

}
