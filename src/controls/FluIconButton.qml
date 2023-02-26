import QtQuick 2.15

Rectangle {

    width: text.implicitWidth
    height: text.implicitHeight

    property int icon

    Text {
        id:text
        font.family: "fontawesome"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
//        text:icon
        text: (String.fromCharCode(icon).toString(16));
    }

}
