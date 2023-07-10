import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Badge"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 106
        paddings: 10

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"一般出现在通知图标或头像的右上角，用于显示需要处理的消息条数"
            }

            Row{
                spacing: 20
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        topRight: true
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
                        topRight: true
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
                        topRight: true
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
                        topRight: true
                        showZero: true
                        count:100
                    }
                }
                Rectangle{
                    width: 40
                    height: 40
                    radius:  8
                    color: Qt.rgba(191/255,191/255,191/255,1)
                    FluBadge{
                        topRight: true
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
                        topRight: true
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
                        topRight: true
                        showZero: true
                        count:99
                        color: Qt.rgba(82/255,196/255,26/255,1)
                    }
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'Rectangle{
    width: 40
    height: 40
    radius: 8
    color: Qt.rgba(191/255,191/255,191/255,1)
    FluBadge{
        count: 100
        isDot: false
        color: Qt.rgba(82/255,196/255,26/255,1)
    }
}'
    }

}
