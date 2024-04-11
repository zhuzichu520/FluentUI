import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import example 1.0
import "../component"

FluContentPage{

    title: qsTr("OpenGL")


    FluFrame{
        anchors.fill: parent

        OpenGLItem{
            width: 320
            height: 480
            SequentialAnimation on t {
                NumberAnimation { to: 1; duration: 2500; easing.type: Easing.InQuad }
                NumberAnimation { to: 0; duration: 2500; easing.type: Easing.OutQuad }
                loops: Animation.Infinite
                running: true
            }
        }

    }



}
