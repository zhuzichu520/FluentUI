import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import FluentUI

FluScrollablePage{

    title:"MediaPlayer"

    FluArea{
        width: parent.width
        height: 320
        Layout.topMargin: 20
        paddings: 10
        ColumnLayout{
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            FluMediaPlayer{
                source:"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
            }

        }
    }


}

