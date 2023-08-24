import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Progress"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 130
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: "indeterminate = true"
            }
            FluProgressBar{
            }
            FluProgressRing{
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluProgressBar{

}
FluProgressRing{

}
'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 286
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: "indeterminate = false"
            }
            FluProgressBar{
                indeterminate: false
                value:slider.value/100
                Layout.topMargin: 10
            }
            FluProgressBar{
                indeterminate: false
                value:slider.value/100
                progressVisible: true
                Layout.topMargin: 10
            }
            FluProgressRing{
                indeterminate: false
                value: slider.value/100
                Layout.topMargin: 10
            }
            FluProgressRing{
                progressVisible: true
                indeterminate: false
                value: slider.value/100
            }
            FluSlider{
                id:slider
                Component.onCompleted: {
                    value = 50
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluProgressBar{
    indeterminate: false
}
FluProgressRing{
    indeterminate: false
    progressVisible: true
}
'
    }


}
