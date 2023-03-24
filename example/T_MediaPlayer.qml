import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import FluentUI 1.0

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

