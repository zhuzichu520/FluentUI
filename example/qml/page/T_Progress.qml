import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import "../component"

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
                    progress_bar.progress = value/100
                    progress_ring.progress = value/100
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
