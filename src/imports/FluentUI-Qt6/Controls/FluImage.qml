import QtQuick
import QtQuick.Controls
import FluentUI

Item {
    property alias sourceSize : image.sourceSize
    property alias fillMode : image.fillMode
    property url source
    property string errorButtonText: "重新加载"
    property var status
    property var clickErrorListener : function(){
        image.source = ""
        image.source = control.source
    }
    id: control
    Image{
        id:image
        anchors.fill: parent
        source: control.source
        opacity: control.status === Image.Ready
        onStatusChanged:{
            control.status = image.status
        }
        Behavior on opacity {
            NumberAnimation{
                duration: 83
            }
        }
    }
    Rectangle{
        anchors.fill: parent
        color: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
        FluProgressRing{
            anchors.centerIn: parent
            visible: control.status === Image.Loading
        }
        FluFilledButton{
            text: control.errorButtonText
            anchors.centerIn: parent
            visible: control.status === Image.Error
            onClicked: clickErrorListener()
        }
    }
}
