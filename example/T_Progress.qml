import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"Progress"
        fontStyle: FluText.TitleLarge
    }
    ScrollView{
        clip: true
        width: parent.width
        contentWidth: parent.width
        anchors{
            top: title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            spacing: 5
            FluProgressBar{
                Layout.topMargin: 20
            }
            FluProgressRing{
                Layout.topMargin: 10
            }
            FluProgressBar{
                id:progress_bar
                Layout.topMargin: 20
                indeterminate: false
            }
            FluProgressRing{
                id:progress_ring
                Layout.topMargin: 10
                indeterminate: false
            }
            FluSlider{
                Layout.topMargin: 30
                value:50
                onValueChanged:{
                    progress_bar.progress = value/100
                    progress_ring.progress = value/100
                }
                Layout.bottomMargin: 30
            }
        }
    }
}
