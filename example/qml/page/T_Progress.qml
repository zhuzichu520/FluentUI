import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Progress"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 260
        paddings: 10
        ColumnLayout{
            spacing: 20
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluProgressBar{
            }
            FluProgressRing{
            }
            FluProgressBar{
                id:progress_bar
                indeterminate: false
            }
            FluProgressRing{
                id:progress_ring
                indeterminate: false
            }
            FluSlider{
                value:50
                onValueChanged:{
                    var progress = value/100
                    progress_bar.progress = progress
                    progress_ring.progress = progress
                }
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

FluProgressBar{
    indeterminate: false
}

FluProgressRing{
    indeterminate: false
}'
    }



}
